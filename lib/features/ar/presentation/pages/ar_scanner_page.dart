import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';
import 'package:linguaverse/shared/utils/constants.dart';
import '../providers/ar_providers.dart';
import '../widgets/ar_camera_view.dart';
import '../widgets/ar_language_selector.dart';
import '../../data/mock/m4_mock_data.dart';

class ArScannerPage extends ConsumerStatefulWidget {
  const ArScannerPage({super.key});

  @override
  ConsumerState<ArScannerPage> createState() => _ArScannerPageState();
}

class _ArScannerPageState extends ConsumerState<ArScannerPage> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _hasPermission = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestPermissionAndInit();

    ref.read(arObjectServiceProvider).initialize();
    ref.read(arTextServiceProvider).initialize();
  }

  Future<void> _requestPermissionAndInit() async {
    final status = await Permission.camera.request();
    if (!mounted) return;

    if (status.isGranted) {
      setState(() => _hasPermission = true);
      await _initCamera();
    } else {
      setState(() => _hasPermission = false);
    }
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;

    _cameraController = CameraController(
      _cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );

    await _cameraController!.initialize();
    if (!mounted) return;

    setState(() => _isCameraInitialized = true);

    final mode = ref.read(arScanModeProvider);
    if (mode == ArScanMode.object) {
      _startObjectDetectionStream();
    }
  }

  void _startObjectDetectionStream() {
    if (_cameraController == null || !_isCameraInitialized) return;

    _cameraController!.startImageStream((CameraImage image) async {
      if (!mounted) return;
      final mode = ref.read(arScanModeProvider);
      if (mode != ArScanMode.object) return;

      final rotation = _getRotation();
      final detections = await ref.read(arObjectServiceProvider).processFrame(image, rotation);

      if (!mounted || detections == null) return;
      final lang = ref.read(arTargetLanguageProvider);
      ref.read(arScannerProvider.notifier).updateDetections(detections, lang);
    });
  }

  Future<void> _stopObjectDetectionStream() async {
    try {
      await _cameraController?.stopImageStream();
    } catch (_) {}
  }

  Future<void> _captureForTextRecognition() async {
    if (_isCapturing || _cameraController == null) return;
    setState(() => _isCapturing = true);
    HapticFeedback.mediumImpact();

    try {
      await _stopObjectDetectionStream();

      // Petit délai pour s'assurer que le flux est bien arrêté niveau matériel
      await Future.delayed(const Duration(milliseconds: 300));

      final xFile = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(xFile.path);
      final detection = await ref.read(arTextServiceProvider).processCapture(inputImage);

      if (!mounted) return;

      if (detection?.detectedText != null) {
        final lang = ref.read(arTargetLanguageProvider);
        await ref
            .read(arScannerProvider.notifier)
            .translateCapturedText(detection!.detectedText!, lang);
        HapticFeedback.heavyImpact();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Aucun texte détecté — pointez plus près'),
            backgroundColor: AppColors.bgLevel2,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ));
        }
      }
    } catch (_) {
      // Erreur capture
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  void _onModeChanged(ArScanMode newMode) {
    final currentMode = ref.read(arScanModeProvider);
    if (currentMode == newMode) return;

    HapticFeedback.selectionClick();
    ref.read(arScanModeProvider.notifier).state = newMode;
    ref.read(arScannerProvider.notifier).clearCapturedTranslation();

    if (newMode == ArScanMode.object) {
      _startObjectDetectionStream();
    } else {
      _stopObjectDetectionStream();
    }
  }

  InputImageRotation _getRotation() {
    final sensorOrientation = _cameras.isNotEmpty ? _cameras.first.sensorOrientation : 0;
    return switch (sensorOrientation) {
      90 => InputImageRotation.rotation90deg,
      180 => InputImageRotation.rotation180deg,
      270 => InputImageRotation.rotation270deg,
      _ => InputImageRotation.rotation0deg,
    };
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_isCameraInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController!.dispose();
      _isCameraInitialized = false;
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(arScanModeProvider);
    final arState = ref.watch(arScannerProvider);
    final lang = ref.watch(arTargetLanguageProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── COUCHE 1 : Prévisualisation caméra ──────────────
          if (!_hasPermission)
            _buildPermissionDenied()
          else if (!_isCameraInitialized)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          else
            ArCameraView(
              controller: _cameraController!,
              detections: mode == ArScanMode.object ? arState.detections : [],
              translations: arState.translations,
              targetLanguage: lang,
              capturedTranslation: arState.capturedTranslation,
              isTranslating: arState.isTranslating,
            ),

          // ── COUCHE 2 : UI controls ─────────────────────────

          // Bouton retour
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),

          // Compteur API (mode texte seulement)
          if (mode == ArScanMode.text)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: arState.apiCallsRemaining > 0
                        ? AppColors.xpGold.withValues(alpha: 0.5)
                        : AppColors.wrongRed.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  '${arState.apiCallsRemaining}/${AppConstants.aiQuotaPerDay} traductions',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: arState.apiCallsRemaining > 0 ? AppColors.xpGold : AppColors.wrongRed,
                  ),
                ),
              ),
            ),

          // Sélecteur de langue
          Positioned(
            top: MediaQuery.of(context).padding.top + 56,
            left: 12,
            right: 12,
            child: ArLanguageSelector(
              selectedLanguage: lang,
              availableLanguages: M4MockData.availableLanguages,
              onLanguageChanged: (newLang) {
                ref.read(arTargetLanguageProvider.notifier).state = newLang;
                ref.read(arScannerProvider.notifier).clearCapturedTranslation();
              },
            ),
          ),

          // Sélecteur de mode
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 100,
            left: 0,
            right: 0,
            child: _buildModeSelector(mode),
          ),

          // Message d'aide
          if (arState.detections.isEmpty &&
              arState.capturedTranslation == null &&
              !arState.isTranslating)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 180,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    mode == ArScanMode.object
                        ? M4MockData.uiMessages['scanPrompt']!
                        : M4MockData.uiMessages['textScanPrompt']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          // Bouton capture (mode texte)
          if (mode == ArScanMode.text)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _isCapturing ? null : _captureForTextRecognition,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: _isCapturing ? 60 : 72,
                    height: _isCapturing ? 60 : 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      color: _isCapturing
                          ? AppColors.primary.withValues(alpha: 0.8)
                          : Colors.white.withValues(alpha: 0.15),
                    ),
                    child: _isCapturing
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                  ),
                ),
              ),
            ),

          // Message d'erreur
          if (arState.errorMessage != null)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 140,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.wrongRed.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppColors.wrongRed.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.wrongRed,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        arState.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.wrongRed,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => ref.read(arScannerProvider.notifier).clearError(),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.wrongRed,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModeSelector(ArScanMode currentMode) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _modePill(
              label: M4MockData.uiMessages['modeObject']!,
              icon: Icons.search_rounded,
              selected: currentMode == ArScanMode.object,
              onTap: () => _onModeChanged(ArScanMode.object),
            ),
            const SizedBox(width: 4),
            _modePill(
              label: M4MockData.uiMessages['modeText']!,
              icon: Icons.translate_rounded,
              selected: currentMode == ArScanMode.text,
              onTap: () => _onModeChanged(ArScanMode.text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modePill({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.85) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white.withValues(alpha: selected ? 1.0 : 0.5),
              size: 14,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: Colors.white.withValues(alpha: selected ? 1.0 : 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white54,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Caméra non autorisée',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              M4MockData.uiMessages['cameraPermission']!,
              style: const TextStyle(color: Colors.white60, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: openAppSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Ouvrir les paramètres'),
            ),
          ],
        ),
      ),
    );
  }
}
