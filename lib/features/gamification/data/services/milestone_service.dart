import '../../../../core/services/database_helper.dart';
import '../models/milestone_model.dart';

class MilestoneService {
  final DatabaseHelper _db;
  MilestoneService(this._db);

  Future<void> initDefaultMilestones(String userId) async {
    final defaults = [
      ('streak_goal', 7, 50),
      ('streak_goal', 14, 100),
      ('streak_goal', 30, 300),
      ('xp_goal', 1000, 50),
      ('xp_goal', 5000, 200),
      ('lessons_goal', 10, 80),
      ('words_goal', 100, 150),
      ('level_goal', 5, 200),
    ];
    final db = await _db.database;
    for (final m in defaults) {
      await db.execute('''
        INSERT INTO milestones (user_id, milestone_type, target_value, xp_reward, created_at)
        SELECT ?, ?, ?, ?, datetime('now')
        WHERE NOT EXISTS (
          SELECT 1 FROM milestones 
          WHERE user_id = ? AND milestone_type = ? AND target_value = ?
        )
      ''', [userId, m.$1, m.$2, m.$3, userId, m.$1, m.$2]);
    }
  }

  Future<List<MilestoneModel>> updateProgress(
      String userId, String milestoneType, int currentValue) async {
    final db = await _db.database;

    final allMilestonesRes = await db.query(
      'milestones',
      where: 'user_id = ? AND milestone_type = ? AND is_completed = 0',
      whereArgs: [userId, milestoneType],
    );

    List<MilestoneModel> completed = [];

    for (final row in allMilestonesRes) {
      final int id = row['id'] as int;
      final int targetValue = row['target_value'] as int;
      final bool completesNow = currentValue >= targetValue;

      await db.update(
        'milestones',
        {
          'current_value': currentValue,
          if (completesNow) 'is_completed': 1,
          if (completesNow) 'completed_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (completesNow) {
        final updatedRow = await db.query('milestones', where: 'id = ?', whereArgs: [id]);
        if (updatedRow.isNotEmpty) {
          completed.add(MilestoneModel.fromMap(updatedRow.first));
        }
      }
    }

    return completed;
  }

  Future<List<MilestoneModel>> getActiveMilestones(String userId) async {
    final db = await _db.database;
    final res = await db.query(
      'milestones',
      where: 'user_id = ? AND is_completed = 0',
      whereArgs: [userId],
      orderBy: 'target_value ASC',
    );
    return res.map((e) => MilestoneModel.fromMap(e)).toList();
  }

  Future<List<MilestoneModel>> getCompletedMilestones(String userId) async {
    final db = await _db.database;
    final res = await db.query(
      'milestones',
      where: 'user_id = ? AND is_completed = 1',
      whereArgs: [userId],
      orderBy: 'completed_at DESC',
    );
    return res.map((e) => MilestoneModel.fromMap(e)).toList();
  }

  Future<void> syncProgress(String userId, int totalXP, int level) async {
    await updateProgress(userId, 'xp_goal', totalXP);
    await updateProgress(userId, 'level_goal', level);
  }
}
