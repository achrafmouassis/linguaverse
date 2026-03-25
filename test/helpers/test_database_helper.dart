import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:linguaverse/core/services/database_helper.dart';

/// Crée une instance de DatabaseHelper configurée pour les tests unitaires
/// Utilise une base de données SQLite en mémoire (isolation totale)
Future<DatabaseHelper> createTestDB() async {
  // Initialisation de l'environnement SQLite FFI pour les tests (Windows/Desktop)
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbHelper = DatabaseHelper.forTesting();
  
  // On force l'ouverture pour s'assurer que onCreate a été exécuté
  await dbHelper.database;
  
  return dbHelper;
}
