// lib/features/lessons/data/course_catalog.dart
import '../models/lesson_course.dart';
import 'courses/numbers_courses.dart';
import 'courses/greetings_courses.dart';
import 'courses/alphabet_courses.dart';
import 'courses/alphabet_fr_courses.dart';
import 'courses/colors_courses.dart';
import 'courses/french_courses.dart';

class CourseCatalog {
  /// Clé de lookup = languageId + '_' + categoryId
  static Map<String, List<LessonCourse>> get _allCourses => {
        ...NumbersCourses.all,
        ...GreetingsCourses.all,
        ...AlphabetCourses.all,
        ...AlphabetFrCourses.all,
        ...ColorsCourses.all,
        ...FrenchCourses.all,
      };

  // ─── Lookup principal ───────────────────────────────────────
  static List<LessonCourse> getCourses(String languageId, String categoryId) {
    // 1. Recherche exacte (ex: 'fr_cat_nombres_fr')
    final key = '${languageId}_$categoryId';
    if (_allCourses.containsKey(key)) return _allCourses[key]!;

    // 2. Recherche par type de catégorie EN RÉSERVANT la langue (ex: startsWith 'ar_')
    final categoryType = _extractCategoryType(categoryId);
    for (final entry in _allCourses.entries) {
      if (entry.key.startsWith('${languageId}_') &&
          _extractCategoryType(entry.key).contains(categoryType)) {
        return entry.value;
      }
    }

    // 3. Fallback générique dans la BONNE langue (pas d'emprunt à une autre langue)
    return _genericCourses(languageId, categoryId);
  }

  static String _extractCategoryType(String id) {
    for (final type in [
      'nombres',
      'alphabet',
      'salutations',
      'famille',
      'couleurs',
      'jours',
      'mois',
      'animaux',
      'aliments',
      'verbes'
    ]) {
      if (id.toLowerCase().contains(type)) return type;
    }
    return '';
  }

  // ─── Récupérer un cours spécifique ─────────────────────────
  static LessonCourse? getCourse(
      String languageId, String categoryId, int levelIndex, int courseIndex) {
    final courses = getCourses(languageId, categoryId);
    final idx = levelIndex * 3 + courseIndex;
    if (idx >= 0 && idx < courses.length) return courses[idx];
    if (courses.isNotEmpty) return courses[idx % courses.length];
    return null;
  }

  // ─── Cours générique de fallback localisé ───────────────────
  static List<LessonCourse> _genericCourses(String languageId, String categoryId) {
    final categoryType = _extractCategoryType(categoryId);
    final typeLabel = _typeToLabel(categoryType, languageId);

    // Dictionary for "Coming Soon" messages
    final Map<String, Map<String, String>> i18n = {
      'intro': {
        'fr': 'Introduction : $typeLabel',
        'en': 'Introduction: $typeLabel',
        'ar': 'مقدمة: $typeLabel',
        'es': 'Introducción: $typeLabel',
      },
      'desc': {
        'fr':
            'Ce cours vous introduit au thème "$typeLabel". Vous découvrirez le vocabulaire de base prochainement.',
        'en':
            'This course introduces you to "$typeLabel". You will discover the basic vocabulary soon.',
        'ar': 'هذه الدورة تقدم لك موضوع "$typeLabel". سوف تكتشف المفردات الأساسية قريباً.',
        'es':
            'Este curso te introduce al tema "$typeLabel". Descubrirás el vocabulario básico pronto.',
      },
      'soon': {
        'fr': 'Contenu complet disponible prochainement.',
        'en': 'Full content available soon.',
        'ar': 'المحتوى الكامل متاح قريباً.',
        'es': 'Contenido completo disponible pronto.',
      }
    };

    String t(String k) => i18n[k]?[languageId] ?? i18n[k]?['en'] ?? '';

    return [
      LessonCourse(
        id: '${languageId}_${categoryId}_generic',
        title: t('intro'),
        language: languageId,
        category: typeLabel,
        levelIndex: 0,
        courseIndex: 0,
        introduction: t('desc'),
        objectives: [t('soon')],
        vocabulary: [
          VocabItem(
            word: '—',
            pronunciation: '—',
            definition: t('soon'),
            example: '...',
          ),
        ],
        phoneticsExplanation: t('soon'),
        usageExamples: [t('soon')],
        summaryPoints: [t('soon')],
        learningMethod: '...',
        estimatedDuration: '5 min',
        prerequisites: '...',
      ),
    ];
  }

  static String _typeToLabel(String type, String languageId) {
    const Map<String, Map<String, String>> labels = {
      'nombres': {'fr': 'Les nombres', 'en': 'Numbers', 'ar': 'الأرقام', 'es': 'Números'},
      'alphabet': {'fr': 'L\'alphabet', 'en': 'Alphabet', 'ar': 'الأبجدية', 'es': 'Alfabeto'},
      'salutations': {'fr': 'Les salutations', 'en': 'Greetings', 'ar': 'التحيات', 'es': 'Saludos'},
      'famille': {'fr': 'La famille', 'en': 'Family', 'ar': 'العائلة', 'es': 'Familia'},
      'couleurs': {'fr': 'Les couleurs', 'en': 'Colors', 'ar': 'الألوان', 'es': 'Colores'},
      'jours': {'fr': 'Les jours', 'en': 'Days', 'ar': 'الأيام', 'es': 'Días'},
      'animaux': {'fr': 'Les animaux', 'en': 'Animals', 'ar': 'الحيوانات', 'es': 'Animales'},
      'aliments': {'fr': 'Les aliments', 'en': 'Food', 'ar': 'الطعام', 'es': 'Alimentos'},
      'verbes': {
        'fr': 'Les verbes de base',
        'en': 'Basic verbs',
        'ar': 'الأفعال الأساسية',
        'es': 'Verbos básicos'
      },
    };
    return labels[type]?[languageId] ?? labels[type]?['en'] ?? type;
  }
}
