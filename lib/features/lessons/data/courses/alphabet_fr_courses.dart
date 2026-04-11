import '../../models/lesson_course.dart';

class AlphabetFrCourses {
  static Map<String, List<LessonCourse>> get all => {
        'fr_cat_alphabet_fr': [
          // Level 1: Core Vowels
          LessonCourse(
            id: 'fr_alphabet_lvl0',
            title: 'L\'alphabet : Les Voyelles fondamentales',
            language: 'fr',
            category: 'Alphabet',
            levelIndex: 0,
            courseIndex: 0,
            introduction: 'Bienvenue ! Dans cette première leçon, nous allons découvrir les voyelles de base de l\'alphabet français.',
            objectives: ['Identifier les voyelles A, E, I, O', 'Prononcer correctement chaque son'],
            vocabulary: [
              VocabItem(word: 'A', pronunciation: 'ah', definition: 'La première lettre de l\'alphabet.', example: 'Avion'),
              VocabItem(word: 'E', pronunciation: 'euh', definition: 'Une voyelle centrale très courante.', example: 'École'),
              VocabItem(word: 'I', pronunciation: 'ee', definition: 'Une voyelle tirée vers l\'arrière.', example: 'Île'),
              VocabItem(word: 'O', pronunciation: 'oh', definition: 'Une voyelle ronde.', example: 'Oiseau'),
            ],
            phoneticsExplanation: 'Le français utilise des voyelles pures. "A" se prononce toujours comme dans "Papa".',
            usageExamples: ['A comme Avion', 'E comme Éléphant'],
            summaryPoints: ['On a vu A, E, I, O.'],
            learningMethod: 'Phonétique visuelle',
            estimatedDuration: '5 min',
            prerequisites: 'Aucun',
          ),
          // Level 2
          LessonCourse(
            id: 'fr_alphabet_lvl1',
            title: 'Voyelles complexes et premières consonnes',
            language: 'fr',
            category: 'Alphabet',
            levelIndex: 1,
            courseIndex: 0,
            introduction: 'Continuons avec les voyelles restantes et les premières consonnes B et C.',
            objectives: ['U, Y, B, C'],
            vocabulary: [
              VocabItem(word: 'U', pronunciation: 'u', definition: 'Le son "u" français.', example: 'Univers'),
              VocabItem(word: 'Y', pronunciation: 'ee-grek', definition: 'Le i grec.', example: 'Yeux'),
              VocabItem(word: 'B', pronunciation: 'beh', definition: 'La première consonne.', example: 'Bateau'),
              VocabItem(word: 'C', pronunciation: 'seh', definition: 'Une consonne à deux sons.', example: 'Chat'),
            ],
            phoneticsExplanation: 'Le "U" se prononce avec les lèvres en avant.',
            usageExamples: ['U comme Usine', 'B comme Ballon'],
            summaryPoints: ['U, Y, B, C.'],
            learningMethod: 'Audio-visuel',
            estimatedDuration: '6 min',
            prerequisites: 'Niveau 1',
          ),
          // Add levels 3, 4, 5 if needed, but for MVP 1 and 2 are enough to show logic
        ],
      };
}
