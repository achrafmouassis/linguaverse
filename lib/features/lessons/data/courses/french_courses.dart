// lib/features/lessons/data/courses/french_courses.dart
// Contenu complet des leçons françaises pour toutes les catégories
import '../../models/lesson_course.dart';

class FrenchCourses {
  static Map<String, List<LessonCourse>> all = {
    // ════════════════════════════════════
    // FRANÇAIS – FAMILLE
    // ════════════════════════════════════
    'fr_cat_famille_fr': [
      const LessonCourse(
        id: 'fr_famille_n1_c1',
        title: 'La famille proche',
        language: 'Français',
        category: 'La famille',
        levelIndex: 0,
        courseIndex: 0,
        introduction:
            'La famille est au cœur de la culture française. Dans ce cours, vous apprendrez le vocabulaire essentiel pour parler de vos proches : parents, frères, sœurs et grands-parents. Ces mots s\'utilisent tous les jours dans la conversation courante.',
        objectives: [
          'Nommer les membres directs de la famille en français',
          'Comprendre le genre (masculin/féminin) des mots de la famille',
          'Utiliser les adjectifs possessifs : mon, ma, mes',
        ],
        vocabulary: [
          VocabItem(
            word: 'Le père',
            pronunciation: '[lə.pɛʁ]',
            definition: 'Le parent masculin',
            example: 'Mon père est ingénieur.',
          ),
          VocabItem(
            word: 'La mère',
            pronunciation: '[la.mɛʁ]',
            definition: 'Le parent féminin',
            example: 'Ma mère enseigne le français.',
          ),
          VocabItem(
            word: 'Le frère',
            pronunciation: '[lə.fʁɛʁ]',
            definition: 'L\'enfant masculin des mêmes parents',
            example: 'J\'ai deux frères, Lucas et Tom.',
          ),
          VocabItem(
            word: 'La sœur',
            pronunciation: '[la.sœʁ]',
            definition: 'L\'enfant féminin des mêmes parents',
            example: 'Ma sœur s\'appelle Léa.',
          ),
          VocabItem(
            word: 'Le grand-père',
            pronunciation: '[lə.gʁɑ̃.pɛʁ]',
            definition: 'Le père du père ou de la mère',
            example: 'Mon grand-père habite en Bretagne.',
          ),
          VocabItem(
            word: 'La grand-mère',
            pronunciation: '[la.gʁɑ̃.mɛʁ]',
            definition: 'La mère du père ou de la mère',
            example: 'Ma grand-mère fait d\'excellentes tartes.',
          ),
          VocabItem(
            word: 'L\'oncle',
            pronunciation: '[lɔ̃kl]',
            definition: 'Le frère du père ou de la mère',
            example: 'Mon oncle vit à Bordeaux.',
          ),
          VocabItem(
            word: 'La tante',
            pronunciation: '[la.tɑ̃t]',
            definition: 'La sœur du père ou de la mère',
            example: 'Ma tante m\'offre toujours des cadeaux.',
          ),
          VocabItem(
            word: 'Le fils',
            pronunciation: '[lə.fis]',
            definition: 'L\'enfant masculin',
            example: 'Voici mon fils, il a 12 ans.',
          ),
          VocabItem(
            word: 'La fille',
            pronunciation: '[la.fij]',
            definition: 'L\'enfant féminin',
            example: 'Sa fille est médecin.',
          ),
        ],
        phoneticsExplanation: '• "Père/mère" : le è [ɛ] est ouvert, comme dans "faire".\n'
            '• "Sœur" [sœʁ] : le œ est arrondi — un son entre "eu" et "è".\n'
            '• "Grand-père" : le d de "grand" est muet, mais avec liaison [gʁɑ̃.t‿pɛʁ].\n'
            '• "Oncle" [ɔ̃kl] : o nasalisé + kl final sans voyelle épenthétique.\n'
            '• "Fils" [fis] : le l est muet ! On prononce [fis] comme "fiss".',
        usageExamples: [
          '"J\'ai une grande famille : deux frères et une sœur." → I have a big family: two brothers and one sister.',
          '"Mon père et ma mère habitent à Paris." → My father and mother live in Paris.',
          '"Mes grands-parents viennent nous rendre visite ce week-end." → My grandparents are coming to visit this weekend.',
          '"Comment s\'appelle ta sœur ?" → What is your sister\'s name?',
        ],
        summaryPoints: [
          'Père (m) / Mère (f) — les parents',
          'Frère (m) / Sœur (f) — les frères et sœurs',
          'Grand-père / Grand-mère — les aïeuls',
          'Fils [fis] — le l est muet !',
          'Mon (m) / Ma (f) / Mes (pl) — adjectifs possessifs',
        ],
        learningMethod: 'Contextuelle + familiale',
        estimatedDuration: '7 min',
        prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // FRANÇAIS – JOURS DE LA SEMAINE
    // ════════════════════════════════════
    'fr_cat_jours_fr': [
      const LessonCourse(
        id: 'fr_jours_n1_c1',
        title: 'Les jours de la semaine',
        language: 'Français',
        category: 'Les jours',
        levelIndex: 0,
        courseIndex: 0,
        introduction:
            'Savoir nommer les jours de la semaine est fondamental pour organiser sa vie en français : rendez-vous, planification, réservations... En français, les jours de la semaine s\'écrivent toujours en minuscule (sauf en début de phrase).',
        objectives: [
          'Mémoriser les 7 jours de la semaine et leur ordre',
          'Comprendre que les jours sont tous masculins en français',
          'Construire des phrases avec "le lundi", "ce jeudi", "hier"…',
        ],
        vocabulary: [
          VocabItem(
            word: 'Lundi',
            pronunciation: '[lœ̃.di]',
            definition: 'Premier jour de la semaine (Monday)',
            example: 'Le lundi, je vais à la gym.',
          ),
          VocabItem(
            word: 'Mardi',
            pronunciation: '[maʁ.di]',
            definition: 'Deuxième jour (Tuesday)',
            example: 'On se retrouve mardi midi ?',
          ),
          VocabItem(
            word: 'Mercredi',
            pronunciation: '[mɛʁ.kʁe.di]',
            definition: 'Troisième jour (Wednesday)',
            example: 'Mercredi, les enfants n\'ont pas école.',
          ),
          VocabItem(
            word: 'Jeudi',
            pronunciation: '[ʒø.di]',
            definition: 'Quatrième jour (Thursday)',
            example: 'Jeudi soir, on va au théâtre.',
          ),
          VocabItem(
            word: 'Vendredi',
            pronunciation: '[vɑ̃.dʁe.di]',
            definition: 'Cinquième jour (Friday)',
            example: 'Vendredi c\'est le dernier jour de travail !',
          ),
          VocabItem(
            word: 'Samedi',
            pronunciation: '[sam.di]',
            definition: 'Sixième jour — le week-end commence (Saturday)',
            example: 'Samedi matin, marché et brioche.',
          ),
          VocabItem(
            word: 'Dimanche',
            pronunciation: '[di.mɑ̃ʃ]',
            definition: 'Septième jour — jour de repos (Sunday)',
            example: 'Dimanche, toute la famille se réunit.',
          ),
          VocabItem(
            word: 'Aujourd\'hui',
            pronunciation: '[o.ʒuʁ.dɥi]',
            definition: 'Le jour présent (Today)',
            example: 'Aujourd\'hui, c\'est lundi 28 avril.',
          ),
          VocabItem(
            word: 'Demain',
            pronunciation: '[də.mɛ̃]',
            definition: 'Le jour suivant (Tomorrow)',
            example: 'À demain, bonne soirée !',
          ),
          VocabItem(
            word: 'Hier',
            pronunciation: '[jɛʁ]',
            definition: 'Le jour précédent (Yesterday)',
            example: 'Hier, il faisait très beau.',
          ),
        ],
        phoneticsExplanation: '• "Lundi" [lœ̃.di] : "un" est une voyelle nasale [œ̃].\n'
            '• "Mercredi" [mɛʁ.kʁe.di] : 4 syllabes bien distinctes.\n'
            '• "Vendredi" [vɑ̃.dʁe.di] : "en" nasalisé [ɑ̃] + "dr" groupe consonantique.\n'
            '• "Dimanche" [di.mɑ̃ʃ] : "an" nasalisé + finale "che" [ʃ].\n'
            '• "Aujourd\'hui" : mot long, 4 syllabes [o-ʒuʁ-dɥi], le y est une semi-voyelle.',
        usageExamples: [
          '"Le lundi, il travaille de 9h à 17h." → On Mondays, he works from 9am to 5pm.',
          '"Ce vendredi, on sort au restaurant." → This Friday, we\'re going out to a restaurant.',
          '"Hier c\'était mercredi." → Yesterday was Wednesday.',
          '"Tu es libre samedi ?" → Are you free on Saturday?',
        ],
        summaryPoints: [
          'Lundi, Mardi, Mercredi, Jeudi, Vendredi = jours de semaine',
          'Samedi, Dimanche = le week-end',
          '"Le lundi" (avec article) = tous les lundis (habitude)',
          '"Ce lundi" = ce lundi précis',
          'Tous les jours sont masculins en français',
        ],
        learningMethod: 'Sequential + mémo',
        estimatedDuration: '6 min',
        prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // FRANÇAIS – ANIMAUX
    // ════════════════════════════════════
    'fr_cat_animaux_fr': [
      const LessonCourse(
        id: 'fr_animaux_n1_c1',
        title: 'Les animaux du quotidien',
        language: 'Français',
        category: 'Les animaux',
        levelIndex: 0,
        courseIndex: 0,
        introduction:
            'Les animaux occupent une grande place dans la langue française : dans les expressions idiomatiques, la littérature et la vie quotidienne. Ce cours vous présente les animaux les plus courants, leurs noms et quelques curiosités !',
        objectives: [
          'Nommer 10 animaux courants en français',
          'Reconnaître le genre (le/la) de chaque animal',
          'Utiliser les noms d\'animaux dans des phrases simples',
        ],
        vocabulary: [
          VocabItem(
            word: 'Le chien',
            pronunciation: '[lə.ʃjɛ̃]',
            definition: 'Animal domestique (dog)',
            example: 'Mon chien s\'appelle Médor.',
          ),
          VocabItem(
            word: 'Le chat',
            pronunciation: '[lə.ʃa]',
            definition: 'Petit félin domestique (cat)',
            example: 'Le chat dort 16h par jour.',
          ),
          VocabItem(
            word: 'L\'oiseau',
            pronunciation: '[lwa.zo]',
            definition: 'Animal à plumes et à ailes (bird)',
            example: 'L\'oiseau chante dans le jardin.',
          ),
          VocabItem(
            word: 'Le cheval',
            pronunciation: '[lə.ʃval]',
            definition: 'Équidé domestique (horse)',
            example: 'Le cheval galope dans la prairie.',
          ),
          VocabItem(
            word: 'La vache',
            pronunciation: '[la.vaʃ]',
            definition: 'Bovin femelle qui donne du lait (cow)',
            example: 'La vache broute dans le pré.',
          ),
          VocabItem(
            word: 'Le lapin',
            pronunciation: '[lə.la.pɛ̃]',
            definition: 'Petit mammifère aux longues oreilles (rabbit)',
            example: 'Le lapin aime les carottes et la salade.',
          ),
          VocabItem(
            word: 'Le poisson',
            pronunciation: '[lə.pwa.sɔ̃]',
            definition: 'Animal aquatique (fish)',
            example: 'Le poisson rouge nage en cercle.',
          ),
          VocabItem(
            word: 'L\'éléphant',
            pronunciation: '[le.le.fɑ̃]',
            definition: 'Le plus grand mammifère terrestre (elephant)',
            example: 'L\'éléphant possède une excellente mémoire.',
          ),
          VocabItem(
            word: 'Le lion',
            pronunciation: '[lə.ljɔ̃]',
            definition: 'Roi des animaux (lion)',
            example: 'Le lion rugit pour marquer son territoire.',
          ),
          VocabItem(
            word: 'Le canard',
            pronunciation: '[lə.ka.naʁ]',
            definition: 'Oiseau aquatique (duck)',
            example: 'Le canard barbote dans la mare.',
          ),
        ],
        phoneticsExplanation:
            '• "Chien" [ʃjɛ̃] : "ch" = [ʃ] + "ien" = deux sons [jɛ̃] avec nasale finale.\n'
            '• "Oiseau" [wazo] : diphtongue "oi" = [wa] + "eau" = [o].\n'
            '• "Cheval" [ʃval] : pas de voyelle entre ch et v en français !\n'
            '• "Éléphant" : 3 syllabes [e.le.fɑ̃], "ph" = [f].\n'
            '• "Lapin" [lapɛ̃] : nasale finale "in" = [ɛ̃].',
        usageExamples: [
          '"J\'ai un chat et un chien à la maison." → I have a cat and a dog at home.',
          '"Le lion est le roi de la savane." → The lion is the king of the savanna.',
          '"Regarde cet oiseau magnifique !" → Look at that beautiful bird!',
          '"Mon fils adore les éléphants." → My son loves elephants.',
        ],
        summaryPoints: [
          'Chien/chat — animaux de compagnie les plus courants',
          '"L\'oiseau" : élision de le + oiseau (voyelle initiale)',
          'Cheval → chevaux au pluriel (irrégulier)',
          'Éléphant — "ph" se prononce [f] en français',
          'Expression : "Donner sa langue au chat" = abandonner, ne pas trouver la réponse',
        ],
        learningMethod: 'Visuelle + anecdotes',
        estimatedDuration: '7 min',
        prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // FRANÇAIS – ALIMENTS
    // ════════════════════════════════════
    'fr_cat_aliments_fr': [
      const LessonCourse(
        id: 'fr_aliments_n1_c1',
        title: 'Les aliments de base',
        language: 'Français',
        category: 'Les aliments',
        levelIndex: 0,
        courseIndex: 0,
        introduction:
            'La gastronomie est un pilier de la culture française ! Maîtriser le vocabulaire des aliments vous permettra de commander au restaurant, faire vos courses et discuter de cuisine. Ce cours couvre les aliments du quotidien.',
        objectives: [
          'Nommer 10 aliments essentiels en français',
          'Utiliser les articles partitifs : du, de la, de l\'',
          'Construire des phrases autour des repas',
        ],
        vocabulary: [
          VocabItem(
            word: 'Le pain',
            pronunciation: '[lə.pɛ̃]',
            definition: 'Aliment de base à base de farine (bread)',
            example: 'Une baguette de pain fraîche du boulanger.',
          ),
          VocabItem(
            word: 'Le lait',
            pronunciation: '[lə.lɛ]',
            definition: 'Boisson blanche du vache (milk)',
            example: 'Je bois un verre de lait le matin.',
          ),
          VocabItem(
            word: 'Le café',
            pronunciation: '[lə.ka.fe]',
            definition: 'Boisson chaude populaire (coffee)',
            example: 'Un petit café noir, s\'il vous plaît.',
          ),
          VocabItem(
            word: 'La pomme',
            pronunciation: '[la.pɔm]',
            definition: 'Fruit rouge ou vert (apple)',
            example: 'Une pomme par jour éloigne le médecin.',
          ),
          VocabItem(
            word: 'Le fromage',
            pronunciation: '[lə.fʁo.maʒ]',
            definition: 'Produit laitier fermenté (cheese)',
            example: 'La France produit plus de 1000 fromages !',
          ),
          VocabItem(
            word: 'Le poulet',
            pronunciation: '[lə.pu.lɛ]',
            definition: 'Viande de volaille (chicken)',
            example: 'Du poulet rôti aux herbes ce soir.',
          ),
          VocabItem(
            word: 'L\'eau',
            pronunciation: '[lo]',
            definition: 'Boisson essentielle, liquide transparent (water)',
            example: 'Boire au moins 1,5 L d\'eau par jour.',
          ),
          VocabItem(
            word: 'Le riz',
            pronunciation: '[lə.ʁi]',
            definition: 'Céréale de base (rice)',
            example: 'Du riz basmati avec des légumes sautés.',
          ),
          VocabItem(
            word: 'La tomate',
            pronunciation: '[la.tɔ.mat]',
            definition: 'Fruit rouge utilisé comme légume (tomato)',
            example: 'Une salade de tomates à l\'huile d\'olive.',
          ),
          VocabItem(
            word: 'Le chocolat',
            pronunciation: '[lə.ʃɔ.kɔ.la]',
            definition: 'Confiserie au cacao (chocolate)',
            example: 'Un carré de chocolat noir à 85%.',
          ),
        ],
        phoneticsExplanation:
            '• "Pain" [pɛ̃] : "ain" est une voyelle nasale, pas deux sons séparés.\n'
            '• "Lait" [lɛ] : "ai" = [ɛ] ouvert, le t final est muet.\n'
            '• "Fromage" [fʁo.maʒ] : "ge" final = [ʒ] sonore.\n'
            '• "L\'eau" : élision obligatoire, "eau" = [o] long.\n'
            '• "Chocolat" [ʃɔ.kɔ.la] : t final muet, 3 syllabes.',
        usageExamples: [
          '"Je voudrais du pain et du fromage, s\'il vous plaît." → I would like some bread and cheese, please.',
          '"Tu veux du café ou du thé ?" → Do you want coffee or tea?',
          '"Elle mange une pomme tous les matins." → She eats an apple every morning.',
          '"Le chocolat chaud est parfait en hiver." → Hot chocolate is perfect in winter.',
        ],
        summaryPoints: [
          'Article partitif : du (m), de la (f), de l\' (voyelle)',
          'Pain [pɛ̃] — nasal, t final muet',
          'La gastronomie française est reconnue mondialement',
          'Fromage → pluriel : des fromages',
          '"Bon appétit !" — formule polie avant de manger',
        ],
        learningMethod: 'Contextuelle + gastronomique',
        estimatedDuration: '8 min',
        prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // FRANÇAIS – VERBES DE BASE
    // ════════════════════════════════════
    'fr_cat_verbes_fr': [
      const LessonCourse(
        id: 'fr_verbes_n1_c1',
        title: 'Les verbes essentiels',
        language: 'Français',
        category: 'Les verbes de base',
        levelIndex: 0,
        courseIndex: 0,
        introduction:
            'Les verbes sont le moteur de la phrase française. Dans ce cours, vous découvrirez les 10 verbes les plus utilisés au quotidien. Maîtriser ces verbes vous permettra de construire des centaines de phrases utiles.',
        objectives: [
          'Reconnaître et utiliser 10 verbes fondamentaux',
          'Conjuguer au présent avec "je/tu/il/nous"',
          'Construire des phrases simples et naturelles',
        ],
        vocabulary: [
          VocabItem(
            word: 'Être',
            pronunciation: '[ɛtʁ]',
            definition: 'To be — verbe d\'état fondamental',
            example: 'Je suis étudiant. Elle est médecin.',
          ),
          VocabItem(
            word: 'Avoir',
            pronunciation: '[a.vwaʁ]',
            definition: 'To have — possession et auxiliaire',
            example: 'J\'ai deux sœurs. Nous avons faim.',
          ),
          VocabItem(
            word: 'Aller',
            pronunciation: '[a.le]',
            definition: 'To go — déplacement et futur proche',
            example: 'Je vais à Paris. On va manger.',
          ),
          VocabItem(
            word: 'Faire',
            pronunciation: '[fɛʁ]',
            definition: 'To do / make — action générale',
            example: 'Tu fais quoi ce soir ? Je fais la cuisine.',
          ),
          VocabItem(
            word: 'Manger',
            pronunciation: '[mɑ̃.ʒe]',
            definition: 'To eat',
            example: 'Nous mangeons à midi en famille.',
          ),
          VocabItem(
            word: 'Boire',
            pronunciation: '[bwaʁ]',
            definition: 'To drink',
            example: 'Il boit un verre d\'eau chaque matin.',
          ),
          VocabItem(
            word: 'Parler',
            pronunciation: '[paʁ.le]',
            definition: 'To speak/talk',
            example: 'Elle parle couramment l\'anglais et le français.',
          ),
          VocabItem(
            word: 'Aimer',
            pronunciation: '[ɛ.me]',
            definition: 'To love / to like',
            example: 'J\'aime le cinéma et la musique.',
          ),
          VocabItem(
            word: 'Vouloir',
            pronunciation: '[vu.lwaʁ]',
            definition: 'To want — exprime un désir',
            example: 'Je veux apprendre le français !',
          ),
          VocabItem(
            word: 'Dormir',
            pronunciation: '[dɔʁ.miʁ]',
            definition: 'To sleep',
            example: 'Il faut dormir 8 heures par nuit.',
          ),
        ],
        phoneticsExplanation: '• "Être" [ɛtʁ] : "ê" ouvert [ɛ] + groupe "tr".\n'
            '• "Avoir" [a.vwaʁ] : "oi" = diphtongue [wa].\n'
            '• "Faire" [fɛʁ] : como "fère", guttural r final.\n'
            '• "Manger" [mɑ̃.ʒe] : "an" nasalisé + "ger" = [ʒe].\n'
            '• "Vouloir" [vu.lwaʁ] : attention, "ou" = [u] puis "oi" = [wa].',
        usageExamples: [
          '"Je suis fatiguée. Tu veux boire quelque chose ?" → I am tired. Do you want something to drink?',
          '"Nous allons faire du sport ce soir." → We are going to exercise tonight.',
          '"Elle aime parler avec ses amis." → She likes talking with her friends.',
          '"Il veut dormir — ne fais pas de bruit !" → He wants to sleep — don\'t make noise!',
        ],
        summaryPoints: [
          'Être & Avoir — les deux auxiliaires du français',
          'Aller + infinitif → futur proche : "Je vais manger"',
          'Faire → usage très large : faire sport, cuisine, devoir…',
          'Verbes en -er (manger, parler, aimer) → conjugaison régulière',
          'Vouloir, Boire, Dormir → verbes irréguliers à mémoriser',
        ],
        learningMethod: 'Conjugaison + exemples',
        estimatedDuration: '9 min',
        prerequisites: 'Cours Salutations recommandé',
      ),
    ],
  };
}
