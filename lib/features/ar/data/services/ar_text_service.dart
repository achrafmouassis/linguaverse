import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/material.dart';
import '../models/ar_detection_model.dart';

class ArTextService {
  late final TextRecognizer _recognizer;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    _isInitialized = true;
  }

  /// Analyse une photo capturée et retourne le texte détecté.
  Future<ArDetectionModel?> processCapture(InputImage inputImage) async {
    try {
      final recognizedText = await _recognizer.processImage(inputImage);

      final text = recognizedText.text.trim();
      if (text.isEmpty) return null;

      // Extract text more robustly
      String mainText = recognizedText.blocks
          .where((b) => b.text.trim().isNotEmpty)
          .map((b) => b.text.trim())
          .join(' ');

      if (mainText.isEmpty) {
        mainText = text;
      }

      if (mainText.isEmpty) return null;

      return ArDetectionModel(
        rawLabel: 'text',
        normalizedLabel: 'text',
        confidence: 1.0,
        boundingBox: Rect.zero,
        detectedAt: DateTime.now(),
        detectedText: mainText,
        isTextMode: true,
      );
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    if (_isInitialized) _recognizer.close();
  }
}
