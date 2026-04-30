import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../gamification/gamification_exports.dart';
import '../repositories/ai_quiz_service.dart';
import '../data/mock/m8_mock_data.dart';

// ── Service provider ──────────────────────────────────────────────
final aiQuizServiceProvider = Provider<AIQuizService>((ref) {
  return AIQuizService();
});

// ── State ─────────────────────────────────────────────────────────
class AIQuizState {
  final List<Map<String, dynamic>> questions;
  final int currentIndex;
  final int score;
  final int totalAnswered;
  final String? selectedAnswer;
  final bool isAnswered;
  final bool isLoading;
  final bool isCompleted;
  final int remainingQuota;
  final String? errorMessage;
  final int xpEarned;

  const AIQuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.totalAnswered = 0,
    this.selectedAnswer,
    this.isAnswered = false,
    this.isLoading = false,
    this.isCompleted = false,
    this.remainingQuota = 5,
    this.errorMessage,
    this.xpEarned = 0,
  });

  double get percentage =>
      questions.isEmpty ? 0 : score / questions.length;

  bool get isPerfect => questions.isNotEmpty && score == questions.length;
  bool get isPassed => percentage >= 0.70;

  String get grade {
    final p = percentage * 100;
    if (p == 100) return 'S';
    if (p >= 90) return 'A';
    if (p >= 80) return 'B';
    if (p >= 70) return 'C';
    if (p >= 60) return 'D';
    return 'F';
  }

  String get motivationalMessage {
    final rng = Random();
    if (isPerfect) {
      return M8MockData.perfectMessages[rng.nextInt(M8MockData.perfectMessages.length)];
    }
    if (isPassed) {
      return M8MockData.passMessages[rng.nextInt(M8MockData.passMessages.length)];
    }
    return M8MockData.failMessages[rng.nextInt(M8MockData.failMessages.length)];
  }

  Map<String, dynamic>? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  AIQuizState copyWith({
    List<Map<String, dynamic>>? questions,
    int? currentIndex,
    int? score,
    int? totalAnswered,
    String? selectedAnswer,
    bool? isAnswered,
    bool? isLoading,
    bool? isCompleted,
    int? remainingQuota,
    String? errorMessage,
    bool clearAnswer = false,
    bool clearError = false,
    int? xpEarned,
  }) =>
      AIQuizState(
        questions: questions ?? this.questions,
        currentIndex: currentIndex ?? this.currentIndex,
        score: score ?? this.score,
        totalAnswered: totalAnswered ?? this.totalAnswered,
        selectedAnswer: clearAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
        isAnswered: isAnswered ?? this.isAnswered,
        isLoading: isLoading ?? this.isLoading,
        isCompleted: isCompleted ?? this.isCompleted,
        remainingQuota: remainingQuota ?? this.remainingQuota,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        xpEarned: xpEarned ?? this.xpEarned,
      );
}

// ── Notifier ──────────────────────────────────────────────────────
class AIQuizNotifier extends StateNotifier<AIQuizState> {
  final Ref _ref;

  AIQuizNotifier(this._ref) : super(const AIQuizState());

  Future<void> loadQuiz({
    required String language,
    required int userLevel,
    List<String> recentTopics = const [],
  }) async {
    if (!mounted) return;
    state = const AIQuizState(isLoading: true);

    final service = _ref.read(aiQuizServiceProvider);
    try {
      final questions = await service.generateQuestions(
        language: language,
        userLevel: userLevel,
        recentTopics: recentTopics,
      );

      if (!mounted) return;
      state = AIQuizState(
        questions: questions,
        remainingQuota: service.remainingQuota,
      );
    } catch (e) {
      if (!mounted) return;
      state = AIQuizState(
        errorMessage: 'Erreur de chargement : $e',
        remainingQuota: service.remainingQuota,
      );
    }
  }

  void answerQuestion(String answer) {
    if (state.isAnswered || state.currentQuestion == null) return;
    final isCorrect = answer == state.currentQuestion!['correct'];

    state = state.copyWith(
      selectedAnswer: answer,
      isAnswered: true,
      score: isCorrect ? state.score + 1 : state.score,
      totalAnswered: state.totalAnswered + 1,
    );
  }

  Future<void> nextQuestion() async {
    if (!state.isAnswered) return;

    final next = state.currentIndex + 1;
    if (next >= state.questions.length) {
      await _finalizeQuiz();
    } else {
      state = state.copyWith(
        currentIndex: next,
        clearAnswer: true,
        isAnswered: false,
      );
    }
  }

  Future<void> _finalizeQuiz() async {
    if (!mounted) return;

    final xpType = state.isPerfect
        ? 'ai_perfect'
        : state.isPassed
            ? 'ai_pass'
            : 'ai_attempt';
    final xpAmount = M8MockData.xpRewards[xpType] ?? 30;

    try {
      await _ref.read(addXPProvider)(
        sourceType: 'daily_challenge',
        sourceName: 'IA Quiz — ${state.questions.length} questions',
        overrideAmount: xpAmount,
      );
    } catch (_) {
      // Non-bloquant
    }

    if (!mounted) return;
    state = state.copyWith(isCompleted: true, xpEarned: xpAmount);
  }
}

final aiQuizProvider =
    StateNotifierProvider.autoDispose<AIQuizNotifier, AIQuizState>((ref) {
  return AIQuizNotifier(ref);
});
