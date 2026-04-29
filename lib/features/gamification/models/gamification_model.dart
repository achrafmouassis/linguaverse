// lib/features/gamification/models/gamification_model.dart

// ─────────────────────────────────────────────
// QuizBadge débloqué (renommé pour éviter le conflit avec material.Badge)
// ─────────────────────────────────────────────
enum BadgeType {
  perfectScore,     // 100 %
  firstQuiz,        // Premier quiz complété
  speedRunner,      // Moyenne < 5s par question
  persistent,       // 3 quiz complétés
  linguist,         // 10 quiz complétés
  streak3,          // 3 jours de suite
}

class QuizBadge {
  final BadgeType type;
  final String title;
  final String description;
  final String emoji;
  final DateTime unlockedAt;

  const QuizBadge({
    required this.type,
    required this.title,
    required this.description,
    required this.emoji,
    required this.unlockedAt,
  });

  static QuizBadge fromType(BadgeType type) {
    final now = DateTime.now();
    switch (type) {
      case BadgeType.perfectScore:
        return QuizBadge(type: type, title: 'Parfait !', description: 'Score de 100%', emoji: '🏆', unlockedAt: now);
      case BadgeType.firstQuiz:
        return QuizBadge(type: type, title: 'Premier pas', description: 'Premier quiz complété', emoji: '🎯', unlockedAt: now);
      case BadgeType.speedRunner:
        return QuizBadge(type: type, title: 'Flash', description: 'Réponses ultra rapides', emoji: '⚡', unlockedAt: now);
      case BadgeType.persistent:
        return QuizBadge(type: type, title: 'Persévérant', description: '3 quiz réalisés', emoji: '💪', unlockedAt: now);
      case BadgeType.linguist:
        return QuizBadge(type: type, title: 'Linguiste', description: '10 quiz réalisés', emoji: '🌍', unlockedAt: now);
      case BadgeType.streak3:
        return QuizBadge(type: type, title: 'En feu !', description: '3 jours consécutifs', emoji: '🔥', unlockedAt: now);
    }
  }

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'title': title,
        'description': description,
        'emoji': emoji,
        'unlockedAt': unlockedAt.millisecondsSinceEpoch,
      };

  factory QuizBadge.fromMap(Map<String, dynamic> m) {
    final t = BadgeType.values.firstWhere((e) => e.name == m['type']);
    return QuizBadge(
      type: t,
      title: m['title'] as String,
      description: m['description'] as String,
      emoji: m['emoji'] as String,
      unlockedAt: DateTime.fromMillisecondsSinceEpoch(m['unlockedAt'] as int),
    );
  }
}

// ─────────────────────────────────────────────
// Profil de gamification de l'utilisateur
// ─────────────────────────────────────────────
class GamificationProfile {
  final int totalXp;
  final int quizCount;
  final List<QuizBadge> badges;
  final DateTime? lastQuizDate;

  const GamificationProfile({
    this.totalXp = 0,
    this.quizCount = 0,
    this.badges = const [],
    this.lastQuizDate,
  });

  int get level => (totalXp / 100).floor() + 1;
  int get xpToNextLevel => 100 - (totalXp % 100);

  GamificationProfile copyWith({
    int? totalXp,
    int? quizCount,
    List<QuizBadge>? badges,
    DateTime? lastQuizDate,
  }) =>
      GamificationProfile(
        totalXp: totalXp ?? this.totalXp,
        quizCount: quizCount ?? this.quizCount,
        badges: badges ?? this.badges,
        lastQuizDate: lastQuizDate ?? this.lastQuizDate,
      );
}

// ─────────────────────────────────────────────
// Résultat du traitement gamification
// ─────────────────────────────────────────────
class GamificationResult {
  final int xpEarned;
  final List<QuizBadge> newBadges;
  final int newLevel; // 0 si pas de level-up
  final GamificationProfile updatedProfile;

  const GamificationResult({
    required this.xpEarned,
    required this.newBadges,
    required this.newLevel,
    required this.updatedProfile,
  });

  bool get leveledUp => newLevel > 0;
}
