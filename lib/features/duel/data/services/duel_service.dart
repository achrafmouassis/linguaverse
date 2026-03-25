import 'dart:math';
import 'package:sqflite/sqflite.dart';

import '../../../../core/services/database_helper.dart';
import '../../data/mock/m6_mock_data.dart';
import '../../data/models/duel_opponent_model.dart';
import '../../data/models/duel_question_model.dart';
import '../../data/models/duel_session_model.dart';
import '../../../gamification/data/services/progression_service.dart';
import '../../../gamification/data/services/badge_service.dart';
import '../../../gamification/data/models/badge_model.dart';
import '../../../gamification/data/models/user_progression_model.dart';

// ════════════════════════════════════════════════════════════════
// DUEL SERVICE — M6
// ════════════════════════════════════════════════════════════════
// Ce service orchestre la logique de duel :
//   1. Charger les adversaires (bots) depuis la DB
//   2. Générer les questions selon le mode et la langue
//   3. Simuler les réponses du bot
//   4. Finaliser la session : écrire en DB, mettre à jour stats, badge check
//
// MIGRATION MULTIJOUEUR :
//   Remplacer les méthodes "mock" par des appels Firebase Realtime Database
//   Utiliser DuelMatchmakingService pour trouver un adversaire réel
// ════════════════════════════════════════════════════════════════

class DuelService {
  final DatabaseHelper _db;
  final ProgressionService _progressionService;
  final BadgeService _badgeService;
  final _rng = Random();

  DuelService({
    required DatabaseHelper db,
    required ProgressionService progressionService,
    required BadgeService badgeService,
  })  : _db = db,
        _progressionService = progressionService,
        _badgeService = badgeService;

  // ── 1. ADVERSAIRES ────────────────────────────────────────────
  // SOURCE RÉELLE : SELECT * FROM duel_opponents WHERE is_active = 1
  // POUR REMPLACER : Firebase users query + algorithme ELO matchmaking
  Future<List<DuelOpponentModel>> loadOpponents({int userLevel = 1}) async {
    final db = await _db.database;
    final rows = await db.query(
      'duel_opponents',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'level ASC',
    );
    if (rows.isEmpty) {
      // Fallback si la table n'est pas encore seedée
      return _fallbackOpponents();
    }
    return rows.map(DuelOpponentModel.fromMap).toList();
  }

  List<DuelOpponentModel> _fallbackOpponents() {
    return [
      const DuelOpponentModel(
        opponentId: 'bot_1',
        name: 'AliBota',
        initials: 'AB',
        level: 3,
        totalXP: 800,
        winRate: 55,
        avgResponseMs: 3200,
        difficulty: 'easy',
        color1Hex: '#888780',
        color2Hex: '#B4B2A9',
        isBot: true,
      ),
      const DuelOpponentModel(
        opponentId: 'bot_2',
        name: 'SaraBot',
        initials: 'SB',
        level: 5,
        totalXP: 1500,
        winRate: 65,
        avgResponseMs: 2500,
        difficulty: 'medium',
        color1Hex: '#1D9E75',
        color2Hex: '#9FE1CB',
        isBot: true,
      ),
      const DuelOpponentModel(
        opponentId: 'bot_3',
        name: 'KarimBot',
        initials: 'KB',
        level: 7,
        totalXP: 3000,
        winRate: 75,
        avgResponseMs: 2000,
        difficulty: 'medium',
        color1Hex: '#378ADD',
        color2Hex: '#85B7EB',
        isBot: true,
      ),
      const DuelOpponentModel(
        opponentId: 'bot_5',
        name: 'MasterBot',
        initials: 'MB',
        level: 15,
        totalXP: 9000,
        winRate: 90,
        avgResponseMs: 1000,
        difficulty: 'expert',
        color1Hex: '#D97706',
        color2Hex: '#FAC775',
        isBot: true,
      ),
    ];
  }

  // ── 2. GÉNÉRATION DES QUESTIONS ───────────────────────────────
  // SOURCE RÉELLE :
  //   QCM       → vocabulary table WHERE language = ? ORDER BY RANDOM()
  //   Vocab     → vocabulary table WHERE has_translation = 1
  //   Emoji     → emoji_words table (M7 réutilisé)
  //   Speed     → mixed sources
  // POUR REMPLACER : DuelQuestionService.generateQuestions(mode, lang, count)
  List<DuelQuestionModel> generateQuestions({
    required String sessionId,
    required String mode,
    required String language,
    required int count,
  }) {
    switch (mode) {
      case 'vocabulary':
        return _generateVocabQuestions(sessionId, language, count);
      case 'emoji_battle':
        return _generateEmojiQuestions(sessionId, language, count);
      case 'speed_round':
        return _generateSpeedQuestions(sessionId, language, count);
      default:
        return _generateQcmQuestions(sessionId, language, count);
    }
  }

  List<DuelQuestionModel> _generateQcmQuestions(String sessionId, String language, int count) {
    final pool = List<Map<String, dynamic>>.from(
      M6MockData.qcmQuestions[language] ?? M6MockData.qcmQuestions['Arabe']!,
    )..shuffle(_rng);
    final selected = pool.take(count.clamp(1, pool.length)).toList();
    return selected.asMap().entries.map((entry) {
      final q = entry.value;
      final choices = List<String>.from(q['choices'] as List<dynamic>)..shuffle(_rng);
      return DuelQuestionModel(
        sessionId: sessionId,
        questionIndex: entry.key,
        questionType: 'qcm',
        questionText: q['text'] as String,
        correctAnswer: q['correct'] as String,
        choices: choices,
        language: language,
        difficulty: q['difficulty'] as int,
      );
    }).toList();
  }

  List<DuelQuestionModel> _generateVocabQuestions(String sessionId, String language, int count) {
    final pool = List<Map<String, dynamic>>.from(
      M6MockData.vocabQuestions.where((q) => q['language'] == language).toList(),
    );
    if (pool.isEmpty) {
      pool.addAll(M6MockData.vocabQuestions);
    }
    pool.shuffle(_rng);
    final selected = pool.take(count.clamp(1, pool.length)).toList();
    return selected.asMap().entries.map((entry) {
      final q = entry.value;
      return DuelQuestionModel(
        sessionId: sessionId,
        questionIndex: entry.key,
        questionType: 'vocabulary',
        questionText: 'Traduire : "${q['word']}"',
        correctAnswer: '${q['answer']} (${q['transliteration']})',
        choices: [],
        language: language,
        difficulty: 1,
      );
    }).toList();
  }

  List<DuelQuestionModel> _generateEmojiQuestions(String sessionId, String language, int count) {
    final pool = List<Map<String, dynamic>>.from(M6MockData.emojiBattleQuestions)..shuffle(_rng);
    final selected = pool.take(count.clamp(1, pool.length)).toList();
    return selected.asMap().entries.map((entry) {
      final q = entry.value;
      return DuelQuestionModel(
        sessionId: sessionId,
        questionIndex: entry.key,
        questionType: 'emoji_battle',
        questionText: q['emoji'] as String,
        correctAnswer: q['answer'] as String,
        choices: [],
        language: language,
        difficulty: q['difficulty'] as int,
      );
    }).toList();
  }

  List<DuelQuestionModel> _generateSpeedQuestions(String sessionId, String language, int count) {
    // Speed round mélange QCM et vocabulaire
    final qcmPool = List<Map<String, dynamic>>.from(
      M6MockData.qcmQuestions[language] ?? M6MockData.qcmQuestions['Arabe']!,
    )..shuffle(_rng);
    final vocabPool = List<Map<String, dynamic>>.from(M6MockData.vocabQuestions)..shuffle(_rng);
    final questions = <DuelQuestionModel>[];

    for (int i = 0; i < count; i++) {
      if (i % 2 == 0 && qcmPool.isNotEmpty) {
        final q = qcmPool.removeAt(0);
        final choices = List<String>.from(q['choices'] as List<dynamic>)..shuffle(_rng);
        questions.add(DuelQuestionModel(
          sessionId: sessionId,
          questionIndex: i,
          questionType: 'speed_round',
          questionText: q['text'] as String,
          correctAnswer: q['correct'] as String,
          choices: choices,
          language: language,
          difficulty: q['difficulty'] as int,
        ));
      } else if (vocabPool.isNotEmpty) {
        final q = vocabPool.removeAt(0);
        questions.add(DuelQuestionModel(
          sessionId: sessionId,
          questionIndex: i,
          questionType: 'speed_round',
          questionText: '⚡ ${q['word']}',
          correctAnswer: '${q['answer']}',
          choices: [],
          language: language,
          difficulty: 1,
        ));
      }
    }
    return questions;
  }

  // ── 3. RÉPONSE DU BOT ─────────────────────────────────────────
  // SOURCE RÉELLE : Réponse quasi-instantanée depuis Firebase (vrai joueur)
  // POUR REMPLACER : Firebase Realtime listen sur /duels/{sessionId}/player2Answer
  DuelQuestionResult simulateBotAnswer({
    required DuelOpponentModel opponent,
    required DuelQuestionModel question,
    required int timeLimitMs,
  }) {
    final responseTimeMs = opponent.simulateResponseTimeMs().clamp(500, timeLimitMs - 100);
    final isCorrect = opponent.simulateAnswer();

    String botAnswer;
    if (isCorrect && question.choices.isNotEmpty) {
      botAnswer = question.correctAnswer;
    } else if (question.choices.isNotEmpty) {
      final wrongChoices = question.choices.where((c) => c != question.correctAnswer).toList();
      botAnswer = wrongChoices.isNotEmpty
          ? wrongChoices[_rng.nextInt(wrongChoices.length)]
          : question.correctAnswer;
    } else {
      botAnswer = isCorrect ? question.correctAnswer : 'Erreur';
    }

    return DuelQuestionResult(
      answer: botAnswer,
      isCorrect: isCorrect,
      responseTimeMs: responseTimeMs,
    );
  }

  // ── 4. FINALISATION DE SESSION ────────────────────────────────
  // SOURCE RÉELLE : Cloud Function Firebase qui finalise la session
  // POUR REMPLACER : DuelMatchmakingService.finalizeSession(sessionId)
  Future<DuelFinalizationResult> finalizeSession({
    required DuelSessionModel session,
    required List<DuelQuestionModel> questions,
    required String currentUserId,
    required UserProgressionModel currentProgression,
  }) async {
    final db = await _db.database;

    // Calcul des scores
    final p1Score = questions.where((q) => q.player1Correct).length;
    final p2Score = questions.where((q) => q.player2Correct).length;
    final won = p1Score > p2Score;
    final isDraw = p1Score == p2Score;
    final isPerfect = won && p1Score == questions.length;

    final winnerId = isDraw ? null : (won ? session.player1Id : session.player2Id);
    final durationSeconds = _calculateDuration(questions);

    // Calcul XP
    final xpEarned = DuelSessionModel.calculateXP(
      mode: session.gameMode,
      won: won,
      isPerfect: isPerfect,
      winStreak: currentProgression.duelWinStreak,
    );

    // 1. Enregistrer la session finale
    final updatedSession = session.copyWith(
      player1Score: p1Score,
      player2Score: p2Score,
      winnerId: winnerId,
      isPerfect: isPerfect,
      xpEarned: xpEarned,
      durationSeconds: durationSeconds,
      status: DuelStatus.completed,
      completedAt: DateTime.now(),
    );

    await db.insert(
      'duel_sessions',
      updatedSession.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 2. Enregistrer les questions
    for (final q in questions) {
      await db.insert(
        'duel_questions',
        q.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    // 3. Mettre à jour les statistiques progression
    if (won) {
      final newStreak = currentProgression.duelWinStreak + 1;
      final newBest = newStreak > currentProgression.duelBestStreak
          ? newStreak
          : currentProgression.duelBestStreak;
      await db.execute('''
        UPDATE user_progression
        SET duels_played     = duels_played + 1,
            duel_wins        = duel_wins + 1,
            duel_win_streak  = ?,
            duel_best_streak = ?,
            duel_perfects    = duel_perfects + ?
        WHERE user_id = ?
      ''', [newStreak, newBest, isPerfect ? 1 : 0, currentUserId]);
    } else {
      await db.execute('''
        UPDATE user_progression
        SET duels_played    = duels_played + 1,
            duel_losses     = duel_losses + 1,
            duel_win_streak = 0
        WHERE user_id = ?
      ''', [currentUserId]);
    }

    // 4. Ajouter XP via ProgressionService (M7)
    final xpResult = await _progressionService.addXP(
      userId: currentUserId,
      userName: session.player1Name,
      userInitials:
          session.player1Name.isNotEmpty ? session.player1Name.substring(0, 1).toUpperCase() : 'P',
      sourceType: won ? (isPerfect ? 'duel_perfect' : 'duel_win') : 'duel_loss',
      overrideAmount: xpEarned,
      sourceName: 'Duel terminé',
    );

    // 5. Check les badges duel
    final updatedProg = await _progressionService.getProgression(currentUserId);
    final newBadges = <BadgeModel>[];
    if (updatedProg != null) {
      final earned = await _checkDuelBadges(currentUserId, updatedProg);
      newBadges.addAll(earned);
    }

    return DuelFinalizationResult(
      session: updatedSession,
      xpResult: xpResult,
      newBadges: newBadges,
      isPerfect: isPerfect,
      won: won,
      isDraw: isDraw,
    );
  }

  Future<List<BadgeModel>> _checkDuelBadges(String userId, UserProgressionModel prog) async {
    final toAward = <String>[];

    if (prog.duelsPlayed >= 1) toAward.add('duel_first');
    if (prog.duelWinStreak >= 3) toAward.add('duel_win_3');
    if (prog.duelWins >= 10) toAward.add('duel_win_10');
    if (prog.duelPerfects >= 1) toAward.add('duel_perfect');
    if (prog.duelWins >= 50) toAward.add('duel_champion');

    final awarded = <BadgeModel>[];
    for (final key in toAward) {
      final badge = await _badgeService.awardBadge(userId: userId, badgeKey: key);
      if (badge != null) awarded.add(badge);
    }
    return awarded;
  }

  int _calculateDuration(List<DuelQuestionModel> questions) {
    if (questions.isEmpty) return 0;
    int total = 0;
    for (final q in questions) {
      total += q.player1TimeMs;
    }
    return (total / 1000).ceil();
  }

  // ── 5. HISTORIQUE ──────────────────────────────────────────────
  Future<List<DuelSessionModel>> getRecentSessions(String userId, {int limit = 10}) async {
    final db = await _db.database;
    final rows = await db.query(
      'duel_sessions',
      where: 'player1_id = ? AND status = ?',
      whereArgs: [userId, 'completed'],
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return rows.map(DuelSessionModel.fromMap).toList();
  }
}

// ── Value objects ────────────────────────────────────────────────
class DuelQuestionResult {
  final String answer;
  final bool isCorrect;
  final int responseTimeMs;
  const DuelQuestionResult({
    required this.answer,
    required this.isCorrect,
    required this.responseTimeMs,
  });
}

class DuelFinalizationResult {
  final DuelSessionModel session;
  final XpGainResult xpResult;
  final List<BadgeModel> newBadges;
  final bool isPerfect;
  final bool won;
  final bool isDraw;

  const DuelFinalizationResult({
    required this.session,
    required this.xpResult,
    required this.newBadges,
    required this.isPerfect,
    required this.won,
    required this.isDraw,
  });
}
