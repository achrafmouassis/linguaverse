import 'package:flutter/material.dart';

class DuelOpponentModel {
  final String opponentId;
  final String name;
  final String initials;
  final int level;
  final int totalXP;
  final int winRate;
  final int avgResponseMs;
  final String difficulty;
  final String color1Hex;
  final String color2Hex;
  final bool isBot;

  const DuelOpponentModel({
    required this.opponentId,
    required this.name,
    required this.initials,
    required this.level,
    required this.totalXP,
    required this.winRate,
    required this.avgResponseMs,
    required this.difficulty,
    required this.color1Hex,
    required this.color2Hex,
    required this.isBot,
  });

  Color get avatarColor1 => Color(int.parse('0xFF${color1Hex.replaceAll('#', '')}'));
  Color get avatarColor2 => Color(int.parse('0xFF${color2Hex.replaceAll('#', '')}'));

  String get difficultyLabel => switch (difficulty) {
        'easy' => 'Facile',
        'medium' => 'Moyen',
        'hard' => 'Difficile',
        'expert' => 'Expert',
        _ => difficulty,
      };

  // Simule si le bot répond correctement
  // TODO(API) : Remplacer par Firebase Realtime pour le vrai multijoueur
  bool simulateAnswer() {
    final rand = DateTime.now().millisecondsSinceEpoch % 100;
    return rand < winRate;
  }

  int simulateResponseTimeMs() {
    final variation = DateTime.now().millisecondsSinceEpoch % 1000;
    return (avgResponseMs - 500 + variation).clamp(500, 8000);
  }

  factory DuelOpponentModel.fromMap(Map<String, dynamic> map) {
    return DuelOpponentModel(
      opponentId: map['opponent_id'] as String,
      name: map['name'] as String,
      initials: map['initials'] as String,
      level: map['level'] as int,
      totalXP: map['total_xp'] as int,
      winRate: map['win_rate'] as int,
      avgResponseMs: map['avg_response_ms'] as int,
      difficulty: map['difficulty'] as String,
      color1Hex: map['color1_hex'] as String,
      color2Hex: map['color2_hex'] as String,
      isBot: (map['is_bot'] as int) == 1,
    );
  }
}
