// lib/features/quiz/views/quiz_entry_page.dart
//
// Page de sélection de quiz (accessible via /quiz route).
// Permet à l'utilisateur de choisir la langue + catégorie  
// pour lancer un quiz sans obligatoirement venir d'une leçon.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import 'quiz_page.dart';

class QuizEntryPage extends ConsumerStatefulWidget {
  const QuizEntryPage({super.key});

  @override
  ConsumerState<QuizEntryPage> createState() => _QuizEntryPageState();
}

class _QuizEntryPageState extends ConsumerState<QuizEntryPage> {
  String _selectedLanguage = 'ar';
  String _selectedCategory = 'cat_salutations_ar';

  static const _languages = [
    {'id': 'ar', 'name': 'Arabe', 'flag': '🇸🇦'},
    {'id': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'id': 'en', 'name': 'Anglais', 'flag': '🇬🇧'},
    {'id': 'es', 'name': 'Espagnol', 'flag': '🇪🇸'},
    {'id': 'de', 'name': 'Allemand', 'flag': '🇩🇪'},
    {'id': 'it', 'name': 'Italien', 'flag': '🇮🇹'},
    {'id': 'tr', 'name': 'Turc', 'flag': '🇹🇷'},
  ];

  static const _categories = {
    'ar': [
      {'id': 'cat_salutations_ar', 'name': 'Les salutations', 'icon': '👋'},
      {'id': 'cat_nombres_ar', 'name': 'Les nombres', 'icon': '🔢'},
      {'id': 'cat_alphabet_ar', 'name': "L'alphabet", 'icon': '🔤'},
    ],
    'fr': [
      {'id': 'cat_salutations_fr', 'name': 'Les salutations', 'icon': '👋'},
      {'id': 'cat_nombres_fr', 'name': 'Les nombres', 'icon': '🔢'},
    ],
    'en': [
      {'id': 'cat_salutations_en', 'name': 'Greetings', 'icon': '👋'},
      {'id': 'cat_nombres_en', 'name': 'Numbers', 'icon': '🔢'},
    ],
    'es': [
      {'id': 'cat_salutations_es', 'name': 'Las salutaciones', 'icon': '👋'},
      {'id': 'cat_nombres_es', 'name': 'Los números', 'icon': '🔢'},
    ],
    'de': [
      {'id': 'cat_salutations_de', 'name': 'Begrüßungen', 'icon': '👋'},
      {'id': 'cat_nombres_de', 'name': 'Zahlen', 'icon': '🔢'},
    ],
    'it': [
      {'id': 'cat_salutations_it', 'name': 'Saluti', 'icon': '👋'},
      {'id': 'cat_nombres_it', 'name': 'Numeri', 'icon': '🔢'},
    ],
    'tr': [
      {'id': 'cat_salutations_tr', 'name': 'Selamlar', 'icon': '👋'},
      {'id': 'cat_nombres_tr', 'name': 'Sayılar', 'icon': '🔢'},
    ],
  };

  List<Map<String, String>> get _currentCategories =>
      (_categories[_selectedLanguage] ?? [])
          .cast<Map<String, String>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quiz',
            style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A56DB), Color(0xFF5B21B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 48)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Teste tes connaissances !',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          '5 types de questions · Timer 30s · XP & badges',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Langue
            Text('Choisir la langue',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.4),
              itemCount: _languages.length,
              itemBuilder: (_, i) {
                final lang = _languages[i];
                final sel = _selectedLanguage == lang['id'];
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedLanguage = lang['id']!;
                    _selectedCategory =
                        _currentCategories.isNotEmpty
                            ? _currentCategories.first['id']!
                            : '';
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primaryLight : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: sel
                              ? AppColors.primary
                              : AppColors.outline,
                          width: sel ? 2 : 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(lang['flag']!,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Text(lang['name']!,
                            style: TextStyle(
                                fontWeight: sel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: sel
                                    ? AppColors.primary
                                    : AppColors.textPrimary)),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Catégorie
            Text('Choisir le thème',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ..._currentCategories.map((cat) {
              final sel = _selectedCategory == cat['id'];
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedCategory = cat['id']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: sel
                            ? AppColors.primary
                            : AppColors.outline,
                        width: sel ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Text(cat['icon']!,
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Text(cat['name']!,
                          style: TextStyle(
                              fontWeight: sel
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 15,
                              color: sel
                                  ? AppColors.primary
                                  : AppColors.textPrimary)),
                      const Spacer(),
                      if (sel)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 32),

            // CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedCategory.isEmpty
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuizPage(
                              lessonId:
                                  'lesson_${_selectedCategory}',
                              categoryId: _selectedCategory,
                              languageId: _selectedLanguage,
                              lessonTitle: _currentCategories
                                  .firstWhere((c) =>
                                      c['id'] == _selectedCategory,
                                      orElse: () => {'name': 'Quiz'})['name']!,
                            ),
                          ),
                        ),
                icon: const Text('🎯',
                    style: TextStyle(fontSize: 20)),
                label: const Text('Lancer le Quiz',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.outline,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor:
                      AppColors.primary.withOpacity(0.4),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
