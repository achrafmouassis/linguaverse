import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../gamification/presentation/providers/gamification_providers.dart';
import '../../data/mock/m6_mock_data.dart';
import '../../data/models/duel_question_model.dart';
import '../../data/models/duel_opponent_model.dart';
import '../../data/models/duel_session_model.dart';
import '../../data/services/duel_service.dart';

// ════════════════════════════════════════════════════════════════
// PROVIDERS DE DÉPENDANCES
// ════════════════════════════════════════════════════════════════
final duelServiceProvider = Provider<DuelService>((ref) {
  return DuelService(
    db: ref.watch(databaseHelperProvider),
    progressionService: ref.watch(progressionServiceProvider),
    badgeService: ref.watch(badgeServiceProvider),
  );
});

// ════════════════════════════════════════════════════════════════
// ÉTAT DU LOBBY
// ════════════════════════════════════════════════════════════════
class DuelLobbyState {
  final bool isLoading;
  final String? error;
  final List<DuelOpponentModel> opponents;
  final DuelOpponentModel? selectedOpponent;
  final String selectedMode;
  final String selectedLanguage;

  const DuelLobbyState({
    this.isLoading = false,
    this.error,
    this.opponents = const [],
    this.selectedOpponent,
    this.selectedMode = 'qcm',
    this.selectedLanguage = 'Arabe',
  });

  DuelLobbyState copyWith({
    bool? isLoading,
    String? error,
    List<DuelOpponentModel>? opponents,
    DuelOpponentModel? selectedOpponent,
    String? selectedMode,
    String? selectedLanguage,
  }) {
    return DuelLobbyState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      opponents: opponents ?? this.opponents,
      selectedOpponent: selectedOpponent ?? this.selectedOpponent,
      selectedMode: selectedMode ?? this.selectedMode,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

class DuelLobbyNotifier extends StateNotifier<DuelLobbyState> {
  final DuelService _service;

  DuelLobbyNotifier(this._service) : super(const DuelLobbyState());

  Future<void> loadOpponents({int userLevel = 1}) async {
    state = state.copyWith(isLoading: true);
    try {
      final ops = await _service.loadOpponents(userLevel: userLevel);
      state = state.copyWith(
        isLoading: false,
        opponents: ops,
        selectedOpponent: ops.isNotEmpty ? ops.first : null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectOpponent(DuelOpponentModel o) {
    state = state.copyWith(selectedOpponent: o);
  }

  void selectMode(String mode) {
    state = state.copyWith(selectedMode: mode);
  }

  void selectLanguage(String lang) {
    state = state.copyWith(selectedLanguage: lang);
  }

  void clearError() => state = state.copyWith(error: null);
}

final duelLobbyProvider =
    StateNotifierProvider.autoDispose<DuelLobbyNotifier, DuelLobbyState>((ref) {
  return DuelLobbyNotifier(ref.watch(duelServiceProvider));
});

// ════════════════════════════════════════════════════════════════
// ÉTAT DE L'ARÈNE (pendant le duel)
// ════════════════════════════════════════════════════════════════
enum ArenaPhase {
  countdown, // 3-2-1 avant le début
  question, // En attente de réponse
  reveal, // Affiche la bonne réponse
  waiting, // attend le bot
  finished, // Partie terminée
}

class DuelArenaState {
  final DuelSessionModel? session;
  final DuelOpponentModel? opponent;
  final List<DuelQuestionModel> questions;
  final int currentQuestionIndex;
  final ArenaPhase phase;
  final String? playerAnswer;
  final int timeRemainingMs;
  final int player1Score;
  final int player2Score;
  final bool isLoading;
  final String? error;
  final DuelFinalizationResult? result; // set when finished

  const DuelArenaState({
    this.session,
    this.opponent,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.phase = ArenaPhase.countdown,
    this.playerAnswer,
    this.timeRemainingMs = 30000,
    this.player1Score = 0,
    this.player2Score = 0,
    this.isLoading = false,
    this.error,
    this.result,
  });

  DuelQuestionModel? get currentQuestion =>
      questions.isNotEmpty && currentQuestionIndex < questions.length
          ? questions[currentQuestionIndex]
          : null;

  bool get isLastQuestion => currentQuestionIndex >= questions.length - 1;

  double get progressRatio => questions.isEmpty ? 0 : (currentQuestionIndex + 1) / questions.length;

  DuelArenaState copyWith({
    DuelSessionModel? session,
    DuelOpponentModel? opponent,
    List<DuelQuestionModel>? questions,
    int? currentQuestionIndex,
    ArenaPhase? phase,
    String? playerAnswer,
    int? timeRemainingMs,
    int? player1Score,
    int? player2Score,
    bool? isLoading,
    String? error,
    DuelFinalizationResult? result,
  }) {
    return DuelArenaState(
      session: session ?? this.session,
      opponent: opponent ?? this.opponent,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      phase: phase ?? this.phase,
      playerAnswer: playerAnswer,
      timeRemainingMs: timeRemainingMs ?? this.timeRemainingMs,
      player1Score: player1Score ?? this.player1Score,
      player2Score: player2Score ?? this.player2Score,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      result: result ?? this.result,
    );
  }
}

class DuelArenaNotifier extends StateNotifier<DuelArenaState> {
  final DuelService _service;
  final Ref _ref;

  DuelArenaNotifier(this._service, this._ref) : super(const DuelArenaState());

  // Lance une session
  Future<void> startSession({
    required DuelOpponentModel opponent,
    required String mode,
    required String language,
    required String currentUserId,
    required String currentUserName,
  }) async {
    state = state.copyWith(isLoading: true);
    final sessionId = const Uuid().v4();
    final modeData = M6MockData.gameModes.firstWhere(
      (m) => m['id'] == mode,
      orElse: () => M6MockData.gameModes.first,
    );
    final questionCount = modeData['questionCount'] as int;
    final timePerQ = modeData['timePerQ'] as int;

    final session = DuelSessionModel(
      sessionId: sessionId,
      player1Id: currentUserId,
      player2Id: opponent.opponentId,
      player1Name: currentUserName,
      player2Name: opponent.name,
      gameMode: mode,
      language: language,
      questionCount: questionCount,
      timePerQuestion: timePerQ,
      createdAt: DateTime.now(),
    );

    final questions = _service.generateQuestions(
      sessionId: sessionId,
      mode: mode,
      language: language,
      count: questionCount,
    );

    state = state.copyWith(
      session: session,
      opponent: opponent,
      questions: questions,
      currentQuestionIndex: 0,
      phase: ArenaPhase.countdown,
      player1Score: 0,
      player2Score: 0,
      isLoading: false,
    );
  }

  void startQuestion() {
    final q = state.currentQuestion;
    if (q == null) return;
    state = state.copyWith(
      phase: ArenaPhase.question,
      playerAnswer: null,
      timeRemainingMs: (state.session?.timePerQuestion ?? 30) * 1000,
    );
  }

  // Joueur répond
  void submitAnswer(String answer, int elapsedMs) {
    final q = state.currentQuestion;
    final opp = state.opponent;
    if (q == null || state.phase != ArenaPhase.question) return;

    q.player1Answer = answer;
    q.player1Correct = q.isCorrectAnswer(answer);
    q.player1TimeMs = elapsedMs;

    // Simuler la réponse du bot
    if (opp != null) {
      final botResult = _service.simulateBotAnswer(
        opponent: opp,
        question: q,
        timeLimitMs: (state.session?.timePerQuestion ?? 30) * 1000,
      );
      q.player2Answer = botResult.answer;
      q.player2Correct = botResult.isCorrect;
      q.player2TimeMs = botResult.responseTimeMs;
    }

    final newP1Score = state.player1Score + (q.player1Correct ? 1 : 0);
    final newP2Score = state.player2Score + (q.player2Correct ? 1 : 0);

    state = state.copyWith(
      phase: ArenaPhase.reveal,
      playerAnswer: answer,
      player1Score: newP1Score,
      player2Score: newP2Score,
    );
  }

  // Timeout = réponse incorrecte
  void onTimeout() {
    if (state.phase != ArenaPhase.question) return;
    submitAnswer('__timeout__', (state.session?.timePerQuestion ?? 30) * 1000);
  }

  // Passer à la question suivante
  Future<void> nextQuestion() async {
    if (state.isLastQuestion) {
      await _finalize();
    } else {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        phase: ArenaPhase.countdown,
      );
    }
  }

  Future<void> _finalize() async {
    state = state.copyWith(isLoading: true);
    try {
      final currentUserId = _ref.read(currentUserIdProvider);
      final progression = await _ref.read(progressionServiceProvider).getProgression(currentUserId);

      final result = await _service.finalizeSession(
        session: state.session!,
        questions: state.questions,
        currentUserId: currentUserId,
        currentProgression: progression!,
      );

      // Invalider les providers M7 pour forcer un rechargement
      _ref.invalidate(userProgressionProvider);
      _ref.invalidate(addXPProvider);

      state = state.copyWith(
        isLoading: false,
        phase: ArenaPhase.finished,
        result: result,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final duelArenaProvider =
    StateNotifierProvider.autoDispose<DuelArenaNotifier, DuelArenaState>((ref) {
  return DuelArenaNotifier(ref.watch(duelServiceProvider), ref);
});

// ════════════════════════════════════════════════════════════════
// HISTORIQUE DES DUELS
// ════════════════════════════════════════════════════════════════
final duelHistoryProvider = FutureProvider.autoDispose<List<DuelSessionModel>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  return ref.watch(duelServiceProvider).getRecentSessions(userId);
});
