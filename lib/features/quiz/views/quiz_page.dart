import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../models/question_model.dart';
import '../viewmodels/quiz_state.dart';
import '../viewmodels/quiz_viewmodel.dart';
import 'quiz_result_page.dart';
import 'widgets/feedback_overlay.dart';
import 'widgets/question_cards.dart';
import 'widgets/quiz_progress_bar.dart';

class QuizPage extends ConsumerStatefulWidget {
  final String lessonId;
  final String categoryId;
  final String languageId;
  final String lessonTitle;
  final int? levelIndex;
  final int? lessonIndex;
  final bool isUnitFinal;

  const QuizPage({
    super.key,
    required this.lessonId,
    required this.categoryId,
    required this.languageId,
    required this.lessonTitle,
    this.levelIndex,
    this.lessonIndex,
    this.isUnitFinal = false,
  });

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage>
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

    // Démarrer le quiz au prochain frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizViewModelProvider.notifier).startQuiz(
            lessonId:    widget.lessonId,
            categoryId:  widget.categoryId,
            languageId:  widget.languageId,
            levelIndex:  widget.levelIndex,
            lessonIndex: widget.lessonIndex,
            isUnitFinal: widget.isUnitFinal,
      );
    });
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  void _triggerSlide() {
    _slideCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizViewModelProvider);
    final vm = ref.read(quizViewModelProvider.notifier);

    // Naviguer vers résultats quand terminé
    ref.listen<QuizState>(quizViewModelProvider, (prev, next) {
      if (prev?.phase != QuizPhase.completed &&
          next.phase == QuizPhase.completed &&
          next.result != null) {
        context.pushReplacementNamed(
          'quiz_result',
          extra: {
            'result': next.result!,
            'gamificationResult': next.gamificationResult,
            'lessonTitle': widget.lessonTitle,
            'languageId': widget.languageId,
            'categoryId': widget.categoryId,
            'onRetry': () {
              context.pushReplacementNamed(
                'quiz_page',
                extra: {
                  'lessonId':    widget.lessonId,
                  'categoryId':  widget.categoryId,
                  'languageId':  widget.languageId,
                  'levelIndex':  widget.levelIndex,
                  'lessonIndex': widget.lessonIndex,
                  'isUnitFinal': widget.isUnitFinal,
                  'lessonTitle': widget.lessonTitle,
                },
              );
            },
          },
        );
      }
      
      // Déclenche animation slide à chaque nouvelle question
      // (On l'active aussi quand on passe du chargement à la 1re question)
      final hasTransitionedToAnswering = 
          prev?.phase == QuizPhase.loading && next.phase == QuizPhase.answering;
      final hasChangedQuestion = 
          prev?.currentIndex != next.currentIndex && next.phase == QuizPhase.answering;

      if (hasTransitionedToAnswering || hasChangedQuestion) {
        _triggerSlide();
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top bar ───
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showExitDialog(context, vm),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.12),
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
                            value: state.totalQuestions > 0 ? (state.currentIndex) / state.totalQuestions : 0.0,
                            minHeight: 8,
                            backgroundColor: Colors.grey.withOpacity(0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Quiz · ${widget.lessonTitle}',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Quick Timer Badge integrated directly into the Top Bar
                            _buildTimerBadge(state.timerProgress),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Timer line indicator just below for visual flair
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: state.timerProgress),
              duration: const Duration(milliseconds: 300),
              builder: (_, value, __) {
                Color c = value > 0.5 ? AppColors.correctGreen : (value > 0.25 ? AppColors.streakOrange : AppColors.wrongRed);
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 2,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(c),
                );
              },
            ),

            // ─── Content ───
            Expanded(child: _buildBody(state, vm)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerBadge(double progress) {
    final secs = (progress * 30).ceil();
    Color color = progress > 0.5 ? AppColors.correctGreen : (progress > 0.25 ? AppColors.streakOrange : AppColors.wrongRed);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            '${secs}s',
            style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(QuizState state, QuizViewModel vm) {
    switch (state.phase) {
      case QuizPhase.loading:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Préparation du quiz…'),
            ],
          ),
        );

      case QuizPhase.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64,
                    color: AppColors.wrongRed),
                const SizedBox(height: 16),
                Text(state.errorMessage ?? 'Erreur inconnue',
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Retour')),
              ],
            ),
          ),
        );

      case QuizPhase.idle:
        return const SizedBox.shrink();

      case QuizPhase.completed:
        return const Center(child: CircularProgressIndicator());

      case QuizPhase.answering:
      case QuizPhase.feedback:
        return _buildQuizContent(state, vm);
    }
  }

  Widget _buildQuizContent(QuizState state, QuizViewModel vm) {
    final q = state.currentQuestion;
    if (q == null) return const SizedBox.shrink();

    final showFeedback = state.phase == QuizPhase.feedback;
    final isTimeout = state.selectedAnswer == '__timeout__';

    return Column(
      children: [
        // Question card (animated slide-in)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16, bottom: 20),
            child: Column(
              children: [
                // Slide animation on new question
                SlideTransition(
                  position: _slideAnim,
                  child: _buildQuestionCard(q, state, vm),
                ),

                // Feedback overlay
                if (showFeedback) ...[
                  const SizedBox(height: 12),
                  FeedbackOverlay(
                    isCorrect: state.isCurrentCorrect ?? false,
                    isTimeout: isTimeout,
                    explanation: _getExplanation(q),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Question q, QuizState state, QuizViewModel vm) {
    final showFeedback = state.phase == QuizPhase.feedback;

    if (q is MultipleChoiceQuestion) {
      return MultipleChoiceCard(
        question: q,
        selectedAnswer: state.selectedAnswer,
        showFeedback: showFeedback,
        onAnswer: vm.submitAnswer,
      );
    }
    if (q is TrueFalseQuestion) {
      return TrueFalseCard(
        question: q,
        selectedAnswer: state.selectedAnswer,
        showFeedback: showFeedback,
        onAnswer: vm.submitAnswer,
      );
    }
    if (q is ListenAndChooseQuestion) {
      return ListenAndChooseCard(
        question: q,
        selectedAnswer: state.selectedAnswer,
        showFeedback: showFeedback,
        onAnswer: vm.submitAnswer,
      );
    }
    if (q is FillInBlankQuestion) {
      return FillInBlankCard(
        question: q,
        selectedAnswer: state.selectedAnswer,
        showFeedback: showFeedback,
        onAnswer: vm.submitAnswer,
      );
    }
    if (q is MatchingQuestion) {
      return MatchingCard(
        question: q,
        showFeedback: showFeedback,
        onSubmit: vm.submitMatching,
      );
    }
    return const SizedBox.shrink();
  }

  String? _getExplanation(Question q) {
    if (q is MultipleChoiceQuestion) return q.explanation;
    if (q is TrueFalseQuestion) return q.explanation;
    return null;
  }

  Future<void> _showExitDialog(
      BuildContext context, QuizViewModel vm) async {
    final exit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quitter le quiz ?'),
        content:
            const Text('Ta progression sera perdue. Tu veux vraiment partir ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Continuer')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Quitter',
                  style: TextStyle(color: AppColors.wrongRed))),
        ],
      ),
    );
    if (exit == true && context.mounted) {
      vm.resetQuiz();
      Navigator.pop(context);
    }
  }
}
