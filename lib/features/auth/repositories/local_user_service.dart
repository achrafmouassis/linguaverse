import '../../../core/services/database_helper.dart';
import '../models/user_model.dart';
import 'package:sqflite/sqflite.dart';

/// Service pour la gestion de la base de données locale (sqflite)
/// Gère la persistance des utilisateurs pour l'accès hors-ligne
class LocalUserService {
  static const String _tableName = 'users';

  static final LocalUserService _instance = LocalUserService._internal();
  factory LocalUserService() => _instance;
  LocalUserService._internal();

  /// Obtient l'instance de la base de données via DatabaseHelper
  Future<Database> get database async {
    return await DatabaseHelper().database;
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
}
