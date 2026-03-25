import 'package:flutter_test/flutter_test.dart';
import 'package:linguaverse/features/gamification/data/models/user_progression_model.dart';
import 'package:linguaverse/features/gamification/data/services/progression_service.dart';
import '../../helpers/test_database_helper.dart';

void main() {
  late ProgressionService service;
  late String testUserId;
  const uInit = 'TU';
  const uName = 'Test User';

  setUp(() async {
    final dbHelper = await createTestDB();
    service = ProgressionService(dbHelper);
    testUserId = 'test_prog_user_${DateTime.now().microsecondsSinceEpoch}';
    await service.initUserProgression(testUserId);
  });

  group('xpForLevel formula', () {
    test('levelFromXP(500) retourne niveau 2', () {
      expect(UserProgressionModel.levelFromXP(500), equals(2));
    });

    test('levelFromXP(499) reste au niveau 1', () {
      expect(UserProgressionModel.levelFromXP(499), equals(1));
    });
  });

  group('addXP', () {
    test('addXP lesson_complete ajoute 50 XP', () async {
      final result = await service.addXP(
        userId: testUserId,
        sourceType: 'lesson_complete',
        userInitials: uInit,
        userName: uName,
      );
      expect(result.xpAdded, equals(50));
      expect(result.newTotalXP, equals(50));
    });

    test('addXP quiz_perfect ajoute 100 XP', () async {
      final result = await service.addXP(
        userId: testUserId,
        sourceType: 'quiz_perfect',
        userInitials: uInit,
        userName: uName,
      );
      expect(result.xpAdded, equals(100));
    });

    test('addXP multiple est cumulatif', () async {
      await service.addXP(userId: testUserId, sourceType: 'lesson_complete', userInitials: uInit, userName: uName);
      await service.addXP(userId: testUserId, sourceType: 'lesson_complete', userInitials: uInit, userName: uName);
      final prog = await service.getProgression(testUserId);
      expect(prog!.totalXpEver, equals(100));
    });

    test('montée de niveau détectée correctement', () async {
      final result = await service.addXP(
        userId: testUserId,
        sourceType: 'lesson_complete',
        userInitials: uInit,
        userName: uName,
        overrideAmount: 500,
      );
      expect(result.levelUp, isNotNull);
      expect(result.levelUp!.newLevel, equals(2));
      expect(result.levelUp!.oldLevel, equals(1));
    });

    test('pas de levelUp si XP insuffisant', () async {
      final result = await service.addXP(
        userId: testUserId,
        sourceType: 'lesson_complete',
        userInitials: uInit,
        userName: uName,
        overrideAmount: 100,
      );
      expect(result.levelUp, isNull);
    });
  });

  group('streak multiplier', () {
    test('streak 0 -> multiplicateur 1.0', () async {
      final result = await service.addXP(
        userId: testUserId,
        sourceType: 'lesson_complete',
        userInitials: uInit,
        userName: uName,
      );
      expect(result.multiplierUsed, equals(1.0));
    });

    test('streak 7 -> multiplicateur 1.05', () async {
      await service.setStreakForTest(testUserId, 7);
      final result = await service.addXP(
        userId: testUserId,
        sourceType: 'lesson_complete',
        userInitials: uInit,
        userName: uName,
      );
      expect(result.multiplierUsed, equals(1.05));
    });

    test('streak 100 -> multiplicateur plafonné à 1.20', () async {
      await service.setStreakForTest(testUserId, 100);
      final result = await service.addXP(
        userId: testUserId,
        sourceType: 'lesson_complete',
        userInitials: uInit,
        userName: uName,
      );
      expect(result.multiplierUsed, equals(1.20));
    });
  });

  group('getXPByDayThisWeek', () {
    test('retourne une map avec 7 entrées', () async {
      final xpByDay = await service.getXPByDayThisWeek(testUserId);
      expect(xpByDay.length, equals(7));
    });

    test('XP du jour reflète les gains récents', () async {
      await service.addXP(
        userId: testUserId,
        sourceType: 'quiz_perfect',
        userInitials: uInit,
        userName: uName,
      );
      final xpByDay = await service.getXPByDayThisWeek(testUserId);
      final today = DateTime.now();
      final todayKey = today.toIso8601String().split('T').first;
      expect(xpByDay[todayKey], greaterThan(0));
    });
  });
}
