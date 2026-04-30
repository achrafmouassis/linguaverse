import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:linguaverse/shared/theme/app_colors.dart';
import 'package:linguaverse/shared/utils/constants.dart';
import 'package:linguaverse/features/gamification/gamification_exports.dart';
import 'package:linguaverse/features/duel/presentation/providers/duel_providers.dart';
import 'package:linguaverse/features/duel/data/services/duel_service.dart';
import 'package:linguaverse/features/gamification/presentation/widgets/xp_gain_overlay.dart';

// ════════════════════════════════════════════════════════════════
// PAGE RESULTAT — Fin du duel
// ════════════════════════════════════════════════════════════════
class DuelResultPage extends ConsumerStatefulWidget {
  const DuelResultPage({super.key});

  @override
  ConsumerState<DuelResultPage> createState() => _DuelResultPageState();
}

class _DuelResultPageState extends ConsumerState<DuelResultPage> with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.elasticOut));
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entryCtrl.forward();
      // Afficher XP Overlay si XP gagné
      final arena = ref.read(duelArenaProvider);
      final xpResult = arena.result?.xpResult;
      if (xpResult != null && xpResult.xpAdded > 0) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) XPGainOverlay.show(context, xpResult.xpAdded);
        });
      }
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arena = ref.watch(duelArenaProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (arena.result == null || arena.session == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.bgScaffold : AppColors.background,
        body: const Center(child: Text('Aucun résultat !')),
      );
    }

    final res = arena.result!;
    final session = arena.session!;
    final opp = arena.opponent!;

    Color mainColor;
    String headerText;
    String subText;
    IconData icon;

    if (res.won) {
      mainColor = AppColors.correctGreen;
      headerText = 'VICTOIRE !';
      subText =
          res.isPerfect ? 'Score parfait ! Impressionnant !' : 'Bravo, tu as dominé le duel !';
      icon = Icons.emoji_events_rounded;
    } else if (res.isDraw) {
      mainColor = AppColors.streakOrange;
      headerText = 'ÉGALITÉ !';
      subText = 'Un affrontement digne de ce nom.';
      icon = Icons.handshake_rounded;
    } else {
      mainColor = AppColors.wrongRed;
      headerText = 'DÉFAITE';
      subText = 'Ne te décourage pas, la prochaine fois sera la bonne !';
      icon = Icons.thumb_down_alt_rounded;
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgScaffold : const Color(0xFFF4F6FA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxl),
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: mainColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 80, color: mainColor),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                headerText,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: mainColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                subText,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // SCORE CARDS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ScoreBlock(
                    name: ref.read(currentUserNameProvider).split(' ').first,
                    score: session.player1Score,
                    total: session.questionCount,
                    color: res.won
                        ? AppColors.correctGreen
                        : (res.isDraw ? AppColors.streakOrange : AppColors.wrongRed),
                    isDark: isDark,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Text('VS',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white24 : Colors.black26,
                        )),
                  ),
                  _ScoreBlock(
                    name: opp.name.split(' ').first,
                    score: session.player2Score,
                    total: session.questionCount,
                    color: !res.won && !res.isDraw
                        ? AppColors.correctGreen
                        : (res.isDraw ? AppColors.streakOrange : AppColors.wrongRed),
                    isDark: isDark,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),
              // RECAPPING REWARDS
              _buildRewardsBox(res, isDark),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    if (res.newBadges.isNotEmpty) _buildBadgesRow(res.newBadges, isDark),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md)),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          context.go('/duel');
                        },
                        child: const Text('REJOUER',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1)),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        context.go('/');
                      },
                      child:
                          const Text('Retour à l\'accueil', style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardsBox(DuelFinalizationResult res, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgLevel2 : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.xpGold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          const Text('RÉCOMPENSES',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.xpGold,
                  letterSpacing: 1)),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '+${res.session.xpEarned} XP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          if (res.isPerfect)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.sm),
              child: Text('Bonus Score Parfait appliqué !',
                  style: TextStyle(fontSize: 12, color: AppColors.correctGreen)),
            ),
        ],
      ),
    );
  }

  Widget _buildBadgesRow(List<BadgeModel> badges, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.streakOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.streakOrange.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.military_tech_rounded, color: AppColors.streakOrange),
          const SizedBox(width: AppSpacing.sm),
          Text('${badges.length} Nouveau(x) Badge(s) !',
              style: const TextStyle(color: AppColors.streakOrange, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ScoreBlock extends StatelessWidget {
  final String name;
  final int score;
  final int total;
  final Color color;
  final bool isDark;

  const _ScoreBlock({
    required this.name,
    required this.score,
    required this.total,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54)),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Text(
            '$score / $total',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
