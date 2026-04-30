import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('dotenv load failed: $e — continuing with defaults.');
  }

  // Initialiser Firebase — DOIT être terminé AVANT runApp
  // pour que les providers Riverpod puissent accéder à Firebase dès le montage.
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Firebase initialized successfully');
    } else {
      debugPrint('Firebase already initialized (skipped startup init)');
    }
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      debugPrint('Firebase already initialized (duplicate-app trapped)');
    } else {
      debugPrint('Firebase initialization failed: $e');
      debugPrint('Continuing without Firebase for UI testing purposes.');
    }
  }

  // Lancer l'application — ProviderScope est le conteneur Riverpod racine.
  // LinguaVerseApp déclenchera initialize() APRÈS le premier frame
  // (via addPostFrameCallback) pour éviter le crash "!_dirty".
  runApp(
    const ProviderScope(
      child: LinguaVerseApp(),
    ),
  );
}
