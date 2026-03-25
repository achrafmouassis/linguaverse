// ignore_for_file: non_constant_identifier_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';
import 'package:linguaverse/features/gamification/presentation/providers/gamification_providers.dart';
import 'package:linguaverse/features/gamification/presentation/widgets/xp_gain_overlay.dart';
import 'package:linguaverse/features/gamification/presentation/widgets/badge_award_overlay.dart';

// Page de test M7 — visible uniquement en kDebugMode
// Accessible via le bouton DEV sur la HomePage
class M7TestPanelPage extends ConsumerStatefulWidget {
  const M7TestPanelPage({super.key});

  @override
  ConsumerState<M7TestPanelPage> createState() => _M7TestPanelPageState();
}

class _M7TestPanelPageState extends ConsumerState<M7TestPanelPage> {
  String _lastAction = 'Aucune action encore';
  bool _isLoading = false;

  // ── Actions de test ──────────────────────────────────────────
  Future<void> _runAction(String label, Future<void> Function() action) async {
    setState(() {
      _isLoading = true;
      _lastAction = '⏳ $label en cours...';
    });
    HapticFeedback.mediumImpact();
    try {
      await action();
      setState(() {
        _isLoading = false;
        _lastAction = '✅ $label → OK';
      });
      HapticFeedback.heavyImpact();
      // Invalider tous les providers pour forcer le rechargement
      ref.invalidate(userProgressionProvider);
      ref.invalidate(badgesProvider);
      ref.invalidate(leaderboardProvider);
      ref.invalidate(activeMilestonesProvider);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _lastAction = '❌ Erreur : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const Scaffold(
        body: Center(child: Text('Disponible uniquement en mode debug')),
      );
    }

    final progression = ref.watch(userProgressionProvider);

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.bgLevel1,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.wrongRed,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'DEV',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Panel de test M7',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _runAction('Reset complet DB', () async {
                await ref
                    .read(progressionServiceProvider)
                    .resetUserForTest(ref.read(currentUserIdProvider));
              });
            },
            child: const Text('RESET', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── État actuel ──────────────────────────────────────
            const _SectionTitle('État actuel de l\'utilisateur'),
            progression.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Erreur: $e', style: const TextStyle(color: Colors.redAccent)),
              data: (prog) {
                if (prog == null) {
                  return const Text('Aucun profil', style: TextStyle(color: Colors.white54));
                }
                return _StateCard(progression: prog);
              },
            ),
            const SizedBox(height: 16),

            // ── Log de la dernière action ────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgLevel2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
              ),
              child: Text(
                _lastAction,
                style: TextStyle(
                  fontSize: 12,
                  color: _lastAction.startsWith('✅')
                      ? AppColors.correctGreen
                      : _lastAction.startsWith('❌')
                          ? AppColors.wrongRed
                          : Colors.white60,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Navigation vers les 4 écrans M7 ─────────────────
            const _SectionTitle('Navigation — Écrans M7'),
            _NavButton('📊 Dashboard Progression', () => context.push('/gamification')),
            _NavButton('🏆 Mes Badges', () => context.push('/gamification/badges')),
            _NavButton('🏅 Classement', () => context.push('/gamification/leaderboard')),
            _NavButton('🎯 Objectifs & Jalons', () => context.push('/gamification/milestones')),
            const SizedBox(height: 20),

            // ── Simulateurs XP ───────────────────────────────────
            const _SectionTitle('Simulateurs XP'),
            _ActionGrid(
              actions: [
                _TestAction('Leçon terminée\n+50 XP', AppColors.primary, () async {
                  final res = await ref.read(addXPProvider)(
                      sourceType: 'lesson_complete', sourceName: 'Leçon test', language: 'Arabe');
                  if (context.mounted) {
                    XPGainOverlay.show(context, res.xpAdded);
                    for (final b in res.newBadges) {
                      BadgeAwardOverlay.show(context, b);
                    }
                  }
                }),
                _TestAction('Quiz parfait\n+100 XP', AppColors.secondary, () async {
                  final res = await ref.read(addXPProvider)(
                      sourceType: 'quiz_perfect', sourceName: 'Quiz test');
                  if (context.mounted) {
                    XPGainOverlay.show(context, res.xpAdded);
                    for (final b in res.newBadges) {
                      BadgeAwardOverlay.show(context, b);
                    }
                  }
                }),
                _TestAction('Défi du jour\n+80 XP', AppColors.xpGold, () async {
                  final res = await ref.read(addXPProvider)(sourceType: 'daily_challenge');
                  if (context.mounted) {
                    XPGainOverlay.show(context, res.xpAdded);
                    for (final b in res.newBadges) {
                      BadgeAwardOverlay.show(context, b);
                    }
                  }
                }),
                _TestAction('Duel gagné\n+120 XP', AppColors.tertiary, () async {
                  final res = await ref.read(addXPProvider)(sourceType: 'duel_win');
                  if (context.mounted) {
                    XPGainOverlay.show(context, res.xpAdded);
                    for (final b in res.newBadges) {
                      BadgeAwardOverlay.show(context, b);
                    }
                  }
                }),
                _TestAction('Scan AR\n+45 XP', AppColors.correctGreen, () async {
                  final res = await ref.read(addXPProvider)(sourceType: 'ar_scan');
                  if (context.mounted) {
                    XPGainOverlay.show(context, res.xpAdded);
                    for (final b in res.newBadges) {
                      BadgeAwardOverlay.show(context, b);
                    }
                  }
                }),
                _TestAction('Prononciation\n+30 XP', AppColors.streakOrange, () async {
                  final res = await ref.read(addXPProvider)(sourceType: 'pronunciation');
                  if (context.mounted) {
                    XPGainOverlay.show(context, res.xpAdded);
                    for (final b in res.newBadges) {
                      BadgeAwardOverlay.show(context, b);
                    }
                  }
                }),
              ],
              onTap: (action) => _runAction(action.label, action.fn),
              isLoading: _isLoading,
            ),
            const SizedBox(height: 20),

            // ── Simulateurs XP en masse ──────────────────────────
            const _SectionTitle('XP en masse (montée de niveau)'),
            Row(children: [
              Expanded(
                  child: _BigButton('+500 XP', AppColors.primary, () async {
                await _runAction('+500 XP', () async {
                  final res = await ref.read(addXPProvider)(
                      sourceType: 'lesson_complete', overrideAmount: 500);
                  if (context.mounted) {
                    XPGainOverlay.show(context, res.xpAdded);
                    for (final b in res.newBadges) {
                      BadgeAwardOverlay.show(context, b);
                    }
                  }
                });
              })),
              const SizedBox(width: 8),
              Expanded(
                  child: _BigButton('+2000 XP', AppColors.tertiary, () async {
                await _runAction('+2000 XP', () async {
                  final res = await ref.read(addXPProvider)(
                      sourceType: 'lesson_complete', overrideAmount: 2000);
                  if (context.mounted) {
                    XPGainOverlay.show(context, res.xpAdded);
                    for (final b in res.newBadges) {
                      BadgeAwardOverlay.show(context, b);
                    }
                  }
                });
              })),
            ]),
            const SizedBox(height: 20),

            // ── Simulateurs Streak ───────────────────────────────
            const _SectionTitle('Simulateurs Streak'),
            Column(children: [
              _FullButton('Enregistrer activité aujourd\'hui\n(incrément ou maintien)',
                  AppColors.streakOrange, () async {
                await _runAction('Activité streak', () async {
                  await ref
                      .read(streakServiceProvider)
                      .recordActivity(ref.read(currentUserIdProvider));
                });
              }),
              const SizedBox(height: 8),
              _FullButton(
                  'Simuler streak cassé\n(dernière activité il y a 3 jours)', Colors.redAccent,
                  () async {
                await _runAction('Streak cassé (simulation)', () async {
                  await ref.read(streakServiceProvider).setLastActivityDateForTest(
                        ref.read(currentUserIdProvider),
                        DateTime.now().subtract(const Duration(days: 3)),
                      );
                  await ref
                      .read(streakServiceProvider)
                      .recordActivity(ref.read(currentUserIdProvider));
                });
              }),
              const SizedBox(height: 8),
              _FullButton(
                  'Forcer streak = 14 jours\n(pour tester le badge streak_14)', Colors.orangeAccent,
                  () async {
                await _runAction('Streak forcé à 14', () async {
                  await ref
                      .read(streakServiceProvider)
                      .setStreakForTest(ref.read(currentUserIdProvider), 14);
                });
              }),
            ]),
            const SizedBox(height: 20),

            // ── Simulateurs Badges ───────────────────────────────
            const _SectionTitle('Simulateurs Badges'),
            Column(children: [
              _FullButton(
                  'Vérifier et attribuer TOUS les badges\n(selon état actuel)', AppColors.xpGold,
                  () async {
                await _runAction('Check badges', () async {
                  final userId = ref.read(currentUserIdProvider);
                  final prog = await ref.read(progressionServiceProvider).getProgression(userId);
                  if (prog != null) {
                    final awarded =
                        await ref.read(badgeServiceProvider).checkAndAwardAllBadges(userId, prog);
                    setState(() {
                      _lastAction = awarded.isEmpty
                          ? '✅ Aucun nouveau badge — conditions non atteintes'
                          : '✅ ${awarded.length} badge(s) attribué(s) : '
                              '${awarded.map((b) => b.name).join(", ")}';
                    });
                  }
                });
              }),
              const SizedBox(height: 8),
              _FullButton('Forcer streak=7 + check badges\n→ badge streak_7 attendu',
                  Colors.deepOrangeAccent, () async {
                await _runAction('Badge streak_7', () async {
                  final userId = ref.read(currentUserIdProvider);
                  await ref.read(streakServiceProvider).setStreakForTest(userId, 7);
                  final prog = await ref.read(progressionServiceProvider).getProgression(userId);
                  await ref.read(badgeServiceProvider).checkAndAwardAllBadges(userId, prog!);
                });
              }),
            ]),
            const SizedBox(height: 20),

            // ── Section Mini-duels (M6) ─────────────────────────
            const _SectionTitle('Mini-duels (M6)'),
            _NavButton('⚔️ Naviguer vers /duel', () => context.push('/duel')),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                  child: _BigButton('+120 XP (Victoire)', AppColors.correctGreen, () async {
                await _runAction('Victoire duel', () async {
                  final res =
                      await ref.read(addXPProvider)(sourceType: 'duel_win', overrideAmount: 120);
                  if (context.mounted) {
                    XPGainOverlay.show(context, res.xpAdded);
                    for (final b in res.newBadges) {
                      BadgeAwardOverlay.show(context, b);
                    }
                  }
                });
              })),
              const SizedBox(width: 8),
              Expanded(
                  child: _BigButton('+25 XP (Défaite)', AppColors.wrongRed, () async {
                await _runAction('Défaite duel', () async {
                  final res =
                      await ref.read(addXPProvider)(sourceType: 'duel_loss', overrideAmount: 25);
                  if (context.mounted) {
                    XPGainOverlay.show(context, res.xpAdded);
                    for (final b in res.newBadges) {
                      BadgeAwardOverlay.show(context, b);
                    }
                  }
                });
              })),
            ]),
            const SizedBox(height: 8),
            _FullButton(
                'Forcer 3 victoires consécutives\n→ badge duel_win_3 attendu', Colors.purpleAccent,
                () async {
              await _runAction('Forcer 3 victoires duel', () async {
                final userId = ref.read(currentUserIdProvider);
                final db = await ref.read(databaseHelperProvider).database;
                await db.execute('''
                  UPDATE user_progression
                  SET duel_win_streak = 3, duel_wins = duel_wins + 3, duels_played = duels_played + 3
                  WHERE user_id = ?
                ''', [userId]);
                final prog = await ref.read(progressionServiceProvider).getProgression(userId);
                await ref.read(badgeServiceProvider).checkAndAwardAllBadges(userId, prog!);
              });
            }),
            const SizedBox(height: 20),

            // ── Simulateurs Jalons ───────────────────────────────
            const _SectionTitle('Simulateurs Jalons'),
            _FullButton('Mettre à jour tous les jalons\n(synchro avec état actuel)', Colors.teal,
                () async {
              await _runAction('Synchro jalons', () async {
                final userId = ref.read(currentUserIdProvider);
                final prog = await ref.read(progressionServiceProvider).getProgression(userId);
                if (prog != null) {
                  await ref
                      .read(milestoneServiceProvider)
                      .updateProgress(userId, 'streak_goal', prog.streakDays);
                  await ref
                      .read(milestoneServiceProvider)
                      .updateProgress(userId, 'xp_goal', prog.totalXpEver);
                  await ref
                      .read(milestoneServiceProvider)
                      .updateProgress(userId, 'lessons_goal', prog.lessonsCompleted);
                }
              });
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Widgets utilitaires du panel ──────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white54,
              letterSpacing: 0.5)),
    );
  }
}

class _StateCard extends StatelessWidget {
  final dynamic progression;
  const _StateCard({required this.progression});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgLevel2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
      ),
      child: Column(
        children: [
          _Row('Niveau', '${progression.currentLevel} — ${progression.levelTitle}'),
          _Row('XP total', '${progression.totalXpEver} XP'),
          _Row('XP niveau', '${progression.currentXP} / ${progression.xpForCurrentLevel}'),
          _Row('Progression', '${(progression.xpProgress * 100).toStringAsFixed(1)}%'),
          _Row('Streak', '${progression.streakDays} jours'),
          _Row('Streak record', '${progression.streakBest} jours'),
          _Row('Leçons', '${progression.lessonsCompleted}'),
        ],
      ),
    );
  }

  Widget _Row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: const TextStyle(fontSize: 11, color: Colors.white54)),
            Text(v,
                style: const TextStyle(
                    fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NavButton(this.label, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.bgLevel2,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10), width: 0.5),
          ),
          child: Row(
            children: [
              Expanded(
                  child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.white))),
              const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _FullButton(this.label, this.color, this.onTap);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.30), width: 0.5),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600, height: 1.4)),
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _BigButton(this.label, this.color, this.onTap);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 0.5),
        ),
        child: Center(
            child: Text(label,
                style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w700))),
      ),
    );
  }
}

class _TestAction {
  final String label;
  final Color color;
  final Future<void> Function() fn;
  const _TestAction(this.label, this.color, this.fn);
}

class _ActionGrid extends StatelessWidget {
  final List<_TestAction> actions;
  final void Function(_TestAction) onTap;
  final bool isLoading;
  const _ActionGrid({required this.actions, required this.onTap, required this.isLoading});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
      itemCount: actions.length,
      itemBuilder: (_, i) {
        final a = actions[i];
        return GestureDetector(
          onTap: isLoading ? null : () => onTap(a),
          child: Container(
            decoration: BoxDecoration(
              color: a.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: a.color.withValues(alpha: 0.30), width: 0.5),
            ),
            child: Center(
              child: Text(a.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11, color: a.color, fontWeight: FontWeight.w600, height: 1.4)),
            ),
          ),
        );
      },
    );
  }
}
