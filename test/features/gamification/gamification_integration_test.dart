import 'package:flutter_test/flutter_test.dart';
import 'package:linguaverse/features/gamification/data/services/progression_service.dart';
import 'package:linguaverse/features/gamification/data/services/streak_service.dart';
import 'package:linguaverse/features/gamification/data/services/badge_service.dart';
import 'package:linguaverse/features/gamification/data/services/milestone_service.dart';
import 'package:flutter/foundation.dart';
import '../../helpers/test_database_helper.dart';

void main() {
  test('Integration Test: Full Gamification User Journey', () async {
    // 1. Setup isolated DB
    final dbHelper = await createTestDB();
    final progressionService = ProgressionService(dbHelper);
    final streakService = StreakService(dbHelper);
    final badgeService = BadgeService(dbHelper); // Inits milestones table too via DB helper 
    final milestoneService = MilestoneService(dbHelper);

    final userId = 'integration_user_${DateTime.now().microsecondsSinceEpoch}';

    // 2. Init User
    await progressionService.initUserProgression(userId);
    var prog = await progressionService.getProgression(userId);
    expect(prog!.currentLevel, 1);
    expect(prog.totalXpEver, 0);

    // 3. Simulate multiple activities (Game wins)
    // Winning 3 games (Wordle, Hangman, etc.)
    await streakService.recordActivity(userId);
    
    // Win 1: +1500 XP (enough for level up and xp_1000 badge)
    final res1 = await progressionService.addXP(
      userId: userId,
      userName: 'Integrator',
      userInitials: 'IN',
      sourceType: 'lesson_complete',
      overrideAmount: 1500,
    );
    expect(res1.newLevel, greaterThan(1));
    
    // Sync Milestones (normally done by provider, here manual for service test)
    await milestoneService.syncProgress(userId, res1.newTotalXP, res1.newLevel);

    // 4. Verify Badges
    final badges = await badgeService.getEarnedBadges(userId);
    // Should have earned 'Explorer' or similar if conditions met
    expect(badges, isNotEmpty);

    // 5. Verify Milestones
    final completedMilestones = await milestoneService.getCompletedMilestones(userId);
    // XP 1000 milestone should be completed (1500 > 1000)
    expect(completedMilestones.any((m) => m.milestoneType == 'xp_goal' && m.targetValue == 1000), isTrue);

    // 6. Verify Streak
    final streakCount = await streakService.getCurrentStreak(userId);
    expect(streakCount, 1);
    final isAlive = await streakService.isStreakAlive(userId);
    expect(isAlive, isTrue);

    debugPrint('SUCCESS: Integration test passed - XP: ${res1.newTotalXP}, Level: ${res1.newLevel}, Badges: ${badges.length}');
  });
}
