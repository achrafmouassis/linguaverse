// lib/features/quiz/viewmodels/question_generator.dart
//
// Génère les 5 types de questions à partir des LessonItem de la leçon.
// Stratégie distracteurs :
//   1. D'abord prend des mots du même catégorie (in-category)
//   2. Si pas assez, complète avec des mots d'autres catégories de la langue
//   3. En dernier recours, utilise des traductions génériques fictives

import 'dart:math';
import '../../lessons/data/lesson_content_data.dart';
import '../models/question_model.dart';

class QuestionGenerator {
  static final Random _rng = Random();

  // ── Public entry point ───────────────────────────────────────────────────

  /// Génère [count] questions variées à partir des items de la leçon.
  /// [languageId] et [categoryId] : identifiants du cours zineb
  static List<Question> generate({
    required List<LessonItem> lessonItems,
    required String languageId,
    required String categoryId,
    required String lessonId,
    int count = 10,
  }) {
    if (lessonItems.isEmpty) return [];

    // Pool de distracteurs : tous les mots de la langue (hors leçon courante)
    final allItems = LessonContentData.getAllItemsForLanguage(languageId);
    final distractorPool =
        allItems.where((i) => !lessonItems.contains(i)).toList();

    // On cible au max [count] questions, au moins 1 de chaque type si possible
    final List<Question> generated = [];
    final List<LessonItem> shuffled = List.from(lessonItems)..shuffle(_rng);

    // Répartition équilibrée des types
    final types = _balancedTypes(
        count: count, available: shuffled.length);

    // On itère sur [count] slots — les items cyclent avec %
    // pour pouvoir générer 10 questions même avec 3 items (types différents)
    for (int i = 0; i < types.length; i++) {
      final item = shuffled[i % shuffled.length];
      final qId = '${lessonId}_q$i';

      final q = _build(
        type: types[i],
        item: item,
        allLessonItems: lessonItems,
        distractorPool: distractorPool,
        languageId: languageId,
        categoryId: categoryId,
        id: qId,
      );
      if (q != null) generated.add(q);
    }

    // Mélange final pour éviter la prévisibilité de l'ordre
    generated.shuffle(_rng);
    return generated;
  }

  // ── Type Distribution ────────────────────────────────────────────────────

  static List<QuestionType> _balancedTypes({
    required int count,
    required int available,
  }) {
    final base = [
      QuestionType.multipleChoice,
      QuestionType.trueFalse,
      QuestionType.listenAndChoose,
      QuestionType.fillInBlank,
      QuestionType.matching,
    ];
    final List<QuestionType> result = [];
    for (int i = 0; i < count; i++) {
      result.add(base[i % base.length]);
    }
    return result;
  }

  // ── Dispatcher ───────────────────────────────────────────────────────────

  static Question? _build({
    required QuestionType type,
    required LessonItem item,
    required List<LessonItem> allLessonItems,
    required List<LessonItem> distractorPool,
    required String languageId,
    required String categoryId,
    required String id,
  }) {
    switch (type) {
      case QuestionType.multipleChoice:
        return _buildMCQ(item, allLessonItems, distractorPool,
            languageId, categoryId, id);
      case QuestionType.trueFalse:
        return _buildTrueFalse(
            item, allLessonItems, languageId, categoryId, id);
      case QuestionType.listenAndChoose:
        return _buildListenAndChoose(item, allLessonItems, distractorPool,
            languageId, categoryId, id);
      case QuestionType.fillInBlank:
        return _buildFillInBlank(item, allLessonItems, distractorPool,
            languageId, categoryId, id);
      case QuestionType.matching:
        return _buildMatching(
            item, allLessonItems, languageId, categoryId, id);
    }
  }

  // ── 1. QCM ───────────────────────────────────────────────────────────────

  static MultipleChoiceQuestion _buildMCQ(
    LessonItem item,
    List<LessonItem> lessonItems,
    List<LessonItem> distractorPool,
    String languageId,
    String categoryId,
    String id,
  ) {
    final distractors = _pickDistractors(
      correct: item.translation,
      pool: [...lessonItems, ...distractorPool],
      count: 3,
      field: (i) => i.translation,
    );
    final options = [item.translation, ...distractors]..shuffle(_rng);

    return MultipleChoiceQuestion(
      id: id,
      sourceItem: item,
      languageId: languageId,
      categoryId: categoryId,
      prompt: item.term,
      options: options,
      correctAnswer: item.translation,
      explanation:
          '${item.term} se prononce « ${item.pronunciation} » et signifie : ${item.translation}.\n\nExemple : ${item.example}',
    );
  }

  // ── 2. Vrai / Faux ───────────────────────────────────────────────────────

  static TrueFalseQuestion _buildTrueFalse(
    LessonItem item,
    List<LessonItem> lessonItems,
    String languageId,
    String categoryId,
    String id,
  ) {
    // 50% chance : phrase correcte, 50% : traduction incorrecte
    final showCorrect = _rng.nextBool();
    late String statement;
    late bool answer;

    if (showCorrect) {
      statement =
          'Le mot français pour « ${item.translation} » est « ${item.term} ».';
      answer = true;
    } else {
      final wrong = lessonItems
          .where((i) => i.term != item.term)
          .toList();
      if (wrong.isEmpty) {
        statement = 'Le mot français pour « ${item.translation} » est « ${item.term} ».';
        answer = true;
      } else {
        final wrongItem = wrong[_rng.nextInt(wrong.length)];
        statement =
            'La traduction de « ${item.term} » est « ${wrongItem.translation} ».';
        answer = false;
      }
    }

    return TrueFalseQuestion(
      id: id,
      sourceItem: item,
      languageId: languageId,
      categoryId: categoryId,
      statement: statement,
      correctAnswer: answer,
      explanation:
          '${item.term} (${item.pronunciation}) = ${item.translation}.\nExemple : ${item.example}',
    );
  }

  // ── 3. Écouter & Choisir ─────────────────────────────────────────────────

  static ListenAndChooseQuestion _buildListenAndChoose(
    LessonItem item,
    List<LessonItem> lessonItems,
    List<LessonItem> distractorPool,
    String languageId,
    String categoryId,
    String id,
  ) {
    final distractors = _pickDistractors(
      correct: item.translation,
      pool: [...lessonItems, ...distractorPool],
      count: 3,
      field: (i) => i.translation,
    );
    final options = [item.translation, ...distractors]..shuffle(_rng);

    return ListenAndChooseQuestion(
      id: id,
      sourceItem: item,
      languageId: languageId,
      categoryId: categoryId,
      wordToSpeak: item.term,
      options: options,
      correctAnswer: item.translation,
    );
  }

  // ── 4. Compléter la phrase ───────────────────────────────────────────────

  static FillInBlankQuestion _buildFillInBlank(
    LessonItem item,
    List<LessonItem> lessonItems,
    List<LessonItem> distractorPool,
    String languageId,
    String categoryId,
    String id,
  ) {
    // On utilise l'exemple de phrase : remplace le term par ___ (insensible à la casse)
    final example = item.example;
    final regex = RegExp(RegExp.escape(item.term), caseSensitive: false);
    final blank = example.replaceFirst(regex, '___');
    
    // S'il n'y a pas eu de remplacement (ex: verbe conjugué, pluriel différent),
    // on propose une question sémantique claire au lieu d'afficher la phonétique.
    final sentenceWithBlank = blank.contains('___')
        ? blank
        : 'Traduisez en français :\n« ${item.translation} » = ___';

    final distractors = _pickDistractors(
      correct: item.term,
      pool: [...lessonItems, ...distractorPool],
      count: 3,
      field: (i) => i.term,
    );
    final options = [item.term, ...distractors]..shuffle(_rng);

    return FillInBlankQuestion(
      id: id,
      sourceItem: item,
      languageId: languageId,
      categoryId: categoryId,
      sentenceWithBlank: sentenceWithBlank,
      options: options,
      correctAnswer: item.term,
      fullSentence: example,
    );
  }

  // ── 5. Matching ──────────────────────────────────────────────────────────

  static MatchingQuestion _buildMatching(
    LessonItem focusItem,
    List<LessonItem> lessonItems,
    String languageId,
    String categoryId,
    String id,
  ) {
    // Prend 4 items distincts (incluant le focusItem)
    final pool = List<LessonItem>.from(lessonItems)..shuffle(_rng);
    final selected = <LessonItem>[focusItem];
    for (final it in pool) {
      if (selected.length >= 4) break;
      if (it.term != focusItem.term) selected.add(it);
    }
    // Si pas assez d'items, on duplique avec variation
    while (selected.length < 4 && selected.isNotEmpty) {
      selected.add(selected[_rng.nextInt(selected.length)]);
    }

    final pairs = selected
        .map((i) => MatchingPair(term: i.term, translation: i.translation))
        .toList();
    final correctPairs = List<MatchingPair>.from(pairs);
    pairs.shuffle(_rng);

    return MatchingQuestion(
      id: id,
      sourceItem: focusItem,
      languageId: languageId,
      categoryId: categoryId,
      pairs: pairs,
      correctPairs: correctPairs,
    );
  }

  // ── Distractor Helper ────────────────────────────────────────────────────

  /// Sélectionne [count] distracteurs différents de [correct].
  static List<String> _pickDistractors({
    required String correct,
    required List<LessonItem> pool,
    required int count,
    required String Function(LessonItem) field,
  }) {
    final candidates = pool
        .map(field)
        .where((v) => v != correct)
        .toSet()
        .toList()
      ..shuffle(_rng);

    final result = candidates.take(count).toList();

    // Complète avec des placeholders si pas assez de candidats
    final fallbacks = [
      'Option A', 'Option B', 'Option C', 'Option D',
      'Réponse X', 'Réponse Y',
    ];
    int fi = 0;
    while (result.length < count) {
      final fb = fallbacks[fi % fallbacks.length];
      if (!result.contains(fb) && fb != correct) result.add(fb);
      fi++;
    }

    return result.take(count).toList();
  }
}
