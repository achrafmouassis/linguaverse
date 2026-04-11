// lib/features/gamification/repositories/gamification_service.dart

import '../models/gamification_model.dart';
import '../../quiz/models/quiz_result_model.dart';

/// Calcule XP + nouveaux badges selon le résultat du quiz.
/// XP formula : base 50 + (scorePercent * 0.5) + bonus speed
class GamificationService {
  // ── XP Calculation ──────────────────────────────────────
  static int calculateXp(QuizResult result) {
    const int base = 50;
    final int scoreBonus = (result.scorePercent * 0.5).round();
    final int speedBonus = _speedBonus(result);
    final int perfectBonus = result.scorePercent == 100 ? 25 : 0;
    return base + scoreBonus + speedBonus + perfectBonus;
  }

  static int _speedBonus(QuizResult result) {
    if (result.answers.isEmpty) return 0;
    final avgMs = result.answers.fold<int>(
          0, (sum, a) => sum + a.timeSpentMs) /
        result.answers.length;
    if (avgMs < 5000) return 20;  // < 5s par question
    if (avgMs < 10000) return 10; // < 10s par question
    return 0;
  }

  // ── Badge evaluation ────────────────────────────────────
  static List<QuizBadge> evaluateBadges({
    required QuizResult result,
    required GamificationProfile profile,
  }) {
    final newBadges = <QuizBadge>[];
    final existingTypes = profile.badges.map((b) => b.type).toSet();

    void tryUnlock(BadgeType type) {
      if (!existingTypes.contains(type)) {
        newBadges.add(QuizBadge.fromType(type));
      }
    }

    // Premier quiz
    if (profile.quizCount == 0) tryUnlock(BadgeType.firstQuiz);

    // Score parfait
    if (result.scorePercent == 100) tryUnlock(BadgeType.perfectScore);

    // Speed runner : moyenne < 5s
    if (result.answers.isNotEmpty) {
      final avgMs = result.answers.fold<int>(0, (s, a) => s + a.timeSpentMs) /
          result.answers.length;
      if (avgMs < 5000) tryUnlock(BadgeType.speedRunner);
    }

    // 3 quiz complétés
    if (profile.quizCount + 1 >= 3) tryUnlock(BadgeType.persistent);

    // 10 quiz complétés
    if (profile.quizCount + 1 >= 10) tryUnlock(BadgeType.linguist);

    // 3 jours de suite (simplifié : last quiz hier ou aujourd'hui)
    if (profile.lastQuizDate != null) {
      final diff = DateTime.now().difference(profile.lastQuizDate!).inDays;
      if (diff <= 1) tryUnlock(BadgeType.streak3);
    }

    return newBadges;
  }

  // ── Main entry point ────────────────────────────────────
  static GamificationResult processResult({
    required QuizResult result,
    required GamificationProfile profile,
  }) {
    final xp = calculateXp(result);
    final newBadges = evaluateBadges(result: result, profile: profile);

    final oldLevel = profile.level;
    final updated = profile.copyWith(
      totalXp: profile.totalXp + xp,
      quizCount: profile.quizCount + 1,
      badges: [...profile.badges, ...newBadges],
      lastQuizDate: DateTime.now(),
    );
    final newLevel = updated.level > oldLevel ? updated.level : 0;

    return GamificationResult(
      xpEarned: xp,
      newBadges: newBadges,
      newLevel: newLevel,
      updatedProfile: updated,
    );
  }
}
