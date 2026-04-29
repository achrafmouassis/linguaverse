// lib/features/quiz/viewmodels/quiz_viewmodel.dart
//
// StateNotifier Riverpod qui gère l'intégralité du cycle de vie du quiz :
//   startQuiz → submitAnswer → nextQuestion → completeQuiz
// Le timer est géré via un Timer.periodic (30s par question).

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lessons/data/lesson_content_data.dart';
import '../../gamification/presentation/providers/gamification_providers.dart';
import '../models/question_model.dart';
import '../models/quiz_result_model.dart';
import '../repositories/quiz_repository.dart';
import 'question_generator.dart';
import 'quiz_state.dart';
import '../../lessons/viewmodels/user_progress_provider.dart';

// ─────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────

final quizRepositoryProvider = Provider<QuizRepository>((_) => QuizRepository());

final quizViewModelProvider = StateNotifierProvider<QuizViewModel, QuizState>(
  (ref) => QuizViewModel(ref),
);

// ─────────────────────────────────────────────
// ViewModel
// ─────────────────────────────────────────────

class QuizViewModel extends StateNotifier<QuizState> {
  final Ref _ref;
  QuizRepository get _repo => _ref.read(quizRepositoryProvider);

  Timer? _timerTick;
  static const int _questionDurationSeconds = 30;
  static const int _feedbackDurationMs = 1500;

  // Suivi du temps par question
  DateTime? _questionStartedAt;

  QuizViewModel(this._ref) : super(const QuizState());

  // ── 1. Démarrer le quiz ──────────────────────────────────────────────────

  Future<void> startQuiz({
    required String lessonId,
    required String categoryId,
    required String languageId,
    int? levelIndex,
    int? lessonIndex, // index (0,1,2) de la leçon dans son niveau
    bool isUnitFinal = false,
    int questionCount = 10,
  }) async {
    state = state.copyWith(
      phase: QuizPhase.loading,
      lessonId: lessonId,
      categoryId: categoryId,
      languageId: languageId,
      levelIndex: levelIndex,
      isUnitFinal: isUnitFinal,
    );

    try {
      List<LessonItem> items = LessonContentData.getItems(languageId, categoryId);

      if (items.isEmpty) {
        state = state.copyWith(
          phase: QuizPhase.error,
          errorMessage: 'Aucun contenu trouvé pour cette leçon.',
        );
        return;
      }

      // On utilise TOUT le contenu de la catégorie pour générer 10 questions variées.
      // Cela garantit toujours assez d'items, quels que soient levelIndex/lessonIndex.
      // Les items cyclent par quizz grâce au modulo dans QuestionGenerator.

      final questions = QuestionGenerator.generate(
        lessonItems: items,
        languageId: languageId,
        categoryId: categoryId,
        lessonId: lessonId,
        count: isUnitFinal ? 15 : questionCount,
      );

      if (questions.isEmpty) {
        state = state.copyWith(
          phase: QuizPhase.error,
          errorMessage: 'Impossible de générer les questions.',
        );
        return;
      }

      state = state.copyWith(
        phase: QuizPhase.answering,
        questions: questions,
        currentIndex: 0,
        answers: [],
        timerProgress: 1.0,
        startedAt: DateTime.now(),
        questionStartedAt: DateTime.now(),
        clearSelectedAnswer: true,
        clearMatchingOrder: true,
      );

      _startTimer();
    } catch (e) {
      state = state.copyWith(
        phase: QuizPhase.error,
        errorMessage: 'Erreur : $e',
      );
    }
  }

  // ── 2. Soumettre une réponse (QCM / TF / Listen / Fill) ──────────────────

  void submitAnswer(String answer) {
    if (state.phase != QuizPhase.answering) return;
    final q = state.currentQuestion;
    if (q == null) return;

    _stopTimer();

    final isCorrect = _evaluate(q, answer);
    final timeMs = _elapsedMs();

    final answered = AnsweredQuestion(
      question: q,
      userAnswer: answer,
      isCorrect: isCorrect,
      timeSpentMs: timeMs,
    );

    state = state.copyWith(
      phase: QuizPhase.feedback,
      selectedAnswer: answer,
      isCurrentCorrect: isCorrect,
      answers: [...state.answers, answered],
    );

    // Auto-avance après feedback
    Future.delayed(const Duration(milliseconds: _feedbackDurationMs), () {
      if (mounted) _advance();
    });
  }

  // ── 3. Soumettre le matching ──────────────────────────────────────────────

  void submitMatching(List<String> userOrder) {
    if (state.phase != QuizPhase.answering) return;
    final q = state.currentQuestion;
    if (q == null || q is! MatchingQuestion) return;

    _stopTimer();

    // Compare ordre utilisateur vs ordre correct
    final correctOrder = q.correctPairs.map((p) => p.translation).toList();
    final isCorrect = _listsEqual(userOrder, correctOrder);
    final timeMs = _elapsedMs();

    final answered = AnsweredQuestion(
      question: q,
      userAnswer: userOrder.join('|'),
      isCorrect: isCorrect,
      timeSpentMs: timeMs,
    );

    state = state.copyWith(
      phase: QuizPhase.feedback,
      selectedAnswer: isCorrect ? 'correct' : 'wrong',
      isCurrentCorrect: isCorrect,
      answers: [...state.answers, answered],
    );

    Future.delayed(const Duration(milliseconds: _feedbackDurationMs), () {
      if (mounted) _advance();
    });
  }

  // ── 4. Timeout (timer écoulé) ─────────────────────────────────────────────

  void _onTimeout() {
    if (state.phase != QuizPhase.answering) return;
    final q = state.currentQuestion;
    if (q == null) return;

    final answered = AnsweredQuestion(
      question: q,
      userAnswer: null, // null = timeout
      isCorrect: false,
      timeSpentMs: _questionDurationSeconds * 1000,
    );

    state = state.copyWith(
      phase: QuizPhase.feedback,
      selectedAnswer: '__timeout__',
      isCurrentCorrect: false,
      answers: [...state.answers, answered],
    );

    Future.delayed(const Duration(milliseconds: _feedbackDurationMs), () {
      if (mounted) _advance();
    });
  }

  // ── 5. Avancer ou terminer ────────────────────────────────────────────────

  void _advance() {
    if (state.isLastQuestion) {
      _completeQuiz();
    } else {
      state = state.copyWith(
        phase: QuizPhase.answering,
        currentIndex: state.currentIndex + 1,
        timerProgress: 1.0,
        questionStartedAt: DateTime.now(),
        clearSelectedAnswer: true,
        clearMatchingOrder: true,
      );
      _startTimer();
    }
  }

  // ── 6. Compléter le quiz ──────────────────────────────────────────────────

  Future<void> _completeQuiz() async {
    final correctAnswers =
        state.answers.where((a) => a.isCorrect).map((a) => a.question.sourceItem.term).toList();
    final incorrectAnswers =
        state.answers.where((a) => !a.isCorrect).map((a) => a.question.sourceItem.term).toList();

    final durationSec =
        state.startedAt != null ? DateTime.now().difference(state.startedAt!).inSeconds : 0;

    final isPerfect = state.correctCount == state.totalQuestions;
    final gamResult = await _ref.read(addXPProvider)(
      sourceType: isPerfect ? 'quiz_perfect' : 'quiz_pass',
      language: state.languageId,
    );

    final progService = _ref.read(progressionServiceProvider);
    final userId = _ref.read(currentUserIdProvider);
    await progService.incrementStat(userId, 'quizzes_completed');
    if (isPerfect) {
      await progService.incrementStat(userId, 'perfect_scores');
    }

    final result = QuizResult(
      id: _generateId(),
      lessonId: state.lessonId,
      categoryId: state.categoryId,
      languageId: state.languageId,
      completedAt: DateTime.now(),
      answers: state.answers,
      totalQuestions: state.totalQuestions,
      correctCount: state.correctCount,
      xpEarned: gamResult.xpAdded,
      durationSeconds: durationSec,
      wordsToReview: incorrectAnswers,
    );

    // Persist
    try {
      await _repo.saveResult(result);
      await _repo.processSrsAfterQuiz(
        correctWordTerms: correctAnswers,
        incorrectWordTerms: incorrectAnswers,
        categoryId: state.categoryId,
        languageId: state.languageId,
      );
    } catch (_) {
      // Non-bloquant : continue même si DB échoue (Web n'a pas sqflite)
    }

    state = state.copyWith(
      phase: QuizPhase.completed,
      result: result,
      gamificationResult: gamResult,
    );

    // DÉBLOCAGE : Si score ≥ 70%, le quiz de CETTE leçon est réussi → débloque la suivante
    final successRate = result.correctCount / result.totalQuestions;
    if (successRate >= 0.7 && state.lessonId.isNotEmpty) {
      _ref.read(userProgressProvider.notifier).markLessonQuizPassed(state.lessonId);

      // Si c'est un quiz final d'unité
      if (state.isUnitFinal && state.languageId.isNotEmpty && state.categoryId.isNotEmpty) {
        _ref.read(userProgressProvider.notifier).markUnitQuizPassed(
              languageId: state.languageId,
              categoryId: state.categoryId,
            );
      }
    }
  }

  // ── Timer management ──────────────────────────────────────────────────────

  void _startTimer() {
    _questionStartedAt = DateTime.now();
    _timerTick?.cancel();
    int elapsed = 0;

    _timerTick = Timer.periodic(const Duration(milliseconds: 500), (_) {
      elapsed += 500;
      final progress = 1.0 - (elapsed / (_questionDurationSeconds * 1000)).clamp(0.0, 1.0);
      if (mounted) {
        state = state.copyWith(timerProgress: progress);
      }
      if (elapsed >= _questionDurationSeconds * 1000) {
        _stopTimer();
        if (mounted) _onTimeout();
      }
    });
  }

  void _stopTimer() {
    _timerTick?.cancel();
    _timerTick = null;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool _evaluate(Question q, String answer) {
    if (q is MultipleChoiceQuestion) return answer == q.correctAnswer;
    if (q is TrueFalseQuestion) {
      return answer == q.correctAnswer.toString();
    }
    if (q is ListenAndChooseQuestion) return answer == q.correctAnswer;
    if (q is FillInBlankQuestion) return answer == q.correctAnswer;
    return false;
  }

  int _elapsedMs() {
    if (_questionStartedAt == null) return 0;
    return DateTime.now().difference(_questionStartedAt!).inMilliseconds;
  }

  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  String _generateId() => 'quiz_${DateTime.now().millisecondsSinceEpoch}';

  // ── Public helpers pour l'UI ──────────────────────────────────────────────

  void updateMatchingOrder(List<String> order) {
    state = state.copyWith(matchingUserOrder: order);
  }

  void resetQuiz() {
    _stopTimer();
    state = const QuizState();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
