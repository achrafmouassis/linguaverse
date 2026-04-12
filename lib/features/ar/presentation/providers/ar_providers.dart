import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linguaverse/features/gamification/gamification_exports.dart';
import '../../data/mock/m4_mock_data.dart';
import '../../data/models/ar_detection_model.dart';
import '../../data/models/ar_translation_model.dart';
import '../../data/services/ar_object_service.dart';
import '../../data/services/ar_text_service.dart';
import '../../data/services/ar_translation_service.dart';

// ── Services (singletons) ──────────────────────────────────────────
final arObjectServiceProvider = Provider<ArObjectService>((ref) {
  final service = ArObjectService();
  ref.onDispose(() => service.dispose());
  return service;
});

final arTextServiceProvider = Provider<ArTextService>((ref) {
  final service = ArTextService();
  ref.onDispose(() => service.dispose());
  return service;
});

final arTranslationServiceProvider = Provider<ArTranslationService>((ref) {
  return ArTranslationService();
});

// ── Langue cible sélectionnée ──────────────────────────────────────
final arTargetLanguageProvider = StateProvider.autoDispose<String>((ref) {
  return M4MockData.defaultTargetLanguage; // 'Arabe'
});

// ── Mode de scan (objets ou texte) ────────────────────────────────
enum ArScanMode { object, text }

final arScanModeProvider = StateProvider.autoDispose<ArScanMode>((ref) {
  return ArScanMode.object;
});

// ── État principal de l'écran AR ──────────────────────────────────
final arScannerProvider =
    StateNotifierProvider.autoDispose<ArScannerNotifier, ArScannerState>((ref) {
  return ArScannerNotifier(ref);
});

class ArScannerState {
  final List<ArDetectionModel> detections;
  final Map<String, ArTranslationModel> translations;
  final bool isProcessing;
  final bool isTranslating;
  final String? errorMessage;
  final int apiCallsRemaining;
  final ArTranslationModel? capturedTranslation;

  const ArScannerState({
    this.detections = const [],
    this.translations = const {},
    this.isProcessing = false,
    this.isTranslating = false,
    this.errorMessage,
    this.apiCallsRemaining = 5,
    this.capturedTranslation,
  });

  ArScannerState copyWith({
    List<ArDetectionModel>? detections,
    Map<String, ArTranslationModel>? translations,
    bool? isProcessing,
    bool? isTranslating,
    String? errorMessage,
    int? apiCallsRemaining,
    ArTranslationModel? capturedTranslation,
    bool clearCaptured = false,
    bool clearError = false,
  }) =>
      ArScannerState(
        detections: detections ?? this.detections,
        translations: translations ?? this.translations,
        isProcessing: isProcessing ?? this.isProcessing,
        isTranslating: isTranslating ?? this.isTranslating,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        apiCallsRemaining: apiCallsRemaining ?? this.apiCallsRemaining,
        capturedTranslation: clearCaptured
            ? null
            : (capturedTranslation ?? this.capturedTranslation),
      );
}

class ArScannerNotifier extends StateNotifier<ArScannerState> {
  final Ref _ref;
  bool _scannerForObjectAwardedThisSession = false;
  Timer? _clearTimer;

  ArScannerNotifier(this._ref) : super(const ArScannerState()) {
    state = state.copyWith(
      apiCallsRemaining: _ref.read(arTranslationServiceProvider).remainingQuota,
    );
  }

  // ── Mode objet : mise à jour continue des détections ─────────
  void updateDetections(
    List<ArDetectionModel> detections,
    String targetLanguage,
  ) {
    if (detections.isEmpty) {
      if (_clearTimer == null || !_clearTimer!.isActive) {
        _clearTimer = Timer(const Duration(milliseconds: 1500), () {
          if (!mounted) return;
          state = state.copyWith(detections: []);
        });
      }
      return;
    }

    _clearTimer?.cancel();

    final newTranslations =
        Map<String, ArTranslationModel>.from(state.translations);

    for (final det in detections) {
      if (!newTranslations.containsKey(det.normalizedLabel)) {
        final translation = _ref
            .read(arObjectServiceProvider)
            .getTranslation(det.normalizedLabel, targetLanguage);
        if (translation != null) {
          newTranslations[det.normalizedLabel] = translation;
          _awardXPForScan(det.normalizedLabel);
        }
      }
    }

    state = state.copyWith(
      detections: detections,
      translations: newTranslations,
    );
  }

  void disposeTimer() {
    _clearTimer?.cancel();
  }

  // ── Mode texte : traduire via Claude API ──────────────────────
  Future<void> translateCapturedText(
    String detectedText,
    String targetLanguage,
  ) async {
    if (!mounted) return;

    if (state.apiCallsRemaining <= 0) {
      state = state.copyWith(
        errorMessage: M4MockData.uiMessages['quotaExceeded'],
      );
      return;
    }

    state = state.copyWith(isTranslating: true, clearError: true);

    final result = await _ref
        .read(arTranslationServiceProvider)
        .translateText(text: detectedText, targetLanguage: targetLanguage);

    if (!mounted) return;

    if (result != null) {
      state = state.copyWith(
        isTranslating: false,
        capturedTranslation: result,
        apiCallsRemaining:
            _ref.read(arTranslationServiceProvider).remainingQuota,
      );
      _awardXPForTextScan();
    } else {
      state = state.copyWith(
        isTranslating: false,
        errorMessage: 'Traduction impossible — réessayez',
      );
    }
  }

  void clearCapturedTranslation() =>
      state = state.copyWith(clearCaptured: true);

  void clearError() => state = state.copyWith(clearError: true);



  void _awardXPForScan(String objectLabel) {
    if (_scannerForObjectAwardedThisSession) return;

    _ref.read(addXPProvider)(
      sourceType: 'ar_scan',
      sourceName: 'AR Scan — $objectLabel',
      overrideAmount: 45,
    );
    _scannerForObjectAwardedThisSession = true;

    final userId = _ref.read(currentUserIdProvider);
    _ref
        .read(progressionServiceProvider)
        .incrementStat(userId, 'words_mastered');
  }

  void _awardXPForTextScan() {
    _ref.read(addXPProvider)(
      sourceType: 'ar_scan',
      sourceName: 'AR Texte — Traduction',
      overrideAmount: 30,
    );
  }
}
