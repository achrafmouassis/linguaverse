import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lesson_category.dart';
import '../models/category_level.dart';
import '../models/lesson.dart';
import 'user_progress_provider.dart';

String _translate(String key, String languageId) {
  final Map<String, Map<String, String>> translations = {
    'level': {
      'fr': 'Niveau', 'en': 'Level', 'ar': 'المستوى', 'es': 'Nivel', 'it': 'Livello', 'tr': 'Seviye', 'de': 'Stufe',
    },
    'lesson': {
      'fr': 'Leçon', 'en': 'Lesson', 'ar': 'الدرس', 'es': 'Lección', 'it': 'Lezione', 'tr': 'Ders', 'de': 'Lektion',
    },
    'cat_alphabet': {
      'fr': 'L\'alphabet', 'en': 'Alphabet', 'ar': 'الأبجدية', 'es': 'El Alfabeto', 'it': 'L\'Alfabeto', 'tr': 'Alfabe', 'de': 'Alphabet',
    },
    'method_alphabet': {
      'fr': 'Présentation visuelle et phonétique de chaque lettre',
      'en': 'Visual and phonetic presentation of each letter',
      'ar': 'عرض مرئي وصوتي لكل حرف',
      'es': 'Presentación visual y fonética de cada letra',
    },
    'cat_salutations': {
      'fr': 'Les salutations', 'en': 'Greetings', 'ar': 'التحيات', 'es': 'Saludos', 'it': 'Saluti', 'tr': 'Selamlaşma', 'de': 'Grüße',
    },
    'method_salutations': {
      'fr': 'Présentation des formules et usages courants',
      'en': 'Common expressions and usage',
      'ar': 'عرض التعبيرات والاستخدامات الشائعة',
      'es': 'Expresiones comunes y uso',
    },
    'cat_nombres': {
      'fr': 'Les nombres', 'en': 'Numbers', 'ar': 'الأرقام', 'es': 'Números', 'it': 'Numeri', 'tr': 'Sayılar', 'de': 'Zahlen',
    },
    'method_nombres': {
      'fr': 'Explications graduelles et exemples progressifs',
      'en': 'Gradual explanations and progressive examples',
      'ar': 'تفسيرات تدريجية وأمثلة تقدمية',
      'es': 'Explicaciones graduales y ejemplos progresivos',
    },
    'cat_famille': {
      'fr': 'La famille', 'en': 'Family', 'ar': 'العائلة', 'es': 'Familia', 'it': 'Famiglia', 'tr': 'Aile', 'de': 'Familie',
    },
    'method_famille': {
      'fr': 'Description des relations et vocabulaire contextuel',
      'en': 'Description of relationships and contextual vocabulary',
      'ar': 'وصف العلاقات والمفردات السياقية',
      'es': 'Descripción de relaciones y vocabulario contextual',
    },
    'cat_couleurs': {
      'fr': 'Les coureurs', 'en': 'Colors', 'ar': 'الألوان', 'es': 'Colores', 'it': 'Colori', 'tr': 'Renkler', 'de': 'Farben',
    },
    'method_couleurs': {
      'fr': 'Association de termes et illustrations',
      'en': 'Association of terms and illustrations',
      'ar': 'ربط المصطلحات والرسوم التوضيحية',
      'es': 'Asociación de términos e ilustraciones',
    },
  };

  return translations[key]?[languageId] ?? translations[key]?['en'] ?? key;
}

List<CategoryLevel> _generateMockLevels(String categoryId, int count, Set<String> completedIds, String languageId) {
  final levelLabel = _translate('level', languageId);
  final lessonLabel = _translate('lesson', languageId);

  return List.generate(count, (levelIndex) {
    return CategoryLevel(
      id: '${categoryId}_lvl_$levelIndex',
      levelIndex: levelIndex,
      title: '$levelLabel ${levelIndex + 1}',
      lessons: List.generate(3, (lessonIndex) {
        final lessonId = '${categoryId}_lvl_${levelIndex}_lsn_$lessonIndex';
        return Lesson(
          id: lessonId,
          title: '$lessonLabel ${lessonIndex + 1}',
          isCompleted: completedIds.contains(lessonId),
        );
      }),
    );
  });
}

final _baseCategoriesProvider = Provider.family<List<LessonCategory>, (String, Set<String>)>((ref, args) {
  final languageId = args.$1;
  final completedIds = args.$2;

  return [
    LessonCategory(
      id: 'cat_alphabet_$languageId',
      title: _translate('cat_alphabet', languageId),
      icon: Icons.abc_rounded,
      languageId: languageId,
      learningMethod: _translate('method_alphabet', languageId),
      levels: _generateMockLevels('cat_alphabet_$languageId', 5, completedIds, languageId),
    ),
    LessonCategory(
      id: 'cat_salutations_$languageId',
      title: _translate('cat_salutations', languageId),
      icon: Icons.waving_hand_rounded,
      languageId: languageId,
      learningMethod: _translate('method_salutations', languageId),
      levels: [
        CategoryLevel(
          id: 'cat_salutations_${languageId}_lvl_0',
          levelIndex: 0,
          title: '${_translate('level', languageId)} 1',
          lessons: [
            Lesson(id: 'lsn_s1', title: '${_translate('lesson', languageId)} 1', isCompleted: completedIds.contains('lsn_s1')),
            Lesson(id: 'lsn_s2', title: '${_translate('lesson', languageId)} 2', isCompleted: completedIds.contains('lsn_s2')),
            Lesson(id: 'lsn_s3', title: '${_translate('lesson', languageId)} 3', isCompleted: completedIds.contains('lsn_s3')),
          ],
        ),
        ..._generateMockLevels('cat_salutations_rest_$languageId', 4, completedIds, languageId),
      ],
    ),
    LessonCategory(
      id: 'cat_nombres_$languageId',
      title: _translate('cat_nombres', languageId),
      icon: Icons.looks_one_rounded,
      languageId: languageId,
      learningMethod: _translate('method_nombres', languageId),
      levels: _generateMockLevels('cat_nombres_$languageId', 5, completedIds, languageId),
    ),
    LessonCategory(
      id: 'cat_famille_$languageId',
      title: _translate('cat_famille', languageId),
      icon: Icons.family_restroom_rounded,
      languageId: languageId,
      learningMethod: _translate('method_famille', languageId),
      levels: _generateMockLevels('cat_famille_$languageId', 5, completedIds, languageId),
    ),
    LessonCategory(
      id: 'cat_couleurs_$languageId',
      title: _translate('cat_couleurs', languageId),
      icon: Icons.palette_rounded,
      languageId: languageId,
      learningMethod: _translate('method_couleurs', languageId),
      levels: _generateMockLevels('cat_couleurs_$languageId', 5, completedIds, languageId),
    ),
    LessonCategory(
      id: 'cat_jours_$languageId',
      title: 'Les jours',
      icon: Icons.calendar_today_rounded,
      languageId: languageId,
      learningMethod: 'Explications avec prononciation et contexte',
      levels: _generateMockLevels('cat_jours_$languageId', 5, completedIds, languageId),
    ),
    LessonCategory(
      id: 'cat_mois_$languageId',
      title: 'Les mois',
      icon: Icons.calendar_month_rounded,
      languageId: languageId,
      learningMethod: 'Description et exemples d\'utilisation',
      levels: _generateMockLevels('cat_mois_$languageId', 5, completedIds, languageId),
    ),
    LessonCategory(
      id: 'cat_animaux_$languageId',
      title: 'Les animaux',
      icon: Icons.pets_rounded,
      languageId: languageId,
      learningMethod: 'Présentation du vocabulaire et phrases types',
      levels: _generateMockLevels('cat_animaux_$languageId', 5, completedIds, languageId),
    ),
    LessonCategory(
      id: 'cat_aliments_$languageId',
      title: 'Les aliments',
      icon: Icons.restaurant_rounded,
      languageId: languageId,
      learningMethod: 'Vocabulaire et exemples de phrases simples',
      levels: _generateMockLevels('cat_aliments_$languageId', 5, completedIds, languageId),
    ),
    LessonCategory(
      id: 'cat_verbes_$languageId',
      title: 'Les verbes de base',
      icon: Icons.directions_run_rounded,
      languageId: languageId,
      learningMethod: 'Explication des conjugaisons et exemples',
      levels: _generateMockLevels('cat_verbes_$languageId', 5, completedIds, languageId),
    ),
  ];
});

final lessonCategoriesProvider = Provider.family<List<LessonCategory>, String>((ref, languageId) {
  final completedIds = ref.watch(userProgressProvider);
  final baseCategories = ref.watch(_baseCategoriesProvider((languageId, completedIds)));

  // Determine unlock state based on previous category completion
  List<LessonCategory> evaluatedCategories = [];
  bool isNextUnlocked = true; // First category is always unlocked

  for (final category in baseCategories) {
    evaluatedCategories.add(
      LessonCategory(
        id: category.id,
        title: category.title,
        icon: category.icon,
        languageId: category.languageId,
        learningMethod: category.learningMethod,
        levels: category.levels,
        isUnlocked: isNextUnlocked,
      ),
    );
    // Next category is unlocked only if this category is fully completed
    isNextUnlocked = category.isCompleted;
  }

  return evaluatedCategories;
});
