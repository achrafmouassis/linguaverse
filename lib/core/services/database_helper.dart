import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Constructeur pour les tests unitaires - crée une nouvelle instance isolée
  DatabaseHelper.forTesting() : _testMode = true;

  Database? _database;
  static const int _dbVersion = 5; // v5 : correction versioning et nettoyage
  bool _testMode = false;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (_testMode) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      return await databaseFactoryFfi.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: _dbVersion,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
        ),
      );
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'linguaverse.db');

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createUserTable(db);
    await _createGamificationTables(db);
    await _addDuelColumnsToProgression(db);
    await _createDuelTables(db);
    await _seedBadges(db);
    await _seedDuelBadges(db);
    await _seedDuelOpponents(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createGamificationTables(db);
      await _seedBadges(db);
    }
    if (oldVersion < 3) {
      await _addDuelColumnsToProgression(db);
      await _createDuelTables(db);
      await _seedDuelBadges(db);
      await _seedDuelOpponents(db);
    }
    if (oldVersion < 4) {
      await _createUserTable(db);
    }
  }

  // ════════════════════════════════════════════════════════════════
  // TABLE USERS (Anciennement dans LocalUserService)
  // ════════════════════════════════════════════════════════════════
  Future<void> _createUserTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        displayName TEXT,
        profileImageUrl TEXT,
        languageLevel TEXT NOT NULL DEFAULT 'A1',
        learningGoal TEXT NOT NULL DEFAULT 'CULTURE',
        dailyLearningMinutes TEXT NOT NULL DEFAULT '15',
        preferredTheme TEXT NOT NULL DEFAULT 'ARABIC',
        xpTotal INTEGER NOT NULL DEFAULT 0,
        streakDays INTEGER NOT NULL DEFAULT 0,
        lessonsCompleted INTEGER NOT NULL DEFAULT 0,
        lastActivityDate TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        isOnboarded INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // ════════════════════════════════════════════════════════════════
  // TABLES M7 GAMIFICATION
  // ════════════════════════════════════════════════════════════════
  Future<void> _createGamificationTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_progression (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id         TEXT NOT NULL UNIQUE,
        current_level   INTEGER NOT NULL DEFAULT 1,
        current_xp      INTEGER NOT NULL DEFAULT 0,
        total_xp_ever   INTEGER NOT NULL DEFAULT 0,
        streak_days     INTEGER NOT NULL DEFAULT 0,
        streak_best     INTEGER NOT NULL DEFAULT 0,
        last_activity_date TEXT,
        lessons_completed INTEGER NOT NULL DEFAULT 0,
        quizzes_completed INTEGER NOT NULL DEFAULT 0,
        words_mastered    INTEGER NOT NULL DEFAULT 0,
        perfect_scores    INTEGER NOT NULL DEFAULT 0,
        total_study_minutes INTEGER NOT NULL DEFAULT 0,
        created_at      TEXT NOT NULL DEFAULT (datetime('now')),
        updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
      );
    ''');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_up_user_id ON user_progression(user_id);');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS xp_events (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id     TEXT NOT NULL,
        source_type TEXT NOT NULL,
        source_id   TEXT,
        source_name TEXT,
        xp_amount   INTEGER NOT NULL,
        multiplier  REAL NOT NULL DEFAULT 1.0,
        language    TEXT,
        created_at  TEXT NOT NULL DEFAULT (datetime('now'))
      );
    ''');
    await db
        .execute('CREATE INDEX IF NOT EXISTS idx_xpe_user_date ON xp_events(user_id, created_at);');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS badges (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        badge_key     TEXT NOT NULL UNIQUE,
        name          TEXT NOT NULL,
        description   TEXT NOT NULL,
        category      TEXT NOT NULL,
        icon_emoji    TEXT NOT NULL,
        color_hex     TEXT NOT NULL,
        rarity        TEXT NOT NULL DEFAULT 'common',
        sort_order    INTEGER NOT NULL DEFAULT 0
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_badges (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id     TEXT NOT NULL,
        badge_key   TEXT NOT NULL,
        earned_at   TEXT NOT NULL DEFAULT (datetime('now')),
        xp_rewarded INTEGER NOT NULL DEFAULT 0,
        UNIQUE(user_id, badge_key),
        FOREIGN KEY (badge_key) REFERENCES badges(badge_key)
      );
    ''');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_ub_user ON user_badges(user_id);');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS weekly_leaderboard (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id     TEXT NOT NULL,
        user_name   TEXT NOT NULL,
        user_initials TEXT NOT NULL,
        week_key    TEXT NOT NULL,
        language    TEXT NOT NULL DEFAULT 'all',
        xp_earned   INTEGER NOT NULL DEFAULT 0,
        rank_position INTEGER,
        updated_at  TEXT NOT NULL DEFAULT (datetime('now')),
        UNIQUE(user_id, week_key, language)
      );
    ''');
    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_wl_week ON weekly_leaderboard(week_key, language, xp_earned DESC);');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS milestones (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id       TEXT NOT NULL,
        milestone_type TEXT NOT NULL,
        target_value  INTEGER NOT NULL,
        current_value INTEGER NOT NULL DEFAULT 0,
        is_completed  INTEGER NOT NULL DEFAULT 0,
        completed_at  TEXT,
        xp_reward     INTEGER NOT NULL DEFAULT 0,
        created_at    TEXT NOT NULL DEFAULT (datetime('now'))
      );
    ''');
  }

  Future<void> _addDuelColumnsToProgression(Database db) async {
    // Vérifier les colonnes existantes pour éviter les erreurs de duplication
    final List<Map<String, dynamic>> columns =
        await db.rawQuery('PRAGMA table_info(user_progression)');
    final existingColumns = columns.map((c) => c['name'] as String).toSet();

    const duelColumns = {
      'duels_played': 'INTEGER NOT NULL DEFAULT 0',
      'duel_wins': 'INTEGER NOT NULL DEFAULT 0',
      'duel_losses': 'INTEGER NOT NULL DEFAULT 0',
      'duel_win_streak': 'INTEGER NOT NULL DEFAULT 0',
      'duel_best_streak': 'INTEGER NOT NULL DEFAULT 0',
      'duel_perfects': 'INTEGER NOT NULL DEFAULT 0',
    };

    for (final entry in duelColumns.entries) {
      if (!existingColumns.contains(entry.key)) {
        await db.execute(
            'ALTER TABLE user_progression ADD COLUMN ${entry.key} ${entry.value}');
      }
    }
  }

  // ════════════════════════════════════════════════════════════════
  // TABLES M6 DUEL
  // ════════════════════════════════════════════════════════════════
  Future<void> _createDuelTables(Database db) async {
    // ── Sessions de duel ─────────────────────────────────────────
    // SOURCE RÉELLE : Firebase Realtime Database quand le multijoueur activé
    // POUR REMPLACER : DuelMatchmakingService.createSession() sur Firebase
    await db.execute('''
      CREATE TABLE IF NOT EXISTS duel_sessions (
        id                INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id        TEXT NOT NULL UNIQUE,
        player1_id        TEXT NOT NULL,
        player2_id        TEXT NOT NULL,
        player1_name      TEXT NOT NULL,
        player2_name      TEXT NOT NULL,
        game_mode         TEXT NOT NULL DEFAULT 'qcm',
        language          TEXT NOT NULL DEFAULT 'Arabe',
        question_count    INTEGER NOT NULL DEFAULT 10,
        time_per_question INTEGER NOT NULL DEFAULT 30,
        player1_score     INTEGER NOT NULL DEFAULT 0,
        player2_score     INTEGER NOT NULL DEFAULT 0,
        winner_id         TEXT,
        is_perfect        INTEGER NOT NULL DEFAULT 0,
        xp_earned         INTEGER NOT NULL DEFAULT 0,
        duration_seconds  INTEGER NOT NULL DEFAULT 0,
        status            TEXT NOT NULL DEFAULT 'pending',
        created_at        TEXT NOT NULL DEFAULT (datetime('now')),
        completed_at      TEXT
      );
    ''');
    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_ds_player1 ON duel_sessions(player1_id, created_at DESC);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_ds_status ON duel_sessions(status);');

    // ── Questions d'une partie ────────────────────────────────────
    // SOURCE RÉELLE : table vocabulary (M2 Leçons) + API questions
    // POUR REMPLACER : DuelQuestionService.generateQuestions(mode, lang, count)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS duel_questions (
        id               INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id       TEXT NOT NULL,
        question_index   INTEGER NOT NULL,
        question_type    TEXT NOT NULL,
        question_text    TEXT NOT NULL,
        correct_answer   TEXT NOT NULL,
        choices          TEXT,
        player1_answer   TEXT,
        player1_correct  INTEGER DEFAULT 0,
        player1_time_ms  INTEGER DEFAULT 0,
        player2_answer   TEXT,
        player2_correct  INTEGER DEFAULT 0,
        player2_time_ms  INTEGER DEFAULT 0,
        language         TEXT NOT NULL DEFAULT 'Arabe',
        difficulty       INTEGER NOT NULL DEFAULT 1,
        created_at       TEXT NOT NULL DEFAULT (datetime('now')),
        FOREIGN KEY (session_id) REFERENCES duel_sessions(session_id)
      );
    ''');
    await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_dq_session ON duel_questions(session_id, question_index);');

    // ── Adversaires disponibles ───────────────────────────────────
    // SOURCE RÉELLE : Firestore users/{uid} + algorithme de matchmaking
    // POUR REMPLACER : DuelMatchmakingService.findOpponent(userId, level)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS duel_opponents (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        opponent_id     TEXT NOT NULL UNIQUE,
        name            TEXT NOT NULL,
        initials        TEXT NOT NULL,
        level           INTEGER NOT NULL DEFAULT 1,
        total_xp        INTEGER NOT NULL DEFAULT 0,
        win_rate        INTEGER NOT NULL DEFAULT 50,
        avg_response_ms INTEGER NOT NULL DEFAULT 2000,
        difficulty      TEXT NOT NULL DEFAULT 'medium',
        color1_hex      TEXT NOT NULL DEFAULT '#6359FF',
        color2_hex      TEXT NOT NULL DEFAULT '#1D9E75',
        is_bot          INTEGER NOT NULL DEFAULT 1,
        is_active       INTEGER NOT NULL DEFAULT 1
      );
    ''');
  }

  // ════════════════════════════════════════════════════════════════
  // SEEDERS
  // ════════════════════════════════════════════════════════════════
  Future<void> _seedBadges(Database db) async {
    final badges = [
      (
        'streak_7',
        'Semaine de feu',
        'streak',
        '🔥',
        '#EA580C',
        'common',
        1,
        'Maintenir un streak de 7 jours'
      ),
      (
        'streak_14',
        'Deux semaines !',
        'streak',
        '🔥',
        '#DC2626',
        'rare',
        2,
        'Maintenir un streak de 14 jours'
      ),
      (
        'streak_30',
        'Un mois solide',
        'streak',
        '💎',
        '#7C3AED',
        'epic',
        3,
        'Maintenir un streak de 30 jours'
      ),
      (
        'streak_100',
        'Légende vivante',
        'streak',
        '👑',
        '#D97706',
        'legendary',
        4,
        'Maintenir un streak de 100 jours'
      ),
      ('xp_1000', '1 000 XP', 'xp', '⭐', '#EF9F27', 'common', 10, 'Accumuler 1000 XP'),
      ('xp_5000', '5 000 XP', 'xp', '🌟', '#F59E0B', 'rare', 11, 'Accumuler 5000 XP'),
      ('xp_10000', '10 000 XP', 'xp', '💫', '#D97706', 'epic', 12, 'Accumuler 10000 XP'),
      ('xp_50000', 'Maître absolu', 'xp', '🏆', '#92400E', 'legendary', 13, 'Accumuler 50000 XP'),
      ('lessons_10', '10 leçons', 'learning', '📖', '#1D9E75', 'common', 20, 'Compléter 10 leçons'),
      ('lessons_50', '50 leçons', 'learning', '📚', '#0F6E56', 'rare', 21, 'Compléter 50 leçons'),
      (
        'words_200',
        '200 mots maîtrisés',
        'learning',
        '🧠',
        '#1D9E75',
        'epic',
        22,
        'Maîtriser 200 mots'
      ),
      (
        'perfect_5',
        '5 scores parfaits',
        'quiz',
        '⚡',
        '#378ADD',
        'common',
        30,
        'Obtenir 5 scores parfaits'
      ),
      (
        'quiz_speed',
        'Éclair de vitesse',
        'quiz',
        '💨',
        '#0C447C',
        'rare',
        31,
        'Répondre en moins de 3 secondes'
      ),
      ('level_5', 'Niveau 5', 'level', '🚀', '#6359FF', 'common', 40, 'Atteindre le niveau 5'),
      ('level_10', 'Niveau 10', 'level', '🛸', '#534AB7', 'rare', 41, 'Atteindre le niveau 10'),
      (
        'level_20',
        'Maître du niveau',
        'level',
        '🌌',
        '#3C3489',
        'legendary',
        42,
        'Atteindre le niveau 20'
      ),
      (
        'first_voice',
        'Première voix',
        'voice',
        '🎙️',
        '#D4537E',
        'common',
        50,
        'Utiliser la reconnaissance vocale'
      ),
      (
        'ar_explorer',
        'Explorateur AR',
        'ar',
        '📷',
        '#1D9E75',
        'common',
        60,
        'Scanner un objet en réalité augmentée'
      ),
      ('polyglot_2', 'Bilingue', 'special', '🌍', '#9333EA', 'epic', 70, 'Apprendre 2 langues'),
      (
        'top_1_week',
        'N°1 du classement',
        'social',
        '👑',
        '#EF9F27',
        'legendary',
        80,
        'Être premier du classement hebdomadaire'
      ),
    ];

    await db.transaction((txn) async {
      for (final b in badges) {
        await txn.execute('''
          INSERT OR IGNORE INTO badges
            (badge_key, name, category, icon_emoji, color_hex, rarity, sort_order, description)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', [b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, b.$7, b.$8]);
      }
    });
  }

  Future<void> _seedDuelBadges(Database db) async {
    // ════════════════════════════════════════════════════════════════
    // BADGES DUEL M6 — CONDITIONS VÉRIFIÉES PAR BadgeService
    // CONDITION duel_first   : duels_played >= 1
    // CONDITION duel_win_3   : duel_win_streak >= 3
    // CONDITION duel_win_10  : duel_wins >= 10
    // CONDITION duel_perfect : duel_perfects >= 1
    // CONDITION duel_champion: duel_wins >= 50
    // ════════════════════════════════════════════════════════════════
    final duelBadges = [
      (
        'duel_first',
        'Premier Duel',
        'social',
        '⚔️',
        '#534AB7',
        'common',
        90,
        'Jouer son premier duel'
      ),
      (
        'duel_win_3',
        'Série de 3',
        'social',
        '🔥',
        '#EA580C',
        'common',
        91,
        '3 victoires consécutives'
      ),
      ('duel_win_10', 'Duelliste', 'social', '🏆', '#EF9F27', 'rare', 92, '10 victoires au total'),
      (
        'duel_perfect',
        'Duel Parfait',
        'social',
        '💎',
        '#7C3AED',
        'epic',
        93,
        'Victoire avec 100% de bonnes réponses'
      ),
      (
        'duel_champion',
        'Champion',
        'social',
        '👑',
        '#D97706',
        'legendary',
        94,
        '50 victoires au total'
      ),
    ];

    await db.transaction((txn) async {
      for (final b in duelBadges) {
        await txn.execute('''
          INSERT OR IGNORE INTO badges
            (badge_key, name, category, icon_emoji, color_hex, rarity, sort_order, description)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', [b.$1, b.$2, b.$3, b.$4, b.$5, b.$6, b.$7, b.$8]);
      }
    });
  }

  Future<void> _seedDuelOpponents(Database db) async {
    // ════════════════════════════════════════════════════════════════
    // ADVERSAIRES HARDCODÉS — DONNÉES PROVISOIRES
    // SOURCE RÉELLE :
    //   Bots → DuelBotService (algorithme local)
    //   Vrais joueurs → Firestore users/{uid} quand Firebase activé (M1)
    //   Joueurs du leaderboard M7 réutilisés pour cohérence visuelle
    // POUR REMPLACER : DuelMatchmakingService.findOpponent(userId, level)
    // ════════════════════════════════════════════════════════════════
    final opponents = [
      // ── Bots avec difficulté croissante ──────────────────────────
      ('bot_1', 'AliBota', 'AB', 3, 800, 55, 3200, 'easy', '#888780', '#B4B2A9', 1),
      ('bot_2', 'SaraBot', 'SB', 5, 1500, 65, 2500, 'medium', '#1D9E75', '#9FE1CB', 1),
      ('bot_3', 'KarimBot', 'KB', 7, 3000, 75, 2000, 'medium', '#378ADD', '#85B7EB', 1),
      ('bot_4', 'LeilaBot', 'LB', 10, 5000, 85, 1500, 'hard', '#534AB7', '#AFA9EC', 1),
      ('bot_5', 'MasterBot', 'MB', 15, 9000, 92, 1000, 'expert', '#D97706', '#FAC775', 1),
      // ── Joueurs réels du leaderboard M7 ─────────────────────────
      ('user_zineb', 'Zineb B.', 'ZB', 8, 4820, 78, 1800, 'hard', '#6359FF', '#AFA9EC', 0),
      ('user_abdel', 'Abdelmoughit', 'AM', 7, 3910, 70, 2100, 'medium', '#D85A30', '#FAC775', 0),
      ('user_achraf', 'Achraf M.', 'AC', 6, 3560, 65, 2300, 'medium', '#185FA5', '#85B7EB', 0),
    ];

    await db.transaction((txn) async {
      for (final o in opponents) {
        await txn.execute('''
          INSERT OR IGNORE INTO duel_opponents
            (opponent_id, name, initials, level, total_xp, win_rate,
             avg_response_ms, difficulty, color1_hex, color2_hex, is_bot)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', [o.$1, o.$2, o.$3, o.$4, o.$5, o.$6, o.$7, o.$8, o.$9, o.$10, o.$11]);
      }
    });
  }

  Future<void> initUserProgression(String userId) async {
    final db = await database;
    await db.execute('''
      INSERT OR IGNORE INTO user_progression (user_id)
      VALUES (?)
    ''', [userId]);
    await _seedMilestones(db, userId);
  }

  Future<void> _seedMilestones(Database db, String userId) async {
    final milestones = [
      ('streak_goal', 7, 50),
      ('streak_goal', 30, 200),
      ('xp_goal', 1000, 100),
      ('xp_goal', 5000, 500),
      ('level_goal', 5, 250),
      ('level_goal', 10, 1000),
      ('lessons_goal', 10, 150),
    ];

    for (final m in milestones) {
      await db.execute('''
        INSERT OR IGNORE INTO milestones (user_id, milestone_type, target_value, xp_reward)
        VALUES (?, ?, ?, ?)
      ''', [userId, m.$1, m.$2, m.$3]);
    }
  }
}
