import 'package:flutter_test/flutter_test.dart';
import 'package:linguaverse/features/gamification/data/services/streak_service.dart';
import '../../helpers/test_database_helper.dart';

void main() {
  late StreakService service;
  late String testUserId;

  setUp(() async {
    final dbHelper = await createTestDB();
    service = StreakService(dbHelper);
    testUserId = 'test_streak_user_${DateTime.now().microsecondsSinceEpoch}';
    await service.initUserProgression(testUserId);
  });

  group('recordActivity — cas diff==0 (déjà actif aujourd\'hui)', () {
    test('deux activités le même jour ne doublent pas le streak', () async {
      await service.recordActivity(testUserId);
      final after1 = await service.getCurrentStreak(testUserId);

      await service.recordActivity(testUserId);
      final after2 = await service.getCurrentStreak(testUserId);

      expect(after1, equals(after2)); // le streak ne change pas
    });
  });

  group('recordActivity — cas diff==1 (activité hier)', () {
    test('activité consécutive incrémente le streak', () async {
      // Simuler une activité hier
      await service.setLastActivityDateForTest(
        testUserId,
        DateTime.now().subtract(const Duration(days: 1)),
      );
      final result = await service.recordActivity(testUserId);
      expect(result.streakBroken, isFalse);
      expect(result.newStreak, greaterThan(result.previousStreak));
    });
  });

  group('recordActivity — cas diff>=2 (streak cassé)', () {
    test('gap de 2 jours remet le streak à 1', () async {
      // Simuler une activité il y a 2 jours
      await service.setLastActivityDateForTest(
        testUserId,
        DateTime.now().subtract(const Duration(days: 2)),
      );
      await service.setStreakForTest(testUserId, 10); // streak précédent = 10
      final result = await service.recordActivity(testUserId);

      expect(result.streakBroken, isTrue);
      expect(result.newStreak, equals(1));
    });

    test('gap de 10 jours remet le streak à 1', () async {
      await service.setLastActivityDateForTest(
        testUserId,
        DateTime.now().subtract(const Duration(days: 10)),
      );
      await service.setStreakForTest(testUserId, 25);
      final result = await service.recordActivity(testUserId);

      expect(result.streakBroken, isTrue);
      expect(result.newStreak, equals(1));
    });
  });

  group('streak_best mis à jour', () {
    test('streak_best augmente si nouveau record', () async {
      await service.setStreakForTest(testUserId, 5);
      await service.setLastActivityDateForTest(
        testUserId,
        DateTime.now().subtract(const Duration(days: 1)),
      );
      final result = await service.recordActivity(testUserId);
      expect(result.newRecord, isTrue); // 6 > 5
    });

    test('streak_best ne diminue pas si streak cassé', () async {
      await service.setStreakForTest(testUserId, 20);
      await service.setLastActivityDateForTest(
        testUserId,
        DateTime.now().subtract(const Duration(days: 5)),
      );
      await service.recordActivity(testUserId);
      final prog = await service.getProgression(testUserId);
      expect(prog!.streakBest, equals(20)); // le record reste à 20
    });
  });

  group('isStreakAlive', () {
    test('alive si activité aujourd\'hui', () async {
      await service.recordActivity(testUserId);
      expect(await service.isStreakAlive(testUserId), isTrue);
    });

    test('alive si activité hier', () async {
      await service.setLastActivityDateForTest(
        testUserId,
        DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(await service.isStreakAlive(testUserId), isTrue);
    });

    test('mort si activité il y a 2 jours', () async {
      await service.setLastActivityDateForTest(
        testUserId,
        DateTime.now().subtract(const Duration(days: 2)),
      );
      expect(await service.isStreakAlive(testUserId), isFalse);
    });
  });
}
