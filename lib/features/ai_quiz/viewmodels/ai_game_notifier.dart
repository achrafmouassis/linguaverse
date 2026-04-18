import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_quiz_notifier.dart';
import '../../auth/viewmodels/auth_provider.dart';

enum AnswerState { unanswered, correct, incorrect }

class AiGameState {
  final int currentQuestionIndex;
  final int score;
  final int timeLeft;
  final AnswerState answerState;
  final String? selectedAnswer;
  final bool isFinished;

  const AiGameState({
    this.currentQuestionIndex = 0,
    this.score = 0,
    this.timeLeft = 30,
    this.answerState = AnswerState.unanswered,
    this.selectedAnswer,
    this.isFinished = false,
  });

  AiGameState copyWith({
    int? currentQuestionIndex,
    int? score,
    int? timeLeft,
    AnswerState? answerState,
    String? selectedAnswer,
    bool? isFinished,
  }) {
    return AiGameState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      answerState: answerState ?? this.answerState,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class AiGameNotifier extends StateNotifier<AiGameState> {
  final Ref ref;
  Timer? _timer;

  AiGameNotifier(this.ref) : super(const AiGameState()) {
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      } else {
        _timer?.cancel();
        // Time is up -> incorrect
        if (state.answerState == AnswerState.unanswered) {
          state = state.copyWith(
            answerState: AnswerState.incorrect,
            timeLeft: 0,
          );
        }
      }
    });
  }

  void checkAnswer(String choice) {
    if (state.answerState != AnswerState.unanswered) return;
    
    _timer?.cancel();
    
    final questions = ref.read(aiQuizNotifierProvider).questions;
    if (state.currentQuestionIndex >= questions.length) return;
    
    final currentQuestion = questions[state.currentQuestionIndex];
    final isCorrect = choice == currentQuestion.answer;
    
    state = state.copyWith(
      selectedAnswer: choice,
      answerState: isCorrect ? AnswerState.correct : AnswerState.incorrect,
      score: isCorrect ? state.score + 1 : state.score,
    );
  }

  void nextQuestion() {
    final questions = ref.read(aiQuizNotifierProvider).questions;
    if (state.currentQuestionIndex < questions.length - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        answerState: AnswerState.unanswered,
        selectedAnswer: null,
        timeLeft: 30,
      );
      _startTimer();
    } else {
      _finishGame();
    }
  }

  void _finishGame() {
    state = state.copyWith(isFinished: true);
    
    // XP logic
    final questions = ref.read(aiQuizNotifierProvider).questions;
    int xpToAdd = state.score * 10;
    if (state.score == questions.length && questions.isNotEmpty) {
      xpToAdd += 50; // Perfect score bonus
    }
    
    if (xpToAdd > 0) {
      ref.read(authNotifierProvider.notifier).updateUserXP(xpToAdd);
    }
  }

  void resetGame() {
    state = const AiGameState();
    _startTimer();
  }
}

final aiGameNotifierProvider =
    StateNotifierProvider.autoDispose<AiGameNotifier, AiGameState>((ref) {
  return AiGameNotifier(ref);
});
