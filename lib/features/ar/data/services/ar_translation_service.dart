import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:linguaverse/shared/utils/constants.dart';
import '../models/ar_translation_model.dart';

class ArTranslationService {
  final Dio _dio = Dio();

  // Cache local en mémoire
  final Map<String, ArTranslationModel> _cache = {};

  // Compteur de requêtes du jour
  int _requestsToday = 0;
  String _lastRequestDate = '';

  /// Traduit un texte via Claude API.
  Future<ArTranslationModel?> translateText({
    required String text,
    required String targetLanguage,
  }) async {
    _checkDailyReset();

    if (_requestsToday >= AppConstants.aiQuotaPerDay) {
      return null;
    }

    final cacheKey = '${text}_$targetLanguage';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!.copyWith(fromCache: true);
    }

    final prompt = '''
Tu es un assistant de traduction pour une application d'apprentissage des langues.
Analyse ce texte et réponds UNIQUEMENT avec ce format JSON, rien d'autre :
{"english": "[texte en anglais]", "translation": "[traduction en $targetLanguage]"}

Texte à analyser : "$text"

Règles :
- "english" : si le texte est déjà en anglais, le conserver tel quel. 
  Si c'est en arabe ou autre langue, le traduire en anglais.
- "translation" : traduire le texte original en $targetLanguage.
- Garder les traductions concises (max 80 caractères).
- Ne pas inclure d'explication, seulement le JSON.
''';

    try {
      final response = await _dio.post(
        AppConstants.claudeApiUrl,
        options: Options(
          headers: {
            'x-api-key': dotenv.env['CLAUDE_API_KEY'] ?? '',
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ),
        data: {
          'model': AppConstants.claudeModel,
          'max_tokens': AppConstants.claudeMaxTokens,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        },
      );

      _requestsToday++;
      _saveRequestCount();

      final content = response.data['content'][0]['text'] as String;
      final cleanJson = content.trim().replaceAll('```json', '').replaceAll('```', '').trim();
      final jsonData = jsonDecode(cleanJson) as Map<String, dynamic>;

      final result = ArTranslationModel.fromAPI(
        englishText: jsonData['english'] as String? ?? text,
        translatedText: jsonData['translation'] as String? ?? text,
        targetLanguage: targetLanguage,
        fromCache: false,
      );

      _cache[cacheKey] = result;
      return result;
    } on DioException {
      // Mock de secours en cas d'erreur API (ex: clé manquante)
      return ArTranslationModel.fromAPI(
        englishText: text,
        translatedText: '[Mock: $targetLanguage] $text',
        targetLanguage: targetLanguage,
        fromCache: false,
      );
    } catch (_) {
      return ArTranslationModel.fromAPI(
        englishText: text,
        translatedText: '[Mock: $targetLanguage] $text',
        targetLanguage: targetLanguage,
        fromCache: false,
      );
    }
  }

  void _checkDailyReset() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (today != _lastRequestDate) {
      _requestsToday = 0;
      _lastRequestDate = today;
    }
  }

  void _saveRequestCount() {
    // TODO(DB) : Persister via shared_preferences
  }

  int get remainingQuota =>
      (AppConstants.aiQuotaPerDay - _requestsToday).clamp(0, AppConstants.aiQuotaPerDay);

  void clearCache() => _cache.clear();
}
