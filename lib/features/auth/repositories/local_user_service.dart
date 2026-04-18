import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

/// Service pour la gestion de la base de données locale (sqflite)
/// Gère la persistance des utilisateurs pour l'accès hors-ligne
class LocalUserService {
  static const String _dbName = 'linguaverse.db';
  static const String _tableName = 'users';
  static const int _version = 1;

  static final LocalUserService _instance = LocalUserService._internal();

  Database? _database;

  factory LocalUserService() {
    return _instance;
  }

  LocalUserService._internal();

  /// Obtient l'instance de la base de données (initialise si nécessaire)
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialise la base de données
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _dbName);

    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Crée les tables lors de la première utilisation
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE $_tableName (
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
      ''',
    );
  }

  /// Gère les mises à jour de schéma
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // À ajouter si le schéma change à l'avenir
  }

  /// Sauvegarde ou met à jour un utilisateur
  Future<void> saveUser(UserModel user) async {
    final db = await database;
    await db.insert(
      _tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Récupère un utilisateur par son ID
  Future<UserModel?> getUser(String userId) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isEmpty) {
      return null;
    }

    return UserModel.fromMap(maps.first);
  }

  /// Récupère tous les utilisateurs sauvegardés
  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final maps = await db.query(_tableName);

    return [
      for (final map in maps) UserModel.fromMap(map),
    ];
  }

  /// Met à jour les informations onboarding d'un utilisateur
  Future<void> updateUserOnboarding({
    required String userId,
    required String languageLevel,
    required String learningGoal,
    required String dailyLearningMinutes,
    required String preferredTheme,
  }) async {
    final db = await database;
    await db.update(
      _tableName,
      {
        'languageLevel': languageLevel,
        'learningGoal': learningGoal,
        'dailyLearningMinutes': dailyLearningMinutes,
        'preferredTheme': preferredTheme,
        'isOnboarded': 1,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Met à jour les statistiques de gamification
  Future<void> updateUserStats({
    required String userId,
    int? xpTotal,
    int? streakDays,
    int? lessonsCompleted,
  }) async {
    final db = await database;
    final updates = <String, dynamic>{
      'updatedAt': DateTime.now().toIso8601String(),
      'lastActivityDate': DateTime.now().toIso8601String(),
    };

    if (xpTotal != null) updates['xpTotal'] = xpTotal;
    if (streakDays != null) updates['streakDays'] = streakDays;
    if (lessonsCompleted != null) {
      updates['lessonsCompleted'] = lessonsCompleted;
    }

    await db.update(
      _tableName,
      updates,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Supprime un utilisateur
  Future<void> deleteUser(String userId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Vide la table des utilisateurs
  Future<void> clearAllUsers() async {
    final db = await database;
    await db.delete(_tableName);
  }

  /// Ferme la base de données
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
