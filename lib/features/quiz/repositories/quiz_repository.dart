// lib/features/quiz/repositories/quiz_repository.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/quiz_result_model.dart';
import '../models/srs_card_model.dart';

/// Repository SQLite pour persister les résultats de quiz et les cartes SRS.
class QuizRepository {
  static const _dbName = 'linguaverse_quiz.db';
  static const _dbVersion = 1;

  static const _tableResults = 'quiz_results';
  static const _tableSrs = 'srs_cards';

  Database? _db;

  Future<Database> get _database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableResults (
        id TEXT PRIMARY KEY,
        lessonId TEXT NOT NULL,
        categoryId TEXT NOT NULL,
        languageId TEXT NOT NULL,
        completedAt INTEGER NOT NULL,
        totalQuestions INTEGER NOT NULL,
        correctCount INTEGER NOT NULL,
        xpEarned INTEGER NOT NULL,
        durationSeconds INTEGER NOT NULL,
        scorePercent INTEGER NOT NULL,
        wordsToReview TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableSrs (
        wordTerm TEXT NOT NULL,
        categoryId TEXT NOT NULL,
        languageId TEXT NOT NULL,
        repetitions INTEGER NOT NULL,
        easeFactor REAL NOT NULL,
        intervalDays INTEGER NOT NULL,
        nextReview INTEGER NOT NULL,
        lastReview INTEGER NOT NULL,
        totalAttempts INTEGER NOT NULL,
        correctAttempts INTEGER NOT NULL,
        PRIMARY KEY (wordTerm, categoryId, languageId)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future migrations here
  }

  // ── Quiz Results ──────────────────────────────────────────

  Future<void> saveResult(QuizResult result) async {
    final db = await _database;
    await db.insert(
      _tableResults,
      result.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QuizResult>> getResultsForLesson(String lessonId) async {
    final db = await _database;
    final maps = await db.query(
      _tableResults,
      where: 'lessonId = ?',
      whereArgs: [lessonId],
      orderBy: 'completedAt DESC',
    );
    return maps.map(QuizResult.fromMap).toList();
  }

  Future<List<QuizResult>> getAllResults({int limit = 50}) async {
    final db = await _database;
    final maps = await db.query(
      _tableResults,
      orderBy: 'completedAt DESC',
      limit: limit,
    );
    return maps.map(QuizResult.fromMap).toList();
  }

  Future<int> getTotalXp() async {
    final db = await _database;
    final result = await db.rawQuery(
        'SELECT COALESCE(SUM(xpEarned), 0) as total FROM $_tableResults');
    return (result.first['total'] as int?) ?? 0;
  }

  Future<int> getQuizCount() async {
    final db = await _database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $_tableResults');
    return (result.first['count'] as int?) ?? 0;
  }

  // ── SRS Cards ─────────────────────────────────────────────

  /// Upsert une carte SRS (crée ou met à jour)
  Future<void> upsertSrsCard(SrsCard card) async {
    final db = await _database;
    await db.insert(
      _tableSrs,
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Met à jour les cartes SRS après un quiz
  Future<void> processSrsAfterQuiz({
    required List<String> correctWordTerms,
    required List<String> incorrectWordTerms,
    required String categoryId,
    required String languageId,
  }) async {
    final allTerms = {...correctWordTerms, ...incorrectWordTerms};

    for (final term in allTerms) {
      final existing = await getSrsCard(term, categoryId, languageId);
      final card = existing ??
          SrsCard.initial(
            wordTerm: term,
            categoryId: categoryId,
            languageId: languageId,
          );
      final updated = card.update(
          wasCorrect: correctWordTerms.contains(term));
      await upsertSrsCard(updated);
    }
  }

  Future<SrsCard?> getSrsCard(
      String wordTerm, String categoryId, String languageId) async {
    final db = await _database;
    final maps = await db.query(
      _tableSrs,
      where: 'wordTerm = ? AND categoryId = ? AND languageId = ?',
      whereArgs: [wordTerm, categoryId, languageId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return SrsCard.fromMap(maps.first);
  }

  Future<List<SrsCard>> getDueCards(String languageId) async {
    final db = await _database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final maps = await db.query(
      _tableSrs,
      where: 'languageId = ? AND nextReview <= ?',
      whereArgs: [languageId, now],
      orderBy: 'nextReview ASC',
    );
    return maps.map(SrsCard.fromMap).toList();
  }

  Future<List<SrsCard>> getWeakCards(String languageId,
      {int limit = 10}) async {
    final db = await _database;
    final maps = await db.query(
      _tableSrs,
      where: 'languageId = ? AND totalAttempts > 0',
      whereArgs: [languageId],
      orderBy:
          'CAST(correctAttempts AS REAL) / totalAttempts ASC, totalAttempts DESC',
      limit: limit,
    );
    return maps.map(SrsCard.fromMap).toList();
  }

  Future<void> close() async => _db?.close();
}
