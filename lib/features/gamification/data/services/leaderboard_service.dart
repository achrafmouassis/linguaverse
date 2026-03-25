// ignore_for_file: unused_local_variable
import '../../../../core/services/database_helper.dart';
import '../models/leaderboard_entry_model.dart';

class LeaderboardService {
  final DatabaseHelper _db;
  LeaderboardService(this._db);

  static String currentWeekKey() {
    final now = DateTime.now();
    final jan1 = DateTime(now.year, 1, 1);
    final weekNum = ((now.difference(jan1).inDays + jan1.weekday) / 7).ceil();
    return '${now.year}-W${weekNum.toString().padLeft(2, "0")}';
  }

  Future<void> updateUserScore({
    required String userId,
    required String userName,
    required String userInitials,
    required int xpEarned,
    required String language,
  }) async {
    final db = await _db.database;
    final weekKey = currentWeekKey();

    // Upsert equivalent
    await db.execute('''
      INSERT INTO weekly_leaderboard (user_id, user_name, user_initials, week_key, language, xp_earned, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, datetime('now'))
      ON CONFLICT(user_id, week_key, language) DO UPDATE SET
        xp_earned = xp_earned + ?,
        updated_at = datetime('now')
    ''', [userId, userName, userInitials, weekKey, language, xpEarned, xpEarned]);

    // Recalculate ranks for the current week/language
    await _updateRanks(weekKey, language);
  }

  Future<void> _updateRanks(String weekKey, String language) async {
    final db = await _db.database;
    final List<Map<String, dynamic>> sorted = await db.query(
      'weekly_leaderboard',
      where: 'week_key = ? AND language = ?',
      whereArgs: [weekKey, language],
      orderBy: 'xp_earned DESC',
    );

    int rank = 1;
    for (final row in sorted) {
      final int id = row['id'] as int;
      await db.update(
        'weekly_leaderboard',
        {'rank_position': rank},
        where: 'id = ?',
        whereArgs: [id],
      );
      rank++;
    }
  }

  Future<List<LeaderboardEntry>> getTopPlayers({
    int limit = 20,
    String language = 'all',
  }) async {
    final db = await _db.database;
    final weekKey = currentWeekKey();
    final res = await db.query(
      'weekly_leaderboard',
      where: 'week_key = ? AND language = ?',
      whereArgs: [weekKey, language],
      orderBy: 'rank_position ASC',
      limit: limit,
    );
    return res.map((e) => LeaderboardEntry.fromMap(e)).toList();
  }

  Future<int?> getUserRank(String userId, {String language = 'all'}) async {
    final db = await _db.database;
    final weekKey = currentWeekKey();
    final res = await db.query(
      'weekly_leaderboard',
      columns: ['rank_position'],
      where: 'week_key = ? AND language = ? AND user_id = ?',
      whereArgs: [weekKey, language, userId],
    );
    if (res.isNotEmpty) return res.first['rank_position'] as int?;
    return null;
  }

  Future<LeaderboardData> getLeaderboardWithUserPosition(String userId,
      {String language = 'all'}) async {
    final topPlayers = await getTopPlayers(limit: 20, language: language);

    final db = await _db.database;
    final weekKey = currentWeekKey();
    final res = await db.query(
      'weekly_leaderboard',
      where: 'week_key = ? AND language = ? AND user_id = ?',
      whereArgs: [weekKey, language, userId],
    );

    LeaderboardEntry? currentUserEntry;
    int? currentUserRank;

    if (res.isNotEmpty) {
      currentUserEntry = LeaderboardEntry.fromMap(res.first);
      currentUserRank = currentUserEntry.rankPosition;
    }

    return LeaderboardData(
      topPlayers: topPlayers,
      currentUserEntry: currentUserEntry,
      currentUserRank: currentUserRank,
    );
  }
}
