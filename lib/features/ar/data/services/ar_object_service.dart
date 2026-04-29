import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:camera/camera.dart';
import 'package:linguaverse/shared/utils/constants.dart';
import '../mock/m4_mock_data.dart';
import '../models/ar_detection_model.dart';
import '../models/ar_translation_model.dart';

class ArObjectService {
  late final ObjectDetector _detector;
  late final ImageLabeler _labeler;
  bool _isInitialized = false;
  DateTime _lastProcessedTime = DateTime(2000);

  Future<void> initialize() async {
    if (_isInitialized) return;
    final options = ObjectDetectorOptions(
      mode: DetectionMode.single,
      classifyObjects: true,
      multipleObjects: true,
    );
    _detector = ObjectDetector(options: options);
    _labeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));
    _isInitialized = true;
  }

  /// Analyse une frame caméra et retourne les détections fiables.
  Future<List<ArDetectionModel>?> processFrame(
    CameraImage image,
    InputImageRotation rotation,
  ) async {
    // Throttle : ne traiter qu'une frame toutes les arFrameMs millisecondes
    final now = DateTime.now();
    if (now.difference(_lastProcessedTime).inMilliseconds < AppConstants.arFrameMs) {
      return null;
    }
    _lastProcessedTime = now;

    // Convertir la CameraImage en InputImage pour MLKit
    final inputImage = _convertCameraImageToInputImage(image, rotation);
    if (inputImage == null) return [];

    try {
      final objects = await _detector.processImage(inputImage);
      if (objects.isEmpty) return [];

      final labels = await _labeler.processImage(inputImage);
      String imageLabel = 'unknown';
      double imageConfidence = 1.0;

      if (labels.isNotEmpty) {
        final bestLabel = labels.reduce((a, b) => a.confidence > b.confidence ? a : b);
        imageLabel = bestLabel.label.toLowerCase();
        imageConfidence = bestLabel.confidence;
        debugPrint('🎯 IMAGE LABELER: $imageLabel ($imageConfidence)');
      }

      final detections = <ArDetectionModel>[];

      final bool isRotated = rotation == InputImageRotation.rotation90deg ||
          rotation == InputImageRotation.rotation270deg;
      final double logicalWidth = isRotated ? image.height.toDouble() : image.width.toDouble();
      final double logicalHeight = isRotated ? image.width.toDouble() : image.height.toDouble();

      for (final obj in objects) {
        String rawLabel = imageLabel;
        double confidence = imageConfidence;

        final normalizedLabel = M4MockData.mlLabelNormalization[rawLabel] ?? rawLabel;

        if (!M4MockData.objectDictionary.containsKey(normalizedLabel)) {
          continue; // Ignore complètement au lieu d'afficher "Objet/unknown"
        }

        final box = obj.boundingBox;
        final normalizedBox = Rect.fromLTWH(
          box.left / logicalWidth,
          box.top / logicalHeight,
          box.width / logicalWidth,
          box.height / logicalHeight,
        );

        // -- FILTRE DE PROXIMITÉ / TAILLE --
        // Ignore les objets dont la taille maximale représentée à l'écran
        // est inférieure à 20% (ils sont trop loin ou trop petits)
        if (normalizedBox.width < 0.20 && normalizedBox.height < 0.20) {
          continue;
        }

        detections.add(ArDetectionModel(
          rawLabel: rawLabel,
          normalizedLabel: normalizedLabel,
          confidence: confidence,
          boundingBox: normalizedBox,
          detectedAt: DateTime.now(),
        ));
      }

      return detections.take(AppConstants.arMaxObjects).toList();
    } catch (e) {
      return [];
    }
  }

  /// Récupère la traduction depuis le dictionnaire local.
  ArTranslationModel? getTranslation(
    String normalizedLabel,
    String targetLanguage,
  ) {
    final langData = M4MockData.objectDictionary[normalizedLabel];
    if (langData == null) return null;

    final englishData = langData['Anglais'] ?? {'word': normalizedLabel, 'roman': '', 'sound': ''};
    final targetData = langData[targetLanguage] ?? langData['Anglais']!;

    return ArTranslationModel.fromDictionary(
      englishWord: englishData['word'] ?? normalizedLabel,
      translationMap: targetData,
      targetLanguage: targetLanguage,
    );
  }

  InputImage? _convertCameraImageToInputImage(
    CameraImage image,
    InputImageRotation rotation,
  ) {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();
      final format = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    if (_isInitialized) {
      _detector.close();
      _labeler.close();
    }
  }
}
