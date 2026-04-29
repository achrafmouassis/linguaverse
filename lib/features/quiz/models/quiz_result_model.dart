// lib/features/quiz/models/quiz_result_model.dart
import 'question_model.dart';

// ─────────────────────────────────────────────
// Résultat par question
// ─────────────────────────────────────────────
class AnsweredQuestion {
  final Question question;
  final String? userAnswer; // null = timeout
  final bool isCorrect;
  final int timeSpentMs;

  const AnsweredQuestion({
    required this.question,
    required this.userAnswer,
    required this.isCorrect,
    required this.timeSpentMs,
  });
}

// ─────────────────────────────────────────────
// Résultat global du quiz
// ─────────────────────────────────────────────
class QuizResult {
  final String id;
  final String lessonId;
  final String categoryId;
  final String languageId;
  final DateTime completedAt;

  final List<AnsweredQuestion> answers;

  // Calculés
  final int totalQuestions;
  final int correctCount;
  final int xpEarned;
  final int durationSeconds;

  // Mots à réviser via SRS
  final List<String> wordsToReview; // IDs des mots ratés

  const QuizResult({
    required this.id,
    required this.lessonId,
    required this.categoryId,
    required this.languageId,
    required this.completedAt,
    required this.answers,
    required this.totalQuestions,
    required this.correctCount,
    required this.xpEarned,
    required this.durationSeconds,
    required this.wordsToReview,
  });

  /// Score en pourcentage (0–100)
  int get scorePercent => totalQuestions == 0 ? 0 : (correctCount / totalQuestions * 100).ceil();

  /// Lettre de grade
  String get grade {
    final s = scorePercent;
    if (s >= 90) return 'S';
    if (s >= 75) return 'A';
    if (s >= 60) return 'B';
    if (s >= 40) return 'C';
    return 'D';
  }

  /// Sérialisation SQLite
  Map<String, dynamic> toMap() => {
        'id': id,
        'lessonId': lessonId,
        'categoryId': categoryId,
        'languageId': languageId,
        'completedAt': completedAt.millisecondsSinceEpoch,
        'totalQuestions': totalQuestions,
        'correctCount': correctCount,
        'xpEarned': xpEarned,
        'durationSeconds': durationSeconds,
        'scorePercent': scorePercent,
        'wordsToReview': wordsToReview.join(','),
      };

  factory QuizResult.fromMap(Map<String, dynamic> map) => QuizResult(
        id: map['id'] as String,
        lessonId: map['lessonId'] as String,
        categoryId: map['categoryId'] as String,
        languageId: map['languageId'] as String,
        completedAt: DateTime.fromMillisecondsSinceEpoch(map['completedAt'] as int),
        answers: const [],
        totalQuestions: map['totalQuestions'] as int,
        correctCount: map['correctCount'] as int,
        xpEarned: map['xpEarned'] as int,
        durationSeconds: map['durationSeconds'] as int,
        wordsToReview:
            (map['wordsToReview'] as String).split(',').where((s) => s.isNotEmpty).toList(),
      );
}
