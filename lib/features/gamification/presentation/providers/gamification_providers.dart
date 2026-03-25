import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/database_helper.dart';

import '../../data/models/user_progression_model.dart';
import '../../data/models/badge_model.dart';
import '../../data/models/leaderboard_entry_model.dart';
import '../../data/models/milestone_model.dart';
import '../../data/models/xp_event_model.dart';

import '../../data/services/progression_service.dart';
import '../../data/services/streak_service.dart';
import '../../data/services/badge_service.dart';
import '../../data/services/leaderboard_service.dart';
import '../../data/services/milestone_service.dart';

// ═══════════════════════════════════════════════════════════════
// MIGRATION_TODO — À connecter quand M1 (Auth) sera terminé
//
// Actuellement : userId hardcodé à 'user_123' pour le dev
// Quand M1 est prêt :
//   1. Remplacer 'user_123' par ref.watch(authStateProvider).userId
//   2. Appeler initUserProgression(userId) au premier login Firebase
//   3. Prévoir une migration des données 'user_123' vers le vrai uid
//      si des données de dev doivent être conservées
// ═══════════════════════════════════════════════════════════════
final currentUserIdProvider = Provider<String>((ref) {
  return 'user_123'; // ← REMPLACER par authStateProvider quand M1 prêt
});
final currentUserNameProvider = Provider<String>((ref) => 'Jules Explorateur');
final currentUserInitialsProvider = Provider<String>((ref) => 'JE');

final databaseHelperProvider = Provider<DatabaseHelper>((ref) => DatabaseHelper());

final progressionServiceProvider = Provider<ProgressionService>((ref) {
  return ProgressionService(ref.watch(databaseHelperProvider));
});

final streakServiceProvider = Provider<StreakService>((ref) {
  return StreakService(ref.watch(databaseHelperProvider));
});

final badgeServiceProvider = Provider<BadgeService>((ref) {
  return BadgeService(ref.watch(databaseHelperProvider));
});

final leaderboardServiceProvider = Provider<LeaderboardService>((ref) {
  return LeaderboardService(ref.watch(databaseHelperProvider));
});

final milestoneServiceProvider = Provider<MilestoneService>((ref) {
  return MilestoneService(ref.watch(databaseHelperProvider));
});

class UserProgressionNotifier extends StateNotifier<AsyncValue<UserProgressionModel?>> {
  final Ref ref;
  UserProgressionNotifier(this.ref) : super(const AsyncLoading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncLoading();
    try {
      final userId = ref.read(currentUserIdProvider);
      final service = ref.read(progressionServiceProvider);
      // Ensure progression exists for demo
      var prog = await service.getProgression(userId);
      if (prog == null) {
        await ref.read(databaseHelperProvider).initUserProgression(userId);
        prog = await service.getProgression(userId);
      }
      state = AsyncData(prog);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => _load();
}

final userProgressionProvider =
    StateNotifierProvider.autoDispose<UserProgressionNotifier, AsyncValue<UserProgressionModel?>>(
        (ref) {
  return UserProgressionNotifier(ref);
});

class BadgesNotifier extends StateNotifier<AsyncValue<List<BadgeModel>>> {
  final Ref ref;
  BadgesNotifier(this.ref) : super(const AsyncLoading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncLoading();
    try {
      final userId = ref.read(currentUserIdProvider);
      final badges = await ref.read(badgeServiceProvider).getAllBadges(userId);
      state = AsyncData(badges);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => _load();
}

final badgesProvider =
    StateNotifierProvider.autoDispose<BadgesNotifier, AsyncValue<List<BadgeModel>>>((ref) {
  return BadgesNotifier(ref);
});

class LeaderboardNotifier extends StateNotifier<AsyncValue<LeaderboardData>> {
  final Ref ref;
  LeaderboardNotifier(this.ref) : super(const AsyncLoading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncLoading();
    try {
      final userId = ref.read(currentUserIdProvider);
      final data =
          await ref.read(leaderboardServiceProvider).getLeaderboardWithUserPosition(userId);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => _load();
}

final leaderboardProvider =
    StateNotifierProvider.autoDispose<LeaderboardNotifier, AsyncValue<LeaderboardData>>((ref) {
  return LeaderboardNotifier(ref);
});

class MilestonesNotifier extends StateNotifier<AsyncValue<List<MilestoneModel>>> {
  final Ref ref;
  MilestonesNotifier(this.ref) : super(const AsyncLoading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncLoading();
    try {
      final userId = ref.read(currentUserIdProvider);
      final service = ref.read(milestoneServiceProvider);
      await service.initDefaultMilestones(userId);
      final active = await service.getActiveMilestones(userId);
      state = AsyncData(active);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => _load();
}

final activeMilestonesProvider =
    StateNotifierProvider.autoDispose<MilestonesNotifier, AsyncValue<List<MilestoneModel>>>((ref) {
  return MilestonesNotifier(ref);
});

final weeklyXPProvider =
    FutureProvider.autoDispose.family<Map<String, int>, String>((ref, userId) async {
  final service = ref.watch(progressionServiceProvider);
  return service.getXPByDayThisWeek(userId);
});

final recentXPEventsProvider =
    FutureProvider.autoDispose.family<List<XpEventModel>, String>((ref, userId) async {
  final service = ref.watch(progressionServiceProvider);
  return service.getRecentXPEvents(userId, limit: 30);
});

final addXPProvider = Provider<
    Future<XpGainResult> Function({
      required String sourceType,
      String? sourceId,
      String? sourceName,
      String? language,
      int? overrideAmount,
    })>((ref) {
  return ({required sourceType, sourceId, sourceName, language, overrideAmount}) async {
    final userId = ref.read(currentUserIdProvider);
    final userName = ref.read(currentUserNameProvider);
    final userInitials = ref.read(currentUserInitialsProvider);

    final result = await ref.read(progressionServiceProvider).addXP(
          userId: userId,
          userName: userName,
          userInitials: userInitials,
          sourceType: sourceType,
          sourceId: sourceId,
          sourceName: sourceName,
          language: language,
          overrideAmount: overrideAmount,
        );

    // Synchro Jalons basé sur la nouvelle progression
    await ref
        .read(milestoneServiceProvider)
        .syncProgress(userId, result.newTotalXP, result.newLevel);

    // Invalidate dependent providers to trigger UI refresh
    ref.invalidate(userProgressionProvider);
    ref.invalidate(badgesProvider);
    ref.invalidate(leaderboardProvider);
    ref.invalidate(recentXPEventsProvider);
    ref.invalidate(weeklyXPProvider);
    ref.invalidate(activeMilestonesProvider);

    return result;
  };
});
