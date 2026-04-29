import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../models/category_level.dart';
import '../models/lesson.dart';
import '../viewmodels/lesson_categories_provider.dart';
import '../viewmodels/user_progress_provider.dart';

class CategoryLevelsPage extends ConsumerWidget {
  final String languageId;
  final String categoryId;

  const CategoryLevelsPage({
    super.key,
    required this.languageId,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(lessonCategoriesProvider(languageId));
    final category = categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => categories.first,
    );
    final progress = ref.watch(userProgressProvider);
    final notifier = ref.read(userProgressProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Progression globale de l'unité
    final totalLessons = category.levels.fold<int>(0, (sum, l) => sum + l.lessons.length);
    final passedQuizzes = category.levels
        .expand((l) => l.lessons)
        .where((lesson) => notifier.isLessonQuizPassed(lesson.id))
        .length;
    final allLessonsQuizPassed = passedQuizzes == totalLessons && totalLessons > 0;
    final unitQuizPassed = notifier.isUnitQuizPassed(
      languageId: languageId,
      categoryId: categoryId,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // ── Méthode ──
          Container(
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).cardColor,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Méthode d\'apprentissage',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  category.learningMethod,
                  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white70 : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // ── Niveaux, leçons et quiz final ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              // +1 pour la carte du quiz final en bas
              itemCount: category.levels.length + 1,
              itemBuilder: (context, idx) {
                // Dernière carte : Quiz Final
                if (idx == category.levels.length) {
                  return _FinalQuizCard(
                    isUnlocked: allLessonsQuizPassed,
                    isPassed: unitQuizPassed,
                    passedCount: passedQuizzes,
                    totalCount: totalLessons,
                    languageId: languageId,
                    categoryId: categoryId,
                    isDark: isDark,
                  );
                }

                final level = category.levels[idx];
                final isLevelUnlocked = idx == 0 ||
                    notifier.isLessonQuizPassed(
                        '${categoryId}_lvl_${idx - 1}_lsn_2');

                return _LevelCard(
                  level: level,
                  levelIndex: idx,
                  isLevelUnlocked: isLevelUnlocked,
                  categoryId: categoryId,
                  languageId: languageId,
                  isDark: isDark,
                  notifier: notifier,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// _LevelCard  —  affiche un niveau avec ses leçons individuelles
// ════════════════════════════════════════════════════════════════════
class _LevelCard extends StatelessWidget {
  final CategoryLevel level;
  final int levelIndex;
  final bool isLevelUnlocked;
  final String categoryId;
  final String languageId;
  final bool isDark;
  final UserProgressNotifier notifier;

  const _LevelCard({
    required this.level,
    required this.levelIndex,
    required this.isLevelUnlocked,
    required this.categoryId,
    required this.languageId,
    required this.isDark,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    const color = AppColors.primary;
    final allQuizPassed = level.lessons.every((l) => notifier.isLessonQuizPassed(l.id));

    return Opacity(
      opacity: isLevelUnlocked ? 1.0 : 0.45,
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isLevelUnlocked ? color.withOpacity(0.28) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── En-tête niveau ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(level.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (allQuizPassed)
                    const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 24)
                  else if (!isLevelUnlocked)
                    const Icon(Icons.lock_rounded, color: Colors.grey, size: 22),
                ],
              ),
              const SizedBox(height: 14),

              // ── Leçons individuelles ──
              ...level.lessons.asMap().entries.map((entry) {
                final lessonIdx = entry.key;
                final lesson = entry.value;
                return _LessonRow(
                  lesson: lesson,
                  lessonIndex: lessonIdx,
                  levelIndex: levelIndex,
                  isLevelUnlocked: isLevelUnlocked,
                  categoryId: categoryId,
                  languageId: languageId,
                  notifier: notifier,
                  isDark: isDark,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// _LessonRow  —  Une leçon avec son état et son bouton
// ════════════════════════════════════════════════════════════════════
class _LessonRow extends StatelessWidget {
  final Lesson lesson;
  final int lessonIndex;
  final int levelIndex;
  final bool isLevelUnlocked;
  final String categoryId;
  final String languageId;
  final UserProgressNotifier notifier;
  final bool isDark;

  const _LessonRow({
    required this.lesson,
    required this.lessonIndex,
    required this.levelIndex,
    required this.isLevelUnlocked,
    required this.categoryId,
    required this.languageId,
    required this.notifier,
    required this.isDark,
  });

  bool get _isLessonAccessible {
    if (!isLevelUnlocked) return false;
    if (lessonIndex == 0) return true;
    // Accessible si le quiz de la leçon précédente est réussi
    final prevLessonId = '${categoryId}_lvl_${levelIndex}_lsn_${lessonIndex - 1}';
    return notifier.isLessonQuizPassed(prevLessonId);
  }

  bool get _quizPassed => notifier.isLessonQuizPassed(lesson.id);
  bool get _lessonDone => notifier.isLessonCompleted(lesson.id);

  @override
  Widget build(BuildContext context) {
    final accessible = _isLessonAccessible;
    final quizPassed = _quizPassed;
    final lessonDone = _lessonDone;

    Color rowColor;
    IconData stateIcon;
    if (quizPassed) {
      rowColor = AppColors.correctGreen;
      stateIcon = Icons.check_circle_rounded;
    } else if (lessonDone) {
      rowColor = AppColors.xpGold;
      stateIcon = Icons.quiz_rounded; // Leçon faite mais quiz pas encore passé
    } else if (accessible) {
      rowColor = AppColors.primary;
      stateIcon = Icons.play_circle_rounded;
    } else {
      rowColor = Colors.grey;
      stateIcon = Icons.lock_rounded;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.04)
              : rowColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: rowColor.withOpacity(accessible ? 0.3 : 0.12),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Icône état
            Icon(stateIcon, color: rowColor, size: 22),
            const SizedBox(width: 12),
            // Titre
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: accessible
                          ? (isDark ? Colors.white : AppColors.textPrimary)
                          : Colors.grey,
                      decoration: quizPassed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (quizPassed)
                    const Text('✅ Quiz réussi',
                        style: TextStyle(fontSize: 11, color: AppColors.correctGreen)),
                  if (lessonDone && !quizPassed)
                    const Text('🎯 Quiz requis pour continuer',
                        style: TextStyle(fontSize: 11, color: AppColors.xpGold)),
                  if (!lessonDone && accessible)
                    const Text('▶ Prêt à commencer',
                        style: TextStyle(fontSize: 11, color: AppColors.primary)),
                ],
              ),
            ),
            // Bouton action
            if (accessible && !quizPassed)
              _LessonActionButton(
                lessonDone: lessonDone,
                lessonId: lesson.id,
                lessonIndex: lessonIndex,
                levelIndex: levelIndex,
                categoryId: categoryId,
                languageId: languageId,
              ),
          ],
        ),
      ),
    );
  }
}

class _LessonActionButton extends StatelessWidget {
  final bool lessonDone;
  final String lessonId;
  final int lessonIndex;
  final int levelIndex;
  final String categoryId;
  final String languageId;

  const _LessonActionButton({
    required this.lessonDone,
    required this.lessonId,
    required this.lessonIndex,
    required this.levelIndex,
    required this.categoryId,
    required this.languageId,
  });

  @override
  Widget build(BuildContext context) {
    if (lessonDone) {
      // La leçon est faite mais le quiz pas encore passé → aller au quiz
      return ElevatedButton.icon(
        onPressed: () {
          context.pushNamed('quiz', queryParameters: {
            'languageId': languageId,
            'categoryId': categoryId,
            'levelIndex': levelIndex.toString(),
            'lessonIndex': lessonIndex.toString(),
            'lessonId': lessonId,
          });
        },
        icon: const Icon(Icons.quiz_rounded, size: 16),
        label: const Text('Quiz', style: TextStyle(fontSize: 13)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.xpGold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
      );
    }

    // Leçon pas encore faite → la commencer
    return ElevatedButton.icon(
      onPressed: () {
        context.pushNamed('lesson_content', pathParameters: {
          'languageId': languageId,
          'categoryId': categoryId,
          'levelIndex': levelIndex.toString(),
          'lessonIndex': lessonIndex.toString(),
        });
      },
      icon: const Icon(Icons.play_arrow_rounded, size: 16),
      label: const Text('Commencer', style: TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// _FinalQuizCard  —  Quiz final de l'unité (toujours visible en bas)
// ════════════════════════════════════════════════════════════════════
class _FinalQuizCard extends StatelessWidget {
  final bool isUnlocked;
  final bool isPassed;
  final int passedCount;
  final int totalCount;
  final String languageId;
  final String categoryId;
  final bool isDark;

  const _FinalQuizCard({
    required this.isUnlocked,
    required this.isPassed,
    required this.passedCount,
    required this.totalCount,
    required this.languageId,
    required this.categoryId,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // ── Cas 1 : Quiz final déjà réussi ──────────────────────────────
    if (isPassed) {
      return Container(
        margin: const EdgeInsets.only(top: 8, bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          children: [
            Text('🏆', style: TextStyle(fontSize: 40)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Unité complétée !',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('Félicitations 🎉 Tu maîtrises cette unité.',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ── Cas 2 : Débloqué — quiz prêt à passer ───────────────────────
    if (isUnlocked) {
      return Container(
        margin: const EdgeInsets.only(top: 8, bottom: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A56DB), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A56DB).withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              context.pushNamed('quiz', queryParameters: {
                'languageId': languageId,
                'categoryId': categoryId,
                'isUnitFinal': 'true',
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text('🎓', style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quiz Final de l\'Unité',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800)),
                        SizedBox(height: 4),
                        Text('Évaluation complète · 15 questions · tous niveaux',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.star_rounded,
                                color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text('Score requis : 70%',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ── Cas 3 : Verrouillé — progression en cours ──────────────────
    final ratio = totalCount > 0 ? passedCount / totalCount : 0.0;
    final remaining = totalCount - passedCount;

    return Opacity(
      opacity: 0.75,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isDark ? Colors.white12 : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_rounded,
                      color: Colors.grey, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quiz Final de l\'Unité',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade600),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        remaining == 0
                            ? 'Presque prêt...'
                            : '$remaining quiz restant${remaining > 1 ? 's' : ''} pour débloquer',
                        style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white38
                                : Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$passedCount/$totalCount',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white38
                          : Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Barre de progression
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 7,
                backgroundColor: isDark
                    ? Colors.white12
                    : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ratio >= 1.0
                      ? AppColors.correctGreen
                      : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Réussissez tous les quiz de leçon pour débloquer l\'évaluation finale',
              style: TextStyle(
                  fontSize: 11,
                  color:
                      isDark ? Colors.white30 : Colors.grey.shade400,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
