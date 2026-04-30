import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/linguaverse_app_bar.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/utils/constants.dart';
import '../../gamification/gamification_exports.dart';
import '../viewmodels/ai_quiz_viewmodel.dart';

class AIQuizEntryPage extends ConsumerWidget {
  const AIQuizEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(aiQuizProvider);
    final progression = ref.watch(userProgressionProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userLevel = progression.whenOrNull(data: (p) => p?.currentLevel) ?? 1;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.bgScaffold,
      appBar: const LinguaVerseAppBar(
        titleText: 'Quiz IA',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const SizedBox(height: 24),

              // ── Hero section ──
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('🧠', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 12),
                    const Text(
                      'Quiz Personnalisé IA',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Claude génère des questions adaptées\nà ton niveau ($userLevel) et tes leçons récentes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt_rounded, color: Colors.amber, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '${aiState.remainingQuota} générations restantes aujourd\'hui',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── XP Rewards ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.outline,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Récompenses XP',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    const _RewardRow(emoji: '🏆', label: 'Score Parfait (100%)', xp: '120 XP'),
                    const _RewardRow(emoji: '✅', label: 'Réussi (≥ 70%)', xp: '80 XP'),
                    const _RewardRow(emoji: '💪', label: 'Tenté (< 70%)', xp: '30 XP'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── CTA Button ──
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: aiState.isLoading
                      ? null
                      : () async {
                          await ref.read(aiQuizProvider.notifier).loadQuiz(
                                language: 'Arabe',
                                userLevel: userLevel,
                              );
                          if (context.mounted) {
                            final updatedState = ref.read(aiQuizProvider);
                            if (updatedState.questions.isNotEmpty) {
                              context.pushNamed('aiQuiz');
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
                  child: aiState.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Générer mon Quiz IA',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String xp;

  const _RewardRow({required this.emoji, required this.label, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              xp,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
