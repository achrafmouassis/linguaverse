import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// Ce provider n'existe QUE en debug
// En release, ThemeMode.system est toujours utilisé

final devThemeProvider = StateProvider<ThemeMode>((ref) {
  // Valeur initiale : suit le système
  return ThemeMode.system;
});

// Getter utilitaire : isDarkMode effectif
final isDarkModeProvider = Provider<bool>((ref) {
  final mode = ref.watch(devThemeProvider);
  if (mode == ThemeMode.system) {
    // Lire la luminosité du système — non disponible directement ici sans contexte,
    // par défaut on retourne true pour le dark mode "Deep Space"
    // Dans les widgets on préfèrera utiliser MediaQuery.platformBrightnessOf(context)
    return true;
  }
  return mode == ThemeMode.dark;
});
