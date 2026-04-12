import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../data/models/ar_detection_model.dart';
import '../../data/models/ar_translation_model.dart';
import 'ar_object_overlay.dart';
import 'ar_text_overlay.dart';

/// Ce widget affiche la caméra et les overlays de traduction par-dessus.
class ArCameraView extends StatelessWidget {
  final CameraController controller;
  final List<ArDetectionModel> detections;
  final Map<String, ArTranslationModel> translations;
  final String targetLanguage;
  final ArTranslationModel? capturedTranslation;
  final bool isTranslating;

  const ArCameraView({
    super.key,
    required this.controller,
    required this.detections,
    required this.translations,
    required this.targetLanguage,
    this.capturedTranslation,
    this.isTranslating = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Prévisualisation caméra
            CameraPreview(controller),

            // Overlays des objets détectés (mode objet)
            ...detections.map((detection) {
              final translation = translations[detection.normalizedLabel];
              if (translation == null) return const SizedBox.shrink();

              final left = detection.center.dx * constraints.maxWidth - 80;
              final top = detection.center.dy * constraints.maxHeight - 40;

              return Positioned(
                left: left.clamp(0, constraints.maxWidth - 160),
                top: top.clamp(0, constraints.maxHeight - 80),
                child: ArObjectOverlay(translation: translation),
              );
            }),

            // Overlay de traduction texte — chargement
            if (isTranslating)
              const Positioned(
                bottom: 160,
                left: 20,
                right: 20,
                child: ArObjectOverlayLoading(),
              ),

            // Overlay de traduction texte — résultat
            if (capturedTranslation != null && !isTranslating)
              Positioned(
                bottom: 160,
                left: 20,
                right: 20,
                child: ArTextOverlay(translation: capturedTranslation!),
              ),
          ],
        );
      },
    );
  }
}
