// lib/features/lessons/data/courses/colors_courses.dart
import '../../models/lesson_course.dart';

class ColorsCourses {
  static Map<String, List<LessonCourse>> all = {
    // ════════════════════════════════════
    // FRANÇAIS – COULEURS
    // ════════════════════════════════════
    'fr_cat_couleurs_fr': [
      LessonCourse(
        id: 'fr_colors_n1_c1', title: 'Les Couleurs Primaires',
        language: 'Français', category: 'Les couleurs', levelIndex: 0, courseIndex: 0,
        introduction: 'Le monde est plein de couleurs ! Nous commençons par les couleurs primaires et les bases (noir et blanc).',
        objectives: ['Identifier le Rouge, Bleu, Jaune', 'Connaître le Noir et le Blanc', 'Accorder la couleur avec le nom (masculin/féminin)'],
        vocabulary: [
          VocabItem(word: 'Rouge', pronunciation: 'ʁuʒ', definition: 'Couleur du sang et des fraises', example: 'Une pomme rouge.', imageUrl: 'https://images.unsplash.com/photo-1541339907198-e08756ebafe3?w=200&h=200&fit=crop'),
          VocabItem(word: 'Bleu', pronunciation: 'blø', definition: 'Couleur du ciel et de la mer', example: 'Le ciel est bleu.', imageUrl: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=200&h=200&fit=crop'),
          VocabItem(word: 'Jaune', pronunciation: 'ʒon', definition: 'Couleur du soleil', example: 'Un citron jaune.', imageUrl: 'https://images.unsplash.com/photo-1557683316-973673baf926?w=200&h=200&fit=crop'),
          VocabItem(word: 'Noir', pronunciation: 'nwaʁ', definition: 'Couleur de la nuit', example: 'Un chat noir.', imageUrl: 'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?w=200&h=200&fit=crop'),
          VocabItem(word: 'Blanc', pronunciation: 'blɑ̃', definition: 'Couleur de la neige', example: 'Un nuage blanc.', imageUrl: 'https://images.unsplash.com/photo-1505330622279-bf7d7fc918f4?w=200&h=200&fit=crop'),
        ],
        phoneticsExplanation: '• Rouge : le "ou" [u] est bien fermé.\n• Bleu : comme le "eu" de deux.\n• Blanc : le "c" est muet, sauf féminin (blanche).',
        usageExamples: ['"Le drapeau est bleu, blanc, rouge." → The flag is blue, white, red.', '"J\'adore le jaune !" → I love yellow!'],
        summaryPoints: ['Rouge, Bleu, Jaune = primaires', 'Noir et Blanc = neutres', 'L\'accord : Rouge (m/f), Bleu (m) / Bleue (f)'],
        learningMethod: 'Visuelle et artistique', estimatedDuration: '6 min', prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // ESPAGNOL – COULEURS
    // ════════════════════════════════════
    'es_cat_couleurs_es': [
      LessonCourse(
        id: 'es_colors_n1_c1', title: 'Los Colores Básicos',
        language: 'Espagnol', category: 'Les couleurs', levelIndex: 0, courseIndex: 0,
        introduction: '¡Hola! Les couleurs en espagnol sont très chantantes. Attention, elles s\'accordent souvent en genre et en nombre avec l\'objet.',
        objectives: ['Apprendre Roja, Azul, Amarilla', 'Identifier Negra y Blanca', 'Utiliser les couleurs dans des descriptions simples'],
        vocabulary: [
          VocabItem(word: 'Rojo / Roja', pronunciation: 'ˈroxo', definition: 'Couleur rouge', example: 'Un coche rojo.', imageUrl: 'https://images.unsplash.com/photo-1541339907198-e08756ebafe3?w=200&h=200&fit=crop'),
          VocabItem(word: 'Azul', pronunciation: 'aˈθul', definition: 'Couleur bleue', example: 'El mar azul.', imageUrl: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=200&h=200&fit=crop'),
          VocabItem(word: 'Amarillo', pronunciation: 'amaˈriʝo', definition: 'Couleur jaune', example: 'El sol amarillo.', imageUrl: 'https://images.unsplash.com/photo-1557683316-973673baf926?w=200&h=200&fit=crop'),
          VocabItem(word: 'Negro', pronunciation: 'ˈneɡɾo', definition: 'Couleur noire', example: 'Un perro negro.', imageUrl: 'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?w=200&h=200&fit=crop'),
          VocabItem(word: 'Blanco', pronunciation: 'ˈblaŋko', definition: 'Couleur blanche', example: 'Una casa blanca.', imageUrl: 'https://images.unsplash.com/photo-1505330622279-bf7d7fc918f4?w=200&h=200&fit=crop'),
        ],
        phoneticsExplanation: '• Rojo: la "j" se prononce comme une expiration forte au fond de la gorge.\n• Azul: le "z" se prononce [θ] en Espagne (comme think).\n• Amarillo: le "ll" se prononce comme un "y".',
        usageExamples: ['"La casa es blanca." → The house is white.', '"El cielo es azul." → The sky is blue.'],
        summaryPoints: ['Rojo, Azul, Amarillo', 'Negro y Blanco', 'Attention à l\'accord (o/a)'],
        learningMethod: 'Visuelle', estimatedDuration: '6 min', prerequisites: 'Aucun',
      ),
    ],
  };
}
