// lib/features/quiz/viewmodels/quiz_state.dart
import '../models/question_model.dart';
import '../models/quiz_result_model.dart';
import '../../gamification/data/services/progression_service.dart';

// ─────────────────────────────────────────────
// États possibles du quiz (state machine)
// ─────────────────────────────────────────────
enum QuizPhase {
  idle, // Avant démarrage
  loading, // Génération des questions
  answering, // Question en cours
  feedback, // Affichage feedback immédiat
  completed, // Quiz terminé → résumé
  error, // Erreur
}

// ─────────────────────────────────────────────
// État immutable du quiz (géré par StateNotifier)
// ─────────────────────────────────────────────
class QuizState {
  final QuizPhase phase;
  final List<Question> questions;
  final int currentIndex;

  // Réponse de l'utilisateur sur la question courante
  final String? selectedAnswer;
  final bool? isCurrentCorrect;

  // Matching spécifique : ordre des traductions côté droit
  final List<String>? matchingUserOrder;

  // Réponses validées
  final List<AnsweredQuestion> answers;

  // Timer (0.0 → 1.0, décroissant)
  final double timerProgress;

  // Résultat final
  final QuizResult? result;
  final XpGainResult? gamificationResult;

  final String? errorMessage;

  // Métadonnées de session
  final String lessonId;
  final String categoryId;
  final String languageId;
  final DateTime? startedAt;
  final DateTime? questionStartedAt;
  final int? levelIndex;
  final bool isUnitFinal;

  const QuizState({
    this.phase = QuizPhase.idle,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedAnswer,
    this.isCurrentCorrect,
    this.matchingUserOrder,
    this.answers = const [],
    this.timerProgress = 1.0,
    this.result,
    this.gamificationResult,
    this.errorMessage,
    this.lessonId = '',
    this.categoryId = '',
    this.languageId = '',
    this.startedAt,
    this.questionStartedAt,
    this.levelIndex,
    this.isUnitFinal = false,
  });

  Question? get currentQuestion =>
      questions.isEmpty || currentIndex >= questions.length ? null : questions[currentIndex];

  int get totalQuestions => questions.length;
  bool get isLastQuestion => currentIndex >= questions.length - 1;
  int get correctCount => answers.where((a) => a.isCorrect).length;

  QuizState copyWith({
    QuizPhase? phase,
    List<Question>? questions,
    int? currentIndex,
    String? selectedAnswer,
    bool? isCurrentCorrect,
    List<String>? matchingUserOrder,
    List<AnsweredQuestion>? answers,
    double? timerProgress,
    QuizResult? result,
    XpGainResult? gamificationResult,
    String? errorMessage,
    String? lessonId,
    String? categoryId,
    String? languageId,
    DateTime? startedAt,
    DateTime? questionStartedAt,
    bool clearSelectedAnswer = false,
    bool clearMatchingOrder = false,
    int? levelIndex,
    bool? isUnitFinal,
  }) =>
      QuizState(
        phase: phase ?? this.phase,
        questions: questions ?? this.questions,
        currentIndex: currentIndex ?? this.currentIndex,
        selectedAnswer: clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
        isCurrentCorrect: clearSelectedAnswer ? null : (isCurrentCorrect ?? this.isCurrentCorrect),
        matchingUserOrder:
            clearMatchingOrder ? null : (matchingUserOrder ?? this.matchingUserOrder),
        answers: answers ?? this.answers,
        timerProgress: timerProgress ?? this.timerProgress,
        result: result ?? this.result,
        gamificationResult: gamificationResult ?? this.gamificationResult,
        errorMessage: errorMessage ?? this.errorMessage,
        lessonId: lessonId ?? this.lessonId,
        categoryId: categoryId ?? this.categoryId,
        languageId: languageId ?? this.languageId,
        startedAt: startedAt ?? this.startedAt,
        questionStartedAt: questionStartedAt ?? this.questionStartedAt,
        levelIndex: levelIndex ?? this.levelIndex,
        isUnitFinal: isUnitFinal ?? this.isUnitFinal,
      );
}
