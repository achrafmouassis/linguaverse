import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../viewmodels/ai_quiz_viewmodel.dart';

class AIQuizPage extends ConsumerStatefulWidget {
  const AIQuizPage({super.key});

  @override
  ConsumerState<AIQuizPage> createState() => _AIQuizPageState();
}

class _AIQuizPageState extends ConsumerState<AIQuizPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideCtrl;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _slideAnim = Tween<Offset>(
      begin: const Offset(1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiQuizProvider);
    final vm = ref.read(aiQuizProvider.notifier);

    // Navigation to results when quiz is completed
    ref.listen<AIQuizState>(aiQuizProvider, (prev, next) {
      if (prev?.isCompleted != true && next.isCompleted) {
        context.pushReplacementNamed('aiQuizResult');
      }
      if (prev?.currentIndex != next.currentIndex && !next.isCompleted) {
        _slideCtrl.forward(from: 0);
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final question = state.currentQuestion;

    if (question == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showExitDialog(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.close_rounded, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: state.questions.isNotEmpty
                                ? (state.currentIndex + 1) /
                                    state.questions.length
                                : 0,
                            minHeight: 8,
                            backgroundColor: Colors.grey.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF7C3AED)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Question ${state.currentIndex + 1} / ${state.questions.length}',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Question content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Question prompt
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
                              color: const Color(0xFF7C3AED)
                                  .withValues(alpha: 0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                (question['type'] as String? ?? 'qcm')
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              question['question'] as String? ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Choices
                      ...(question['choices'] as List<dynamic>? ?? [])
                          .map((choice) {
                        final label = choice.toString();
                        final isSelected = state.selectedAnswer == label;
                        final isCorrect = label == question['correct'];

                        Color bg = isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.white;
                        Color border = AppColors.outline;

                        if (state.isAnswered) {
                          if (isCorrect) {
                            bg = const Color(0xFFECFDF5);
                            border = AppColors.correctGreen;
                          } else if (isSelected && !isCorrect) {
                            bg = const Color(0xFFFEF2F2);
                            border = AppColors.wrongRed;
                          }
                        } else if (isSelected) {
                          bg = AppColors.primaryLight;
                          border = AppColors.primary;
                        }

                        return GestureDetector(
                          onTap: state.isAnswered
                              ? null
                              : () => vm.answerQuestion(label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: border, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (state.isAnswered && isCorrect)
                                  const Icon(Icons.check_circle_rounded,
                                      color: AppColors.correctGreen, size: 20),
                                if (state.isAnswered &&
                                    isSelected &&
                                    !isCorrect)
                                  const Icon(Icons.cancel_rounded,
                                      color: AppColors.wrongRed, size: 20),
                              ],
                            ),
                          ),
                        );
                      }),

                      // Explanation after answering
                      if (state.isAnswered &&
                          question['explanation'] != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lightbulb_outline_rounded,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  question['explanation'] as String,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // ── Next button ──
            if (state.isAnswered)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => vm.nextQuestion(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      state.currentIndex + 1 >= state.questions.length
                          ? 'Voir les résultats'
                          : 'Question suivante →',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context) async {
    final exit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quitter le quiz IA ?'),
        content: const Text('Ta progression sera perdue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuer'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Quitter',
                style: TextStyle(color: AppColors.wrongRed)),
          ),
        ],
      ),
    );
    if (exit == true && context.mounted) {
      context.pop();
    }
  }
}
