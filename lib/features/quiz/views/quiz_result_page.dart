// lib/features/quiz/views/quiz_result_page.dart
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../gamification/data/services/progression_service.dart';
import '../../gamification/data/models/badge_model.dart';
import '../models/quiz_result_model.dart';

class QuizResultPage extends StatefulWidget {
  final QuizResult result;
  final XpGainResult? gamificationResult;
  final String lessonTitle;
  final VoidCallback onRetry;
  final VoidCallback onContinue;

  const QuizResultPage({
    super.key,
    required this.result,
    required this.gamificationResult,
    required this.lessonTitle,
    required this.onRetry,
    required this.onContinue,
  });

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> with TickerProviderStateMixin {
  late final AnimationController _scoreCtrl;
  late final AnimationController _badgeCtrl;
  late final Animation<double> _scoreFade;
  late final Animation<double> _scoreScale;
  late final Animation<double> _badgeFade;

  @override
  void initState() {
    super.initState();

    _scoreCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _badgeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _scoreFade = CurvedAnimation(parent: _scoreCtrl, curve: Curves.easeOut);
    _scoreScale = Tween<double>(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _scoreCtrl, curve: Curves.elasticOut));
    _badgeFade = CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeIn);

    _scoreCtrl.forward().then((_) => _badgeCtrl.forward());
  }

  @override
  void dispose() {
    _scoreCtrl.dispose();
    _badgeCtrl.dispose();
    super.dispose();
  }

  Color get _gradeColor {
    final g = widget.result.grade;
    switch (g) {
      case 'S':
        return const Color(0xFFF59E0B);
      case 'A':
        return AppColors.correctGreen;
      case 'B':
        return AppColors.secondary;
      case 'C':
        return AppColors.streakOrange;
      default:
        return AppColors.wrongRed;
    }
  }

  String get _gradeEmoji {
    final g = widget.result.grade;
    switch (g) {
      case 'S':
        return '🏆';
      case 'A':
        return '⭐';
      case 'B':
        return '👍';
      case 'C':
        return '📖';
      default:
        return '💪';
    }
  }

  String get _gradeMessage {
    final s = widget.result.scorePercent;
    if (s == 100) return 'Score parfait ! Incroyable !';
    if (s >= 80) return 'Excellent travail !';
    if (s >= 60) return 'Bien joué, continue !';
    if (s >= 40) return 'Tu progresses, courage !';
    return 'Revise ces mots et réessaie !';
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final gam = widget.gamificationResult;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Score central ──
              FadeTransition(
                opacity: _scoreFade,
                child: ScaleTransition(
                  scale: _scoreScale,
                  child: _ScoreCircle(
                    score: result.scorePercent,
                    grade: result.grade,
                    gradeEmoji: _gradeEmoji,
                    color: _gradeColor,
                    message: _gradeMessage,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Stats row ──
              _StatsRow(result: result),

              const SizedBox(height: 20),

              // ── XP earned ──
              if (gam != null)
                FadeTransition(
                  opacity: _badgeFade,
                  child: _XpBanner(
                      xp: gam.xpAdded, leveledUp: gam.levelUp != null, newLevel: gam.newLevel),
                ),

              const SizedBox(height: 16),

              // ── New badges ──
              if (gam != null && gam.newBadges.isNotEmpty)
                FadeTransition(
                  opacity: _badgeFade,
                  child: _BadgeSection(badges: gam.newBadges),
                ),

              const SizedBox(height: 16),

              // ── Mots à réviser ──
              if (result.wordsToReview.isNotEmpty) _ReviewWordsSection(words: result.wordsToReview),

              const SizedBox(height: 32),

              _ActionRow(
                onRetry: widget.onRetry,
                onHome: widget.onContinue,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _ScoreCircle extends StatelessWidget {
  final int score;
  final String grade;
  final String gradeEmoji;
  final Color color;
  final String message;

  const _ScoreCircle({
    required this.score,
    required this.grade,
    required this.gradeEmoji,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.03)],
            ),
            border: Border.all(color: color, width: 3),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 32, spreadRadius: 4),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(gradeEmoji, style: const TextStyle(fontSize: 36)),
              Text(
                '$score%',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              Text(
                'Grade $grade',
                style: TextStyle(color: color, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final QuizResult result;
  const _StatsRow({required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
            icon: Icons.check_circle_rounded,
            color: AppColors.correctGreen,
            value: '${result.correctCount}',
            label: 'Corrects'),
        const SizedBox(width: 10),
        _StatCard(
            icon: Icons.cancel_rounded,
            color: AppColors.wrongRed,
            value: '${result.totalQuestions - result.correctCount}',
            label: 'Faux'),
        const SizedBox(width: 10),
        _StatCard(
            icon: Icons.timer_rounded,
            color: AppColors.secondary,
            value: _fmt(result.durationSeconds),
            label: 'Durée'),
      ],
    );
  }

  String _fmt(int s) => s >= 60 ? '${s ~/ 60}m${s % 60}s' : '${s}s';
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 20)),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _XpBanner extends StatelessWidget {
  final int xp;
  final bool leveledUp;
  final int newLevel;

  const _XpBanner({required this.xp, required this.leveledUp, required this.newLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.xpGold.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const Text('⚡', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('+$xp XP gagnés !',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                if (leveledUp)
                  Text('🎉 Niveau $newLevel débloqué !',
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeSection extends StatelessWidget {
  final List<BadgeModel> badges;
  const _BadgeSection({required this.badges});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nouveaux badges 🏅', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: badges
              .map((b) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(b.iconEmoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.name,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            Text(b.description,
                                style:
                                    const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _ReviewWordsSection extends StatelessWidget {
  final List<String> words;
  const _ReviewWordsSection({required this.words});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('🔁', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text('Mots à réviser (SRS)', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.wrongRed.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.wrongRed.withValues(alpha: 0.2)),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: words
                .map((w) => Chip(
                      label: Text(w,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      backgroundColor: AppColors.wrongRed.withValues(alpha: 0.1),
                      side: BorderSide(color: AppColors.wrongRed.withValues(alpha: 0.3)),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ces mots seront automatiquement planifiés pour révision.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onHome;

  const _ActionRow({required this.onRetry, required this.onHome});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Rejouer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onHome,
          icon: const Icon(Icons.home_rounded),
          label: const Text('Retour aux cours',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}
