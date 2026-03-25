import '../../../../core/services/database_helper.dart';
import '../models/user_progression_model.dart';

class StreakUpdateResult {
  final int previousStreak;
  final int newStreak;
  final bool streakBroken;
  final bool newRecord;
  final int? bonusXP;

  StreakUpdateResult({
    required this.previousStreak,
    required this.newStreak,
    required this.streakBroken,
    required this.newRecord,
    this.bonusXP,
  });
}

class StreakService {
  final DatabaseHelper _db;
  StreakService(this._db);

  Future<StreakUpdateResult> recordActivity(String userId) async {
    final db = await _db.database;
    final res = await db.query('user_progression', where: 'user_id = ?', whereArgs: [userId]);
    if (res.isEmpty) {
      await _db.initUserProgression(userId);
      return recordActivity(userId); // Retry
    }

    final data = res.first;
    final String? lastActivityDateStr = data['last_activity_date'] as String?;
    final int currentStreak = data['streak_days'] as int;
    final int streakBest = data['streak_best'] as int;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    int newStreak = currentStreak;
    bool streakBroken = false;
    bool newRecord = false;
    int? bonusXP;

    if (lastActivityDateStr == null) {
      newStreak = 1;
      newRecord = true;
    } else {
      final lastActivity = DateTime.parse(lastActivityDateStr);
      final lastDate = DateTime(lastActivity.year, lastActivity.month, lastActivity.day);
      final diff = todayDate.difference(lastDate).inDays;

      if (diff == 0) {
        return StreakUpdateResult(
            previousStreak: currentStreak,
            newStreak: currentStreak,
            streakBroken: false,
            newRecord: false);
      } else if (diff == 1) {
        newStreak += 1;
      } else {
        newStreak = 1;
        streakBroken = true;
      }
    }

    if (newStreak >= streakBest) {
      newRecord = true;
    }

    await db.update(
      'user_progression',
      {
        'streak_days': newStreak,
        'streak_best': newRecord ? newStreak : streakBest,
        'last_activity_date': todayDate.toIso8601String(),
      },
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    // Simple bonus logic for major milestones
    if (newStreak % 7 == 0 && newStreak <= 100) {
      bonusXP = 50 * (newStreak ~/ 7);
    }

    return StreakUpdateResult(
      previousStreak: currentStreak,
      newStreak: newStreak,
      streakBroken: streakBroken,
      newRecord: newRecord,
      bonusXP: bonusXP,
    );
  }

  Future<bool> isStreakAlive(String userId) async {
    final db = await _db.database;
    final res = await db.query('user_progression',
        columns: ['last_activity_date'], where: 'user_id = ?', whereArgs: [userId]);
    if (res.isEmpty) return false;
    final lastStr = res.first['last_activity_date'] as String?;
    if (lastStr == null) return false;
    final last = DateTime.parse(lastStr);
    final today = DateTime.now();
    final diff = DateTime(today.year, today.month, today.day)
        .difference(DateTime(last.year, last.month, last.day))
        .inDays;
    return diff <= 1;
  }

  Future<int> getCurrentStreak(String userId) async {
    final db = await _db.database;
    final res = await db.query('user_progression',
        columns: ['streak_days'], where: 'user_id = ?', whereArgs: [userId]);
    if (res.isEmpty) return 0;
    return res.first['streak_days'] as int;
  }

  Duration? timeUntilStreakBreaks(String lastActivityDate) {
    final last = DateTime.parse(lastActivityDate);
    final lastDate = DateTime(last.year, last.month, last.day);
    final deadline = lastDate.add(const Duration(days: 2));
    final diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return null;
    return diff;
  }

  Future<void> initUserProgression(String userId) async {
    await _db.initUserProgression(userId);
  }

  Future<void> setLastActivityDateForTest(String userId, DateTime date) async {
    final db = await _db.database;
    await db.update(
      'user_progression',
      {'last_activity_date': date.toIso8601String()},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> setStreakForTest(String userId, int streak) async {
    final db = await _db.database;
    await db.update(
      'user_progression',
      {'streak_days': streak, 'streak_best': streak},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<UserProgressionModel?> getProgression(String userId) async {
    final db = await _db.database;
    final res = await db.query('user_progression', where: 'user_id = ?', whereArgs: [userId]);
    if (res.isEmpty) return null;
    return UserProgressionModel.fromMap(res.first);
  }
}
