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
  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
      debugPrint('Continuing without Firebase for UI testing purposes.');
    }
  } else {
    debugPrint('Firebase already initialized');
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
