class XpEventModel {
  final int? id;
  final String userId;
  final String sourceType;
  final String? sourceId;
  final String? sourceName;
  final int xpAmount;
  final double multiplier;
  final String? language;
  final DateTime createdAt;

  XpEventModel({
    this.id,
    required this.userId,
    required this.sourceType,
    this.sourceId,
    this.sourceName,
    required this.xpAmount,
    this.multiplier = 1.0,
    this.language,
    required this.createdAt,
  });

  int get effectiveXP => (xpAmount * multiplier).round();

  String get sourceLabel {
    switch (sourceType) {
      case 'lesson_complete':
        return 'Leçon terminée';
      case 'quiz_perfect':
        return 'Quiz parfait !';
      case 'quiz_pass':
        return 'Quiz réussi';
      case 'streak_bonus':
        return 'Bonus streak';
      case 'badge_earned':
        return 'Badge débloqué';
      case 'daily_challenge':
        return 'Défi du jour';
      case 'pronunciation':
        return 'Prononciation';
      case 'ar_scan':
        return 'Scan AR';
      case 'duel_win':
        return 'Victoire duel';
      case 'duel_loss':
        return 'Duel terminé';
      default:
        return sourceType;
    }
  }

  factory XpEventModel.fromMap(Map<String, dynamic> map) {
    return XpEventModel(
      id: map['id'] as int?,
      userId: map['user_id'] as String,
      sourceType: map['source_type'] as String,
      sourceId: map['source_id'] as String?,
      sourceName: map['source_name'] as String?,
      xpAmount: map['xp_amount'] as int,
      multiplier: map['multiplier'] as double,
      language: map['language'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'source_type': sourceType,
      'source_id': sourceId,
      'source_name': sourceName,
      'xp_amount': xpAmount,
      'multiplier': multiplier,
      'language': language,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
