import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/language.dart';

final languagesProvider = Provider<List<Language>>((ref) {
  return const [
    Language(id: 'ar', name: 'Arabe', flagEmoji: '🇸🇦', color: Color(0xFF1CB0F6)), // Duolingo Blue
    Language(
        id: 'fr', name: 'Français', flagEmoji: '🇫🇷', color: Color(0xFF58CC02)), // Duolingo Green
    Language(
        id: 'en', name: 'Anglais', flagEmoji: '🇬🇧', color: Color(0xFFFF4B4B)), // Duolingo Red
    Language(
        id: 'es', name: 'Espagnol', flagEmoji: '🇪🇸', color: Color(0xFFFFC800)), // Duolingo Yellow
    Language(
        id: 'it', name: 'Italien', flagEmoji: '🇮🇹', color: Color(0xFFFF9600)), // Duolingo Orange
    Language(
        id: 'tr', name: 'Turc', flagEmoji: '🇹🇷', color: Color(0xFFCE82FF)), // Duolingo Purple
    Language(id: 'de', name: 'Allemand', flagEmoji: '🇩🇪', color: Color(0xFF2B70C9)), // Dark Blue
  ];
});

final selectedLanguageIdProvider = StateProvider<String?>((ref) => null);

final selectedLanguageProvider = Provider<Language?>((ref) {
  final langs = ref.watch(languagesProvider);
  final selectedId = ref.watch(selectedLanguageIdProvider);
  if (selectedId == null) return null;
  return langs.firstWhere((lang) => lang.id == selectedId, orElse: () => langs.first);
});
