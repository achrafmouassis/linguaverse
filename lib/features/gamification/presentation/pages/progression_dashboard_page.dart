import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/constants.dart';
import '../providers/gamification_providers.dart';
import '../widgets/xp_ring_painter.dart';
import '../widgets/stat_card.dart';
import '../widgets/xp_bar_chart.dart';
import '../widgets/xp_line_chart.dart';

class ProgressionDashboardPage extends ConsumerStatefulWidget {
  const ProgressionDashboardPage({super.key});

  @override
  ConsumerState<ProgressionDashboardPage> createState() => _ProgressionDashboardPageState();
}

class _ProgressionDashboardPageState extends ConsumerState<ProgressionDashboardPage>
    with TickerProviderStateMixin {
  late final AnimationController _ringCtrl;
  late final AnimationController _entryCtrl;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _ringCtrl.forward();
        _entryCtrl.forward();
      }
    });

    // Refresh data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProgressionProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progState = ref.watch(userProgressionProvider);
    final userId = ref.watch(currentUserIdProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: progState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Erreur: $err')),
        data: (progression) {
          if (progression == null) return const Center(child: Text('Progression introuvable.'));

          final xpProgress = progression.xpProgress;
          // currentLevel used directly below to avoid unused warning in some analyzer versions

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title:
                      const Text('Ma progression', style: TextStyle(fontWeight: FontWeight.bold)),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  background: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryDark,
                              isDark ? AppColors.deepSpaceBlue : AppColors.background
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _ringCtrl,
                            builder: (context, _) {
                              final ringVal =
                                  Curves.easeOutExpo.transform(_ringCtrl.value) * xpProgress;
                              return Transform.rotate(
                                angle: _ringCtrl.value * 0.26, // 15 degrees
                                child: SizedBox(
                                  width: 140,
                                  height: 140,
                                  child: CustomPaint(
                                    painter: XpRingPainter(
                                        progress: ringVal, baseColor: AppColors.primary),
                                    child: Center(
                                      child: Transform.rotate(
                                        angle: -_ringCtrl.value * 0.26,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'NIVEAU ${progression.currentLevel}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              progression.levelTitle,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white.withValues(alpha: 0.7),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: const [],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    FadeTransition(
                      opacity: _entryCtrl,
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
                            .animate(
                                CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 3 top stats
                            Row(
                              children: [
                                Expanded(
                                    child: StatCard(
                                        icon: Icons.local_fire_department_rounded,
                                        label: 'Streak',
                                        value: progression.streakDays,
                                        color: AppColors.streakOrange)),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: StatCard(
                                        icon: Icons.stars_rounded,
                                        label: 'XP tot.',
                                        value: progression.totalXpEver,
                                        color: AppColors.xpGold)),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: StatCard(
                                        icon: Icons.menu_book_rounded,
                                        label: 'Leçons',
                                        value: progression.lessonsCompleted,
                                        color: AppColors.primary)),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Bar chart
                            Text(
                              'XP cette semaine',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            ref.watch(weeklyXPProvider(userId)).when(
                                  data: (data) => XpBarChart(data: data),
                                  loading: () => const SizedBox(
                                      height: 180,
                                      child: Center(child: CircularProgressIndicator())),
                                  error: (e, st) => SizedBox(
                                      height: 180, child: Center(child: Text('Erreur: $e'))),
                                ),
                            const SizedBox(height: 32),

                            // Line chart (dummy history based on total for now, real app would query points in time)
                            Text(
                              'Évolution de l\'XP',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            XpLineChart(xpHistory: _generateMockHistory(progression.totalXpEver)),
                            const SizedBox(height: 32),

                            // Grid Stats
                            Text(
                              'Statistiques détaillées',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            LayoutBuilder(builder: (context, constraints) {
                              final double w = (constraints.maxWidth - 12) / 2;
                              return Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  SizedBox(
                                      width: w,
                                      child: StatCard(
                                          icon: Icons.translate,
                                          label: 'Mots',
                                          value: progression.wordsMastered,
                                          color: AppColors.secondary)),
                                  SizedBox(
                                      width: w,
                                      child: StatCard(
                                          icon: Icons.quiz_rounded,
                                          label: 'Quiz',
                                          value: progression.quizzesCompleted,
                                          color: AppColors.tertiary)),
                                  SizedBox(
                                      width: w,
                                      child: StatCard(
                                          icon: Icons.bolt_rounded,
                                          label: 'Parfaits',
                                          value: progression.perfectScores,
                                          color: AppColors.primary)),
                                  SizedBox(
                                      width: w,
                                      child: StatCard(
                                          icon: Icons.timer_rounded,
                                          label: 'Minutes',
                                          value: progression.totalStudyMinutes,
                                          color: AppColors.streakOrange)),
                                ],
                              );
                            }),
                            const SizedBox(height: 32),

                            // Recent history
                            Text(
                              'Historique récent',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            ref.watch(recentXPEventsProvider(userId)).when(
                                  data: (events) {
                                    if (events.isEmpty) {
                                      return const Text('Aucune activité récente.');
                                    }
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: events.length > 5 ? 5 : events.length,
                                      separatorBuilder: (_, __) => const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final evt = events[index];
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                AppColors.primary.withValues(alpha: 0.1),
                                            child: const Icon(Icons.auto_awesome,
                                                color: AppColors.primary, size: 18),
                                          ),
                                          title: Text(evt.sourceLabel,
                                              style: const TextStyle(fontWeight: FontWeight.w600)),
                                          subtitle: Text(
                                            "${evt.createdAt.day}/${evt.createdAt.month} à ${evt.createdAt.hour}h${evt.createdAt.minute.toString().padLeft(2, '0')}",
                                          ),
                                          trailing: Text(
                                            '+${evt.effectiveXP} XP',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.xpGold),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  loading: () => const Center(child: CircularProgressIndicator()),
                                  error: (e, st) => Text('Erreur: $e'),
                                ),
                            const SizedBox(height: 48), // Bottom padding
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Map<String, int> _generateMockHistory(int currentTotal) {
    if (currentTotal == 0) return {};
    final now = DateTime.now();
    Map<String, int> res = {};
    int xp = currentTotal;
    for (int i = 0; i < 7; i++) {
      final d = now.subtract(Duration(days: i));
      res[d.toIso8601String().split('T').first] = xp;
      // Subtract random realistic amounts going backwards
      xp -= (xp * 0.05).round().clamp(50, 500);
      if (xp < 0) xp = 0;
    }
    return res;
  }
}
