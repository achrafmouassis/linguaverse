import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/constants.dart';
import '../viewmodels/ai_game_notifier.dart';
import '../viewmodels/ai_quiz_notifier.dart';

class AiQuizGamePage extends ConsumerStatefulWidget {
  const AiQuizGamePage({super.key});

  @override
  ConsumerState<AiQuizGamePage> createState() => _AiQuizGamePageState();
}

class _AiQuizGamePageState extends ConsumerState<AiQuizGamePage> {
  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(aiGameNotifierProvider);
    final quizState = ref.watch(aiQuizNotifierProvider);
    final questions = quizState.questions;

    ref.listen<AiGameState>(aiGameNotifierProvider, (previous, next) {
      if (next.isFinished && (previous?.isFinished != true)) {
        // Navigate to results
        int xpToAdd = next.score * 10;
        if (next.score == questions.length && questions.isNotEmpty) {
          xpToAdd += 50;
        }
        context.go(AppRoutes.aiQuizResult, extra: {
          'score': next.score,
          'total': questions.length,
          'xp': xpToAdd,
        });
      }
    });

    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: Text('Aucune question')));
    }

    final currentQuestion = questions[gameState.currentQuestionIndex];
    
    // Force dark theme as requested
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF1E1E1E),
          primary: AppColors.primary,
        ),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFF121212),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E1E),
                      title: const Text('Quitter le quiz ?', style: TextStyle(color: Colors.white)),
                      content: const Text('Votre progression sera perdue.', style: TextStyle(color: Colors.white70)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Annuler', style: TextStyle(color: Colors.white54)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            context.pop();
                          },
                          child: const Text('Quitter', style: TextStyle(color: AppColors.wrongRed)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              title: Text(
                'Question ${gameState.currentQuestionIndex + 1} / ${questions.length}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Timer bar
                    _buildTimerBar(gameState.timeLeft),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    // Question
                    Text(
                      currentQuestion.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    // Options
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentQuestion.choices.length,
                        itemBuilder: (context, index) {
                          final choice = currentQuestion.choices[index];
                          return _buildChoiceButton(
                            choice: choice,
                            gameState: gameState,
                            correctAnswer: currentQuestion.answer,
                          );
                        },
                      ),
                    ),
                    
                    // Explanation & Next button
                    if (gameState.answerState != AnswerState.unanswered)
                      _buildFeedbackSection(gameState, currentQuestion.explanation),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildTimerBar(int timeLeft) {
    final progress = timeLeft / 30.0;
    final isDanger = timeLeft < 5;
    
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                width: constraints.maxWidth * progress,
                decoration: BoxDecoration(
                  color: isDanger ? AppColors.wrongRed : AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChoiceButton({
    required String choice,
    required AiGameState gameState,
    required String correctAnswer,
  }) {
    final isSelected = gameState.selectedAnswer == choice;
    final isCorrectAnswer = choice == correctAnswer;
    
    Color backgroundColor = const Color(0xFF1E1E1E);
    Color borderColor = Colors.white.withOpacity(0.1);
    
    if (gameState.answerState != AnswerState.unanswered) {
      if (isCorrectAnswer) {
        backgroundColor = AppColors.correctGreen.withOpacity(0.2);
        borderColor = AppColors.correctGreen;
      } else if (isSelected && !isCorrectAnswer) {
        backgroundColor = AppColors.wrongRed.withOpacity(0.2);
        borderColor = AppColors.wrongRed;
      }
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: gameState.answerState == AnswerState.unanswered
            ? () {
                HapticFeedback.lightImpact();
                ref.read(aiGameNotifierProvider.notifier).checkAnswer(choice);
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  choice,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (gameState.answerState != AnswerState.unanswered && isCorrectAnswer)
                const Icon(Icons.check_circle_rounded, color: AppColors.correctGreen),
              if (gameState.answerState != AnswerState.unanswered && isSelected && !isCorrectAnswer)
                const Icon(Icons.cancel_rounded, color: AppColors.wrongRed),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(AiGameState gameState, String explanation) {
    final isCorrect = gameState.answerState == AnswerState.correct;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isCorrect 
                ? AppColors.correctGreen.withOpacity(0.1)
                : AppColors.wrongRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCorrect 
                  ? AppColors.correctGreen.withOpacity(0.3)
                  : AppColors.wrongRed.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: isCorrect ? AppColors.correctGreen : AppColors.wrongRed,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    isCorrect ? 'Excellente réponse !' : 'Dommage !',
                    style: TextStyle(
                      color: isCorrect ? AppColors.correctGreen : AppColors.wrongRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              if (explanation.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  explanation,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ElevatedButton(
          onPressed: () {
            ref.read(aiGameNotifierProvider.notifier).nextQuestion();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Suivant',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
