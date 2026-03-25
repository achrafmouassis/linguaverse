import '../../../../core/services/database_helper.dart';
import '../models/badge_model.dart';
import '../models/user_progression_model.dart';

class BadgeService {
  final DatabaseHelper _db;

  BadgeService(this._db);

  Future<List<BadgeModel>> checkAndAwardAllBadges(
      String userId, UserProgressionModel progression) async {
    final List<BadgeModel> awarded = [];

    await _checkBadge(userId, 'streak_7', progression.streakDays >= 7, awarded, xpReward: 50);
    await _checkBadge(userId, 'streak_14', progression.streakDays >= 14, awarded, xpReward: 100);
    await _checkBadge(userId, 'streak_30', progression.streakDays >= 30, awarded, xpReward: 300);
    await _checkBadge(userId, 'streak_100', progression.streakDays >= 100, awarded, xpReward: 1000);

    await _checkBadge(userId, 'xp_1000', progression.totalXpEver >= 1000, awarded, xpReward: 50);
    await _checkBadge(userId, 'xp_5000', progression.totalXpEver >= 5000, awarded, xpReward: 200);
    await _checkBadge(userId, 'xp_10000', progression.totalXpEver >= 10000, awarded, xpReward: 500);
    await _checkBadge(userId, 'xp_50000', progression.totalXpEver >= 50000, awarded,
        xpReward: 2000);

    await _checkBadge(userId, 'lessons_10', progression.lessonsCompleted >= 10, awarded,
        xpReward: 80);
    await _checkBadge(userId, 'lessons_50', progression.lessonsCompleted >= 50, awarded,
        xpReward: 300);

    await _checkBadge(userId, 'words_200', progression.wordsMastered >= 200, awarded,
        xpReward: 250);
    await _checkBadge(userId, 'perfect_5', progression.perfectScores >= 5, awarded, xpReward: 100);

    await _checkBadge(userId, 'level_5', progression.currentLevel >= 5, awarded, xpReward: 150);
    await _checkBadge(userId, 'level_10', progression.currentLevel >= 10, awarded, xpReward: 400);
    await _checkBadge(userId, 'level_20', progression.currentLevel >= 20, awarded, xpReward: 1000);

    return awarded;
  }

  Future<void> _checkBadge(String userId, String badgeKey, bool condition, List<BadgeModel> awarded,
      {required int xpReward}) async {
    if (!condition) return;
    final alreadyEarned = await _hasBadge(userId, badgeKey);
    if (alreadyEarned) return;
    await _awardBadge(userId, badgeKey, xpReward);
    final badge = await getBadge(badgeKey, userId: userId);
    if (badge != null) {
      awarded.add(badge);
    }
  }

  Future<BadgeModel?> awardBadge(
      {required String userId, required String badgeKey, int xpReward = 0}) async {
    final alreadyEarned = await _hasBadge(userId, badgeKey);
    if (alreadyEarned) return null;
    await _awardBadge(userId, badgeKey, xpReward);
    return await getBadge(badgeKey, userId: userId);
  }

  Future<List<BadgeModel>> getAllBadges(String userId) async {
    final db = await _db.database;
    final badgesRes = await db.query('badges', orderBy: 'sort_order ASC');
    final userBadgesRes = await db.query('user_badges', where: 'user_id = ?', whereArgs: [userId]);

    final Map<String, Map<String, dynamic>> userBadgesMap = {
      for (var item in userBadgesRes) item['badge_key'] as String: item
    };

    return badgesRes.map((map) {
      final badgeKey = map['badge_key'] as String;
      return BadgeModel.fromMap(map, userBadgeMap: userBadgesMap[badgeKey]);
    }).toList();
  }

  Future<List<BadgeModel>> getEarnedBadges(String userId) async {
    final all = await getAllBadges(userId);
    return all.where((b) => b.isEarned).toList();
  }

  Future<BadgeModel?> getBadge(String badgeKey, {String? userId}) async {
    final db = await _db.database;
    final res = await db.query('badges', where: 'badge_key = ?', whereArgs: [badgeKey]);
    if (res.isEmpty) return null;

    Map<String, dynamic>? userBadgeMap;
    if (userId != null) {
      final ubRes = await db.query('user_badges',
          where: 'user_id = ? AND badge_key = ?', whereArgs: [userId, badgeKey]);
      if (ubRes.isNotEmpty) userBadgeMap = ubRes.first;
    }

    return BadgeModel.fromMap(res.first, userBadgeMap: userBadgeMap);
  }

  Future<bool> _hasBadge(String userId, String badgeKey) async {
    final db = await _db.database;
    final res = await db.query('user_badges',
        where: 'user_id = ? AND badge_key = ?', whereArgs: [userId, badgeKey]);
    return res.isNotEmpty;
  }

  Future<void> _awardBadge(String userId, String badgeKey, int xpReward) async {
    final db = await _db.database;
    await db.execute('''
      INSERT OR IGNORE INTO user_badges (user_id, badge_key, earned_at, xp_rewarded)
      VALUES (?, ?, datetime('now'), ?)
    ''', [userId, badgeKey, xpReward]);
  }

  Future<void> resetUserBadgesForTest(String userId) async {
    final db = await _db.database;
    await db.delete('user_badges', where: 'user_id = ?', whereArgs: [userId]);
  }
}
