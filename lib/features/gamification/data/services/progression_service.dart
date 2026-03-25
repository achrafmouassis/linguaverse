import '../../../../core/services/database_helper.dart';
import '../models/user_progression_model.dart';
import '../models/xp_event_model.dart';
import '../models/badge_model.dart';
import 'leaderboard_service.dart';
import 'badge_service.dart';

class XpGainResult {
  final int xpAdded;
  final double multiplierUsed;
  final int newTotalXP;
  final int newLevel;
  final double newXpProgress;
  final LevelUpResult? levelUp;
  final List<BadgeModel> newBadges;

  XpGainResult({
    required this.xpAdded,
    required this.multiplierUsed,
    required this.newTotalXP,
    required this.newLevel,
    required this.newXpProgress,
    this.levelUp,
    required this.newBadges,
  });
}

class LevelUpResult {
  final int oldLevel;
  final int newLevel;
  final String newLevelTitle;
  final int xpRewardForLevelUp;

  LevelUpResult({
    required this.oldLevel,
    required this.newLevel,
    required this.newLevelTitle,
    required this.xpRewardForLevelUp,
  });
}

class ProgressionService {
  final DatabaseHelper _db;
  late final BadgeService _badgeService;
  late final LeaderboardService _leaderboardService;

  ProgressionService(this._db) {
    _badgeService = BadgeService(_db);
    _leaderboardService = LeaderboardService(_db);
  }

  Future<void> initUserProgression(String userId) async {
    await _db.initUserProgression(userId);
  }

  Future<void> resetUserForTest(String userId) async {
    final db = await _db.database;
    await db.delete('user_progression', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('user_badges', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('xp_events', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('milestones', where: 'user_id = ?', whereArgs: [userId]);
    await initUserProgression(userId);
  }

  Future<void> setStreakForTest(String userId, int streak) async {
    final db = await _db.database;
    await db.update('user_progression', {'streak_days': streak},
        where: 'user_id = ?', whereArgs: [userId]);
  }

  static const Map<String, int> _baseXP = {
    'lesson_complete': 50,
    'quiz_perfect': 100,
    'quiz_pass': 40,
    'daily_challenge': 80,
    'pronunciation': 30,
    'ar_scan': 45,
    'duel_win': 120,
    'duel_loss': 25,
    'badge_earned': 20,
    'streak_bonus': 50,
  };

  double _streakMultiplier(int streakDays) => (1.0 + (streakDays ~/ 7) * 0.05).clamp(1.0, 1.20);

  Future<XpGainResult> addXP({
    required String userId,
    required String userName,
    required String userInitials,
    required String sourceType,
    String? sourceId,
    String? sourceName,
    String? language,
    int? overrideAmount,
  }) async {
    final db = await _db.database;

    // 1. Get current progression
    var progression = await getProgression(userId);
    if (progression == null) {
      await _db.initUserProgression(userId);
      progression = await getProgression(userId);
    }

    // 2. Calculate XP
    final int baseAmount = overrideAmount ?? _baseXP[sourceType] ?? 10;
    final double multiplier = (sourceType == 'streak_bonus' || sourceType == 'badge_earned')
        ? 1.0
        : _streakMultiplier(progression!.streakDays);
    final int effectiveXP = (baseAmount * multiplier).round();

    // 3. Insert event
    final eventMap = XpEventModel(
      userId: userId,
      sourceType: sourceType,
      sourceId: sourceId,
      sourceName: sourceName,
      xpAmount: baseAmount,
      multiplier: multiplier,
      language: language,
      createdAt: DateTime.now(),
    ).toMap();
    // remove id before insert since it's autoinc
    eventMap.remove('id');
    await db.insert('xp_events', eventMap);

    // 4. Update progression
    final newCurrentXP = progression!.currentXP + effectiveXP;
    final newTotalXP = progression.totalXpEver + effectiveXP;

    await db.update(
      'user_progression',
      {
        'current_xp': newCurrentXP,
        'total_xp_ever': newTotalXP,
      },
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    progression = progression.copyWith(currentXP: newCurrentXP, totalXpEver: newTotalXP);

    // 5. Check level up
    final levelUp = await _checkLevelUp(userId, progression);
    if (levelUp != null) {
      progression = progression.copyWith(currentLevel: levelUp.newLevel);
    }

    // Check badges
    final newBadges = await _badgeService.checkAndAwardAllBadges(userId, progression);

    // 6. Update leaderboard
    await _leaderboardService.updateUserScore(
      userId: userId,
      userName: userName,
      userInitials: userInitials,
      xpEarned: effectiveXP,
      language: language ?? 'all',
    );

    return XpGainResult(
      xpAdded: effectiveXP,
      multiplierUsed: multiplier,
      newTotalXP: newTotalXP,
      newLevel: progression.currentLevel,
      newXpProgress: progression.xpProgress,
      levelUp: levelUp,
      newBadges: newBadges,
    );
  }

  Future<LevelUpResult?> _checkLevelUp(String userId, UserProgressionModel current) async {
    final db = await _db.database;
    final calculatedLevel = UserProgressionModel.levelFromXP(current.totalXpEver);

    if (calculatedLevel > current.currentLevel) {
      await db.update(
        'user_progression',
        {'current_level': calculatedLevel},
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      final dummyModelForTitle = current.copyWith(currentLevel: calculatedLevel);
      return LevelUpResult(
        oldLevel: current.currentLevel,
        newLevel: calculatedLevel,
        newLevelTitle: dummyModelForTitle.levelTitle,
        xpRewardForLevelUp: 50 * calculatedLevel,
      );
    }
    return null;
  }

  Future<UserProgressionModel?> getProgression(String userId) async {
    final db = await _db.database;
    final res = await db.query('user_progression', where: 'user_id = ?', whereArgs: [userId]);
    if (res.isNotEmpty) {
      return UserProgressionModel.fromMap(res.first);
    }
    return null;
  }

  Future<List<XpEventModel>> getRecentXPEvents(String userId, {int limit = 20}) async {
    final db = await _db.database;
    final res = await db.query(
      'xp_events',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return res.map((e) => XpEventModel.fromMap(e)).toList();
  }

  Future<Map<String, int>> getXPByDayThisWeek(String userId) async {
    final db = await _db.database;
    final now = DateTime.now();
    final startOfWeek =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final startDateStr = startOfWeek.toIso8601String();

    final res = await db.rawQuery('''
      SELECT date(created_at) as event_date, SUM(CAST(ROUND(xp_amount * multiplier) AS INTEGER)) as day_xp
      FROM xp_events
      WHERE user_id = ? AND created_at >= ?
      GROUP BY event_date
    ''', [userId, startDateStr]);

    Map<String, int> result = {};
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      // simple format: YYYY-MM-DD
      final dateStr = date.toIso8601String().split('T').first;
      result[dateStr] = 0;
    }

    for (final row in res) {
      final dateStr = row['event_date'] as String;
      final dayXp = row['day_xp'] as int;
      if (result.containsKey(dateStr)) {
        result[dateStr] = dayXp;
      }
    }

    return result;
  }

  Future<void> updateStudyMinutes(String userId, int minutes) async {
    final db = await _db.database;
    await db.execute('''
      UPDATE user_progression 
      SET total_study_minutes = total_study_minutes + ? 
      WHERE user_id = ?
    ''', [minutes, userId]);
  }

  Future<void> incrementStat(String userId, String statName, {int increment = 1}) async {
    const allowedStats = [
      'lessons_completed', 'quizzes_completed', 'words_mastered', 'perfect_scores',
      // ── Statistiques duel M6 ─────────────────────────────────────
      'duels_played', 'duel_wins', 'duel_losses',
      'duel_win_streak', 'duel_best_streak', 'duel_perfects',
    ];
    if (!allowedStats.contains(statName)) return;
    final db = await _db.database;
    await db.execute('''
      UPDATE user_progression 
      SET $statName = $statName + ? 
      WHERE user_id = ?
    ''', [increment, userId]);
  }
}
