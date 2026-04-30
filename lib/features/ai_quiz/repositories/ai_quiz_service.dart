import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../shared/utils/constants.dart';
import '../data/mock/m8_mock_data.dart';

/// Service de génération de quiz IA via Claude API.
/// Gère le quota journalier et le fallback automatique.
class AIQuizService {
  final Dio _dio = Dio();
  int _todayRequests = 0;
  String _todayDate = '';

  int get remainingQuota {
    _checkDailyReset();
    return (AppConstants.aiQuotaPerDay - _todayRequests).clamp(0, 99);
  }

  /// Génère des questions via Claude API.
  /// Si le quota est atteint ou l'API échoue → retourne les questions fallback.
  Future<List<Map<String, dynamic>>> generateQuestions({
    required String language,
    required int userLevel,
    required List<String> recentTopics,
    int questionCount = 5,
  }) async {
    _checkDailyReset();

    if (_todayRequests >= AppConstants.aiQuotaPerDay) {
      return _getFallbackQuestions(language, questionCount);
    }

    final prompt = M8MockData.buildClaudePrompt(
      language: language,
      userLevel: userLevel,
      recentTopics: recentTopics,
      questionCount: questionCount,
    );

    try {
      final response = await _dio.post(
        AppConstants.claudeApiUrl,
        options: Options(
          headers: {
            'x-api-key': dotenv.env['CLAUDE_API_KEY'] ?? '',
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
        ),
        data: {
          'model': AppConstants.claudeModel,
          'max_tokens': AppConstants.claudeMaxTokens,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        },
      );

      _todayRequests++;

      final content =
          (response.data['content'] as List).first['text'] as String;
      final cleaned = content
          .trim()
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final parsed = jsonDecode(cleaned) as Map<String, dynamic>;
      final questions = parsed['questions'] as List;
      return questions.cast<Map<String, dynamic>>();
    } on DioException {
      return _getFallbackQuestions(language, questionCount);
    } on FormatException {
      return _getFallbackQuestions(language, questionCount);
    }
  }

  List<Map<String, dynamic>> _getFallbackQuestions(
      String language, int count) {
    final pool = M8MockData.fallbackQuestions[language] ??
        M8MockData.fallbackQuestions['Arabe']!;
    final shuffled = [...pool]..shuffle();
    return shuffled.take(count).toList();
  }

  void _checkDailyReset() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (today != _todayDate) {
      _todayRequests = 0;
      _todayDate = today;
    }
  }
}
