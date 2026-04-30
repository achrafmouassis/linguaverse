// lib/features/quiz/views/quiz_launcher.dart
//
// Widget appelable depuis n'importe quelle leçon pour lancer un quiz.
// Usage :
//   Navigator.push(context, MaterialPageRoute(
//     builder: (_) => QuizLauncher(
//       lessonId: 'lsn_s1',
//       categoryId: 'cat_salutations_ar',
//       languageId: 'ar',
//       lessonTitle: 'Les salutations',
//     ),
//   ));

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import 'quiz_page.dart';

class QuizLauncher extends StatelessWidget {
  final String lessonId;
  final String categoryId;
  final String languageId;
  final String lessonTitle;

  const QuizLauncher({
    super.key,
    required this.lessonId,
    required this.categoryId,
    required this.languageId,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: QuizPage(
        lessonId: lessonId,
        categoryId: categoryId,
        languageId: languageId,
        lessonTitle: lessonTitle,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bouton réutilisable à placer après une leçon
// ─────────────────────────────────────────────
class StartQuizButton extends StatelessWidget {
  final String lessonId;
  final String categoryId;
  final String languageId;
  final String lessonTitle;

  const StartQuizButton({
    super.key,
    required this.lessonId,
    required this.categoryId,
    required this.languageId,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => QuizLauncher(
              lessonId: lessonId,
              categoryId: categoryId,
              languageId: languageId,
              lessonTitle: lessonTitle,
            ),
          ),
        ),
        icon: const Text('🎯', style: TextStyle(fontSize: 20)),
        label: const Text(
          'Commencer le Quiz',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
