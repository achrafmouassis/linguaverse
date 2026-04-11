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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.lessonTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => _showExitDialog(context, vm),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildBody(state, vm),
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
        // Header: progress + timer
        QuizProgressBar(
          current: state.currentIndex + 1,
          total: state.totalQuestions,
          timerProgress: state.timerProgress,
        ),

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
