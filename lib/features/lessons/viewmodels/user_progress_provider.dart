import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_level.dart';

/// Clés de progression stockées dans SharedPreferences :
/// - 'lesson_done__{lessonId}'  → leçon vue/terminée
/// - 'quiz_done__{lessonId}'    → quiz de CETTE leçon réussi (≥70%)
/// - 'quiz_final__{catId}'      → quiz final d'unité réussi
class UserProgressNotifier extends Notifier<Set<String>> {
  static const _key = 'user_progress_v2';

  @override
  Set<String> build() {
    _load();
    return {};
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key) ?? [];
    state = Set<String>.from(saved);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, state.toList());
  }

  // ─── Leçon vue ────────────────────────────────────────────────────────────

  Future<void> markLessonAsCompleted(String lessonId) async {
    if (state.contains('lesson_done__$lessonId')) return;
    state = {...state, 'lesson_done__$lessonId'};
    await _persist();
  }

  bool isLessonCompleted(String lessonId) => state.contains('lesson_done__$lessonId');

  // ─── Quiz d'une leçon individuelle ────────────────────────────────────────

  /// Appelé par le QuizViewModel quand le score ≥ 70 %.
  Future<void> markLessonQuizPassed(String lessonId) async {
    final k = 'quiz_done__$lessonId';
    if (state.contains(k)) return;
    state = {...state, k};
    await _persist();
  }

  bool isLessonQuizPassed(String lessonId) => state.contains('quiz_done__$lessonId');

  // ─── Quiz final d'unité ────────────────────────────────────────────────────

  Future<void> markUnitQuizPassed({
    required String languageId,
    required String categoryId,
  }) async {
    final k = 'quiz_final__${languageId}__$categoryId';
    if (state.contains(k)) return;
    state = {...state, k};
    await _persist();
  }

  bool isUnitQuizPassed({
    required String languageId,
    required String categoryId,
  }) =>
      state.contains('quiz_final__${languageId}__$categoryId');

  // ─── Compatibilité ascendante (anciens appels) ─────────────────────────────

  Future<void> markLevelAsCompleted(CategoryLevel level) async {
    // Marque toutes les leçons du niveau comme vues
    for (final lesson in level.lessons) {
      await markLessonAsCompleted(lesson.id);
    }
  }

  /// Vérif : l'utilisateur peut-il accéder à la leçon [lessonIndex]
  /// du niveau [levelIndex] dans la catégorie [categoryId] ?
  /// Règle : leçon 0 → toujours libre ; leçon N → quiz de la leçon N-1 réussi.
  bool canAccessLesson({
    required String categoryId,
    required int levelIndex,
    required int lessonIndex,
  }) {
    if (lessonIndex == 0 && levelIndex == 0) return true;
    if (lessonIndex == 0) {
      // Première leçon du niveau : faut que quiz de la dernière leçon du niveau précédent soit passé
      final prevLevelLastLesson =
          '${categoryId}_lvl_${levelIndex - 1}_lsn_2'; // 3 leçons par niveau → index 2
      return isLessonQuizPassed(prevLevelLastLesson);
    }
    final prevLessonId = '${categoryId}_lvl_${levelIndex}_lsn_${lessonIndex - 1}';
    return isLessonQuizPassed(prevLessonId);
  }
}

final userProgressProvider = NotifierProvider<UserProgressNotifier, Set<String>>(
  () => UserProgressNotifier(),
);
