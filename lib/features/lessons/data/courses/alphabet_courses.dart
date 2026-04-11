// lib/features/lessons/data/courses/alphabet_courses.dart
import '../../models/lesson_course.dart';

class AlphabetCourses {
  static Map<String, List<LessonCourse>> all = {
    // ════════════════════════════════════
    // FRANÇAIS – ALPHABET
    // ════════════════════════════════════
    'fr_cat_alphabet_fr': [
      LessonCourse(
        id: 'fr_alphabet_n1_c1', title: 'Les Voyelles',
        language: 'Français', category: 'L\'alphabet', levelIndex: 0, courseIndex: 0,
        introduction: 'Bienvenue dans l\'alphabet français ! Nous commençons par les voyelles (A, E, I, O, U, Y). Elles sont le cœur de la prononciation française car elles portent les sons les plus variés.',
        objectives: ['Identifier et prononcer les 6 voyelles', 'Comprendre la différence entre le nom de la lettre et son son', 'Trouver ces lettres dans des mots simples'],
        vocabulary: [
          VocabItem(word: 'A', pronunciation: 'a', definition: 'Première lettre', example: 'Avion, Ami, Arbre.', imageUrl: 'https://images.unsplash.com/photo-1590117469032-68045952f534?w=200&h=200&fit=crop'),
          VocabItem(word: 'E', pronunciation: 'ə / e', definition: 'Voyelle la plus fréquente', example: 'Ecole, Elève, Enfant.', imageUrl: 'https://images.unsplash.com/photo-1596495573105-d14658dc1b61?w=200&h=200&fit=crop'),
          VocabItem(word: 'I', pronunciation: 'i', definition: 'Voyelle fine', example: 'Ile, Image, Idée.', imageUrl: 'https://images.unsplash.com/photo-1596496356921-90376229502b?w=200&h=200&fit=crop'),
          VocabItem(word: 'O', pronunciation: 'o', definition: 'Voyelle ronde', example: 'Orange, Oiseau, Oreille.', imageUrl: 'https://images.unsplash.com/photo-1590117469032-68045952f534?w=200&h=200&fit=crop'),
          VocabItem(word: 'U', pronunciation: 'y', definition: 'Son typique français', example: 'Usine, Univers, Unité.', imageUrl: 'https://images.unsplash.com/photo-1596495573105-d14658dc1b61?w=200&h=200&fit=crop'),
        ],
        phoneticsExplanation: '• "A" : bouche bien ouverte.\n• "E" : peut être muet, ouvert ou fermé.\n• "I" : comme le "ee" anglais dans "see".\n• "U" : son unique, lèvres en cœur, avancez la langue.',
        usageExamples: ['"A comme Avion" → A for Airplane.', '"E comme Elephant" → E for Elephant.', '"I comme Island" → I for Ile.'],
        summaryPoints: ['6 voyelles : A E I O U Y', 'Le U est le son le plus difficile', 'Le E change souvent de son'],
        learningMethod: 'Auditive et visuelle', estimatedDuration: '5 min', prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // ARABE – ALPHABET
    // ════════════════════════════════════
    'ar_cat_alphabet_ar': [
      LessonCourse(
        id: 'ar_alphabet_n1_c1', title: 'Les premières lettres : أ ب ت ث',
        language: 'Arabe', category: 'L\'alphabet', levelIndex: 0, courseIndex: 0,
        introduction: 'Prêt à découvrir l\'une des plus belles écritures au monde ? L\'arabe s\'écrit de droite à gauche. Nous commençons par les quatre premières lettres.',
        objectives: ['Reconnaître أ, ب, ت, ث', 'Prononcer chaque lettre correctement', 'Comprendre que les lettres changent de forme selon leur position'],
        vocabulary: [
          VocabItem(word: 'أ (Alif)', pronunciation: 'ā', definition: 'Première lettre', example: 'أَسَد (asad) = lion', imageUrl: 'https://images.unsplash.com/photo-1552053831-71594a27632d?w=200&h=200&fit=crop'),
          VocabItem(word: 'ب (Ba)', pronunciation: 'b', definition: 'Deuxième lettre', example: 'بَيْت (bayt) = maison', imageUrl: 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=200&h=200&fit=crop'),
          VocabItem(word: 'ت (Ta)', pronunciation: 't', definition: 'Troisième lettre', example: 'تُفَّاح (tuffāḥ) = pomme', imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=200&h=200&fit=crop'),
          VocabItem(word: 'ث (Tha)', pronunciation: 'th', definition: 'Quatrième lettre', example: 'ثَعْلَب (thaʿlab) = renard', imageUrl: 'https://images.unsplash.com/photo-1516934024742-b461fba47600?w=200&h=200&fit=crop'),
        ],
        phoneticsExplanation: '• أ : Sert souvent de support à la voyelle.\n• ب : Comme le "b" de bébé.\n• ت : Comme le "t" de thé.\n• ث : Comme le "th" anglais dans "think".',
        usageExamples: ['"أ كما في أسد" → Alif comme dans Asad (lion).', '"ب كما في بيت" → Ba comme dans Bayt (maison).'],
        summaryPoints: ['Ecriture de droite à gauche', '4 lettres apprises сегодня', 'Point Unique : ث a 3 points !'],
        learningMethod: 'Visuelle et calligraphique', estimatedDuration: '10 min', prerequisites: 'Aucun',
      ),
    ],
  };
}
