import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../../shared/utils/constants.dart';
import '../models/ai_question.dart';

/// Repository qui encapsule :
/// 1. L'extraction de texte locale via ML Kit (RGPD — aucune donnée envoyée)
/// 2. L'appel API vers Claude 3 Haiku pour la génération de quiz

class AiRepository {
  late final TextRecognizer _textRecognizer;

  AiRepository() {
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  // ════════════════════════════════════════════════════════════════════
  // 1. EXTRACTION DE TEXTE (ML Kit — local, RGPD-compliant)
  // ════════════════════════════════════════════════════════════════════

  /// Extrait le texte d'un fichier image/PDF scanné via ML Kit.
  ///
  /// ML Kit fonctionne entièrement sur l'appareil — aucune donnée n'est
  /// envoyée à un serveur externe, conformément au RGPD.
  ///
  /// [filePath] doit pointer vers un fichier image (jpg, png) ou la
  /// première page d'un PDF rendu en image par le picker.
  Future<String> extractTextFromFile(String filePath) async {
    try {
      final inputImage = InputImage.fromFilePath(filePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.isEmpty) {
        throw Exception(
          'Aucun texte détecté dans le fichier. '
          'Assurez-vous que le document contient du texte lisible.',
        );
      }

      debugPrint(
          '📄 ML Kit: ${recognizedText.text.length} caractères extraits');
      return recognizedText.text;
    } catch (e) {
      debugPrint('❌ ML Kit extraction error: $e');
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════════════════════
  // 2. GÉNÉRATION DE QUIZ (Claude 3 Haiku API)
  // ════════════════════════════════════════════════════════════════════

  /// Génère [questionCount] questions à partir de [sourceText] au niveau
  /// CECR [cecrLevel] via l'API Gemini 1.5 Flash.
  ///
  /// Retourne une liste de [AiQuestion] désérialisées depuis la réponse JSON.
  /// Temps cible : < 8 secondes.
  Future<List<AiQuestion>> generateQuiz({
    required String sourceText,
    required int questionCount,
    required String cecrLevel,
  }) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'Clé API Google manquante. '
        'Ajoutez GOOGLE_API_KEY dans votre fichier .env',
      );
    }

    final truncatedText = sourceText.length > 4000
        ? sourceText.substring(0, 4000)
        : sourceText;

    final prompt = 'Tu es un expert pédagogique. '
        'Génère $questionCount questions de quiz depuis ce texte, '
        'niveau CECR $cecrLevel, en JSON strict : '
        '{"questions":[{"type":"mcq","question":"...","choices":["..."],"answer":"...","explanation":"..."}]}\n\n'
        'RÈGLE CRITIQUE : Vous DEVEZ échapper tous les guillemets doubles (") à l\'intérieur des chaînes de caractères avec un antislash (\\") pour éviter de casser le format JSON.\n'
        'Assurez-vous de renvoyer UNIQUEMENT un objet JSON valide, sans bloc de code markdown.\n\n'
        'Texte source :\n$truncatedText';

    try {
      final model = GenerativeModel(
        model: AppConstants.geminiModel,
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      final response = await model.generateContent([Content.text(prompt)]);

      final text = response.text;
      if (text == null || text.isEmpty) {
        throw Exception('Réponse Gemini vide');
      }

      return _parseGeminiResponse(text);
    } catch (e) {
      debugPrint('❌ Gemini API error: $e');
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('503') || errorString.contains('unavailable') || errorString.contains('high demand')) {
        throw Exception(
          'Les serveurs de l\'IA sont actuellement surchargés (Erreur 503). Veuillez patienter quelques instants et réessayer.',
        );
      }
      throw Exception(
        'Erreur lors de la génération avec Gemini. Vérifiez votre connexion ou réessayez plus tard.',
      );
    }
  }

  /// Parse la réponse Gemini et extrait les questions JSON.
  List<AiQuestion> _parseGeminiResponse(String rawText) {
    try {

      // Extraire le JSON de la réponse (Gemini peut ajouter du texte autour même avec responseMimeType)
      final jsonMatch = RegExp(r'\{[\s\S]*"questions"[\s\S]*\}').firstMatch(rawText);
      if (jsonMatch == null) {
        throw Exception(
          'Format de réponse inattendu. L\'IA n\'a pas retourné de JSON valide.',
        );
      }

      final jsonString = jsonMatch.group(0)!;
      final parsed = json.decode(jsonString) as Map<String, dynamic>;
      final questionsJson = parsed['questions'] as List<dynamic>;

      return questionsJson
          .map((q) => AiQuestion.fromJson(q as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ Parse error: $e');
      throw Exception(
        'Impossible de lire les questions générées. Réessayez.',
      );
    }
  }

  /// Libère les ressources ML Kit.
  void dispose() {
    _textRecognizer.close();
  }
}
