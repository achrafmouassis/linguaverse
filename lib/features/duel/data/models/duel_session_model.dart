import '../mock/m6_mock_data.dart';

enum DuelStatus { pending, inProgress, completed, abandoned }

enum DuelResult { win, loss, draw }

class DuelSessionModel {
  final String sessionId;
  final String player1Id;
  final String player2Id;
  final String player1Name;
  final String player2Name;
  final String gameMode;
  final String language;
  final int questionCount;
  final int timePerQuestion;
  final int player1Score;
  final int player2Score;
  final String? winnerId;
  final bool isPerfect;
  final int xpEarned;
  final int durationSeconds;
  final DuelStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const DuelSessionModel({
    required this.sessionId,
    required this.player1Id,
    required this.player2Id,
    required this.player1Name,
    required this.player2Name,
    required this.gameMode,
    required this.language,
    required this.questionCount,
    required this.timePerQuestion,
    this.player1Score = 0,
    this.player2Score = 0,
    this.winnerId,
    this.isPerfect = false,
    this.xpEarned = 0,
    this.durationSeconds = 0,
    this.status = DuelStatus.pending,
    required this.createdAt,
    this.completedAt,
  });

  // Current user is always player1 (mock M1 Auth)
  bool get isCurrentUserWinner => winnerId == player1Id;
  bool get isDraw => winnerId == null && status == DuelStatus.completed;

  DuelResult get result {
    if (status != DuelStatus.completed) return DuelResult.draw;
    if (isDraw) return DuelResult.draw;
    return isCurrentUserWinner ? DuelResult.win : DuelResult.loss;
  }

  String get resultLabel {
    switch (result) {
      case DuelResult.win:
        return 'Victoire';
      case DuelResult.loss:
        return 'Défaite';
      case DuelResult.draw:
        return 'Égalité';
    }
  }

  // ── Calcul XP basé sur le mode, résultat, perfectness et streak ──
  // SOURCE RÉELLE : DuelConfigService.calculateXP() + Firebase Remote Config
  // POUR REMPLACER : config dynamique depuis Firestore
  static int calculateXP({
    required String mode,
    required bool won,
    required bool isPerfect,
    required int winStreak,
  }) {
    final modeData = M6MockData.gameModes.firstWhere(
      (m) => m['id'] == mode,
      orElse: () => {'xpWin': 100, 'xpLoss': 20},
    );
    final baseXp = (won ? modeData['xpWin'] : modeData['xpLoss']) as int;

    double multiplier = 1.0;
    if (isPerfect) multiplier += 0.25; // +25% si 100% correct
    if (winStreak >= 3) multiplier += 0.15; // +15% si série ≥ 3
    if (winStreak >= 5) multiplier += 0.10; // +10% supplémentaire si série ≥ 5

    return (baseXp * multiplier).round();
  }

  Map<String, dynamic> toMap() => {
        'session_id': sessionId,
        'player1_id': player1Id,
        'player2_id': player2Id,
        'player1_name': player1Name,
        'player2_name': player2Name,
        'game_mode': gameMode,
        'language': language,
        'question_count': questionCount,
        'time_per_question': timePerQuestion,
        'player1_score': player1Score,
        'player2_score': player2Score,
        'winner_id': winnerId,
        'is_perfect': isPerfect ? 1 : 0,
        'xp_earned': xpEarned,
        'duration_seconds': durationSeconds,
        'status': status.name,
        'created_at': createdAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
      };

  factory DuelSessionModel.fromMap(Map<String, dynamic> map) {
    return DuelSessionModel(
      sessionId: map['session_id'] as String,
      player1Id: map['player1_id'] as String,
      player2Id: map['player2_id'] as String,
      player1Name: map['player1_name'] as String,
      player2Name: map['player2_name'] as String,
      gameMode: map['game_mode'] as String,
      language: map['language'] as String,
      questionCount: map['question_count'] as int,
      timePerQuestion: map['time_per_question'] as int,
      player1Score: map['player1_score'] as int,
      player2Score: map['player2_score'] as int,
      winnerId: map['winner_id'] as String?,
      isPerfect: (map['is_perfect'] as int) == 1,
      xpEarned: map['xp_earned'] as int,
      durationSeconds: map['duration_seconds'] as int,
      status: DuelStatus.values
          .firstWhere((s) => s.name == map['status'], orElse: () => DuelStatus.pending),
      createdAt: DateTime.parse(map['created_at'] as String),
      completedAt:
          map['completed_at'] != null ? DateTime.parse(map['completed_at'] as String) : null,
    );
  }

  DuelSessionModel copyWith({
    String? sessionId,
    String? player1Id,
    String? player2Id,
    String? player1Name,
    String? player2Name,
    String? gameMode,
    String? language,
    int? questionCount,
    int? timePerQuestion,
    int? player1Score,
    int? player2Score,
    String? winnerId,
    bool? isPerfect,
    int? xpEarned,
    int? durationSeconds,
    DuelStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return DuelSessionModel(
      sessionId: sessionId ?? this.sessionId,
      player1Id: player1Id ?? this.player1Id,
      player2Id: player2Id ?? this.player2Id,
      player1Name: player1Name ?? this.player1Name,
      player2Name: player2Name ?? this.player2Name,
      gameMode: gameMode ?? this.gameMode,
      language: language ?? this.language,
      questionCount: questionCount ?? this.questionCount,
      timePerQuestion: timePerQuestion ?? this.timePerQuestion,
      player1Score: player1Score ?? this.player1Score,
      player2Score: player2Score ?? this.player2Score,
      winnerId: winnerId ?? this.winnerId,
      isPerfect: isPerfect ?? this.isPerfect,
      xpEarned: xpEarned ?? this.xpEarned,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
