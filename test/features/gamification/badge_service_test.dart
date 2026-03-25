// ignore_for_file: unused_local_variable
import 'package:flutter_test/flutter_test.dart';
import 'package:linguaverse/features/gamification/data/services/badge_service.dart';
import 'package:linguaverse/features/gamification/data/services/progression_service.dart';
import '../../helpers/test_database_helper.dart';

void main() {
  late BadgeService badgeService;
  late ProgressionService progressionService;
  late String testUserId;

  setUp(() async {
    final dbHelper = await createTestDB();
    progressionService = ProgressionService(dbHelper);
    badgeService = BadgeService(dbHelper);
    testUserId = 'test_badge_user_${DateTime.now().microsecondsSinceEpoch}';
    await progressionService.initUserProgression(testUserId);
  });

  group('catalogue des badges', () {
    test('20 badges sont disponibles dans le catalogue', () async {
      final all = await badgeService.getAllBadges(testUserId);
      expect(all.length, greaterThanOrEqualTo(20));
    });

    test('tous les badges sont verrouillés au départ', () async {
      final all = await badgeService.getAllBadges(testUserId);
      final earned = all.where((b) => b.isEarned).toList();
      expect(earned, isEmpty);
    });
  });

  group('attribution de badges', () {
    test('streak_7 attribué quand streak == 7', () async {
      await progressionService.setStreakForTest(testUserId, 7);
      final prog = await progressionService.getProgression(testUserId);
      final awarded = await badgeService.checkAndAwardAllBadges(
          testUserId, prog!);
      final keys = awarded.map((b) => b.badgeKey).toList();
      expect(keys, contains('streak_7'));
    });

    test('streak_7 non attribué si streak == 6', () async {
      await progressionService.setStreakForTest(testUserId, 6);
      final prog = await progressionService.getProgression(testUserId);
      final awarded = await badgeService.checkAndAwardAllBadges(
          testUserId, prog!);
      final keys = awarded.map((b) => b.badgeKey).toList();
      expect(keys, isNot(contains('streak_7')));
    });

    test('xp_1000 attribué quand totalXpEver >= 1000', () async {
      await progressionService.addXP(
        userId: testUserId,
        sourceType: 'lesson_complete',
        overrideAmount: 1000,
        userInitials: 'TB',
        userName: 'Test Badge',
      );
      final prog = await progressionService.getProgression(testUserId);
      final awarded = await badgeService.getEarnedBadges(testUserId);
      final keys = awarded.map((b) => b.badgeKey).toList();
      expect(keys, contains('xp_1000'));
    });
  });

  group('protection contre la double attribution', () {
    test('badge déjà attribué n\'est pas ré-attribué', () async {
      await progressionService.setStreakForTest(testUserId, 7);
      final prog = await progressionService.getProgression(testUserId);

      // Première attribution
      final first = await badgeService.checkAndAwardAllBadges(
          testUserId, prog!);
      expect(first.map((b) => b.badgeKey), contains('streak_7'));

      // Deuxième vérification — doit être vide
      final second = await badgeService.checkAndAwardAllBadges(
          testUserId, prog);
      expect(second.where((b) => b.badgeKey == 'streak_7'), isEmpty);
    });
  });

  group('getEarnedBadges', () {
    test('retourne uniquement les badges gagnés', () async {
      // Attribuer un badge
      await progressionService.setStreakForTest(testUserId, 7);
      final prog = await progressionService.getProgression(testUserId);
      await badgeService.checkAndAwardAllBadges(testUserId, prog!);

      final earned = await badgeService.getEarnedBadges(testUserId);
      expect(earned, isNotEmpty);
      expect(earned.every((b) => b.isEarned), isTrue);
    });
  });
}
