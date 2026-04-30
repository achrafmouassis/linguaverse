import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/utils/constants.dart';
import '../viewmodels/ai_quiz_viewmodel.dart';

class AIQuizResultPage extends ConsumerWidget {
  const AIQuizResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiQuizProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scorePercent = (state.percentage * 100).round();
    final isPassed = state.isPassed;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.deepSpaceBlue : AppColors.bgScaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // ── Score circle ──
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isPassed
                        ? [AppColors.correctGreen, AppColors.correctGreen.withValues(alpha: 0.8)]
                        : [AppColors.wrongRed, AppColors.wrongRed.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isPassed
                              ? AppColors.correctGreen
                              : AppColors.wrongRed)
                          .withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$scorePercent%',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Grade ${state.grade}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── XP Earned ──
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.tertiary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded,
                        color: AppColors.tertiary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '+${state.xpEarned} XP',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Motivational message ──
              Text(
                state.motivationalMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),

              // ── Score details ──
              Text(
                '${state.score} / ${state.questions.length} bonnes réponses',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? Colors.white70
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // ── Buttons ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(aiQuizProvider);
                    context.pushReplacementNamed('aiQuizEntry');
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text(
                    'Nouveau Quiz IA',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tertiary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/gamification'),
                  icon: const Icon(Icons.emoji_events_rounded, size: 20),
                  label: const Text(
                    'Voir ma progression',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.tertiary,
                    side: const BorderSide(color: AppColors.tertiary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Retour à l\'accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
