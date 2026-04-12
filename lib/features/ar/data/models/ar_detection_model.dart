import 'package:flutter/material.dart';

/// Résultat d'une détection MLKit (objet ou texte).
/// Contient les coordonnées de la zone détectée pour positionner l'overlay.
class ArDetectionModel {
  final String rawLabel;
  final String normalizedLabel;
  final double confidence;
  final Rect boundingBox;
  final DateTime detectedAt;

  // Pour le mode texte
  final String? detectedText;
  final bool isTextMode;

  const ArDetectionModel({
    required this.rawLabel,
    required this.normalizedLabel,
    required this.confidence,
    required this.boundingBox,
    required this.detectedAt,
    this.detectedText,
    this.isTextMode = false,
  });

  /// Indique si la détection est suffisamment fiable pour afficher
  bool get isReliable => confidence >= 0.65;

  /// Centre de la bounding box (pour positionner l'overlay)
  Offset get center => Offset(
        boundingBox.left + boundingBox.width / 2,
        boundingBox.top + boundingBox.height / 2,
      );
}
