import 'dart:convert';

class DuelQuestionModel {
  final String sessionId;
  final int questionIndex;
  final String questionType; // 'qcm' | 'vocabulary' | 'emoji_battle' | 'speed_round'
  final String questionText;
  final String correctAnswer;
  final List<String> choices;
  final String language;
  final int difficulty;

  String? player1Answer;
  bool player1Correct;
  int player1TimeMs;
  String? player2Answer;
  bool player2Correct;
  int player2TimeMs;

  DuelQuestionModel({
    required this.sessionId,
    required this.questionIndex,
    required this.questionType,
    required this.questionText,
    required this.correctAnswer,
    required this.choices,
    required this.language,
    this.difficulty = 1,
    this.player1Answer,
    this.player1Correct = false,
    this.player1TimeMs = 0,
    this.player2Answer,
    this.player2Correct = false,
    this.player2TimeMs = 0,
  });

  // Qui a répondu le plus vite sur cette question
  String? get fasterPlayer {
    if (player1TimeMs == 0 || player2TimeMs == 0) return null;
    return player1TimeMs <= player2TimeMs ? 'player1' : 'player2';
  }

  // Points bonus selon la rapidité de réponse
  static int speedBonus(int timeMs) {
    if (timeMs < 3000) return 3;
    if (timeMs < 5000) return 2;
    if (timeMs < 10000) return 1;
    return 0;
  }

  bool isCorrectAnswer(String answer) {
    return answer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();
  }

  Map<String, dynamic> toMap() => {
        'session_id': sessionId,
        'question_index': questionIndex,
        'question_type': questionType,
        'question_text': questionText,
        'correct_answer': correctAnswer,
        'choices': jsonEncode(choices),
        'player1_answer': player1Answer,
        'player1_correct': player1Correct ? 1 : 0,
        'player1_time_ms': player1TimeMs,
        'player2_answer': player2Answer,
        'player2_correct': player2Correct ? 1 : 0,
        'player2_time_ms': player2TimeMs,
        'language': language,
        'difficulty': difficulty,
      };

  factory DuelQuestionModel.fromMap(Map<String, dynamic> map) {
    List<String> choices = [];
    final raw = map['choices'];
    if (raw != null && raw is String && raw.isNotEmpty) {
      choices = List<String>.from(jsonDecode(raw) as List);
    }
    return DuelQuestionModel(
      sessionId: map['session_id'] as String,
      questionIndex: map['question_index'] as int,
      questionType: map['question_type'] as String,
      questionText: map['question_text'] as String,
      correctAnswer: map['correct_answer'] as String,
      choices: choices,
      language: map['language'] as String,
      difficulty: map['difficulty'] as int,
      player1Answer: map['player1_answer'] as String?,
      player1Correct: (map['player1_correct'] as int? ?? 0) == 1,
      player1TimeMs: map['player1_time_ms'] as int? ?? 0,
      player2Answer: map['player2_answer'] as String?,
      player2Correct: (map['player2_correct'] as int? ?? 0) == 1,
      player2TimeMs: map['player2_time_ms'] as int? ?? 0,
    );
  }
}
