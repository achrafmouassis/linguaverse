// lib/features/lessons/data/courses/numbers_courses.dart
import '../course_catalog.dart';
import '../../models/lesson_course.dart';

class NumbersCourses {
  static Map<String, List<LessonCourse>> all = {
    // ════════════════════════════════════
    // FRANÇAIS – NOMBRES
    // ════════════════════════════════════
    'fr_cat_nombres_fr': [
      LessonCourse(
        id: 'fr_nombres_n1_c1', title: 'Les nombres de 1 à 5',
        language: 'Français', category: 'Les nombres', levelIndex: 0, courseIndex: 0,
        introduction: 'Bienvenue dans votre premier cours de nombres en français ! Vous apprendrez les cinq premiers chiffres, essentiels pour compter, exprimer des quantités et communiquer au quotidien.',
        objectives: ['Reconnaître et écrire les chiffres 1 à 5', 'Prononcer chaque nombre correctement', 'Utiliser ces nombres dans des phrases simples'],
        vocabulary: [
          VocabItem(word: 'Un (1)', pronunciation: 'ɛ̃', definition: 'Le premier nombre entier', example: 'J\'ai un chien à la maison.', imageUrl: 'https://images.unsplash.com/photo-1543852786-1cf6624b9987?w=200&h=200&fit=crop'),
          VocabItem(word: 'Deux (2)', pronunciation: 'dø', definition: 'Le deuxième nombre', example: 'Il y a deux pommes sur la table.', imageUrl: 'https://images.unsplash.com/photo-1550592704-6c76defa9985?w=200&h=200&fit=crop'),
          VocabItem(word: 'Trois (3)', pronunciation: 'tʁwa', definition: 'Le troisième nombre', example: 'Nous avons trois enfants.', imageUrl: 'https://images.unsplash.com/photo-1517423568366-8b83523034fd?w=200&h=200&fit=crop'),
          VocabItem(word: 'Quatre (4)', pronunciation: 'katʁ', definition: 'Le quatrième nombre', example: 'Les quatre saisons : printemps, été, automne, hiver.', imageUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=200&h=200&fit=crop'),
          VocabItem(word: 'Cinq (5)', pronunciation: 'sɛ̃k', definition: 'Le cinquième nombre', example: 'Je mange cinq fruits par jour.', imageUrl: 'https://images.unsplash.com/photo-1499195333224-3ce974eecfb4?w=200&h=200&fit=crop'),
        ],
        phoneticsExplanation: '• "Un" [ɛ̃] : son nasalisé, comme dans "pain" ou "vin".\n• "Deux" [dø] : lèvres arrondies, comme dans "feu".\n• "Trois" [tʁwa] : "r" gutturale + son [wa] comme dans "moi".\n• "Quatre" [katʁ] : "e" final muet, on prononce le "r" final.\n• "Cinq" [sɛ̃k] : le "q" se prononce [k] en liaison uniquement.',
        usageExamples: ['"J\'ai un frère." → I have one brother.', '"Donne-moi deux billets, s\'il te plaît." → Give me two tickets, please.', '"Il reste trois jours avant les vacances." → Three days left before the holidays.', '"Ma voiture a quatre portes." → My car has four doors.', '"Elle a cinq ans." → She is five years old.'],
        summaryPoints: ['Un (1) [ɛ̃] — son nasal', 'Deux (2) [dø] — lèvres arrondies', 'Trois (3) [tʁwa] — r + wa', 'Quatre (4) [katʁ] — e final muet', 'Cinq (5) [sɛ̃k] — q muet sauf liaison'],
        learningMethod: 'Visuelle + exemples contextuels', estimatedDuration: '5 min', prerequisites: 'Aucun',
      ),
      LessonCourse(
        id: 'fr_nombres_n1_c2', title: 'Les nombres de 6 à 10',
        language: 'Français', category: 'Les nombres', levelIndex: 0, courseIndex: 1,
        introduction: 'Continuez avec les nombres 6 à 10 pour compléter votre première dizaine. Ces chiffres s\'utilisent tous les jours pour indiquer l\'heure, l\'âge, des prix.',
        objectives: ['Apprendre les chiffres 6 à 10', 'Prononcer chaque nombre avec las liaisons', 'Former des phrases avec des quantités'],
        vocabulary: [
          VocabItem(word: 'Six (6)', pronunciation: 'sis / si', definition: 'Le sixième nombre', example: '"Il est six heures." / "Six chats" [si ʃa]', imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=200&h=200&fit=crop'),
          VocabItem(word: 'Sept (7)', pronunciation: 'sɛt', definition: 'Le septième nombre', example: 'La semaine a sept jours.', imageUrl: 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce?w=200&h=200&fit=crop'),
          VocabItem(word: 'Huit (8)', pronunciation: 'ɥit', definition: 'Le huitième nombre', example: 'Je dors huit heures par nuit.', imageUrl: 'https://images.unsplash.com/photo-1561037404-61cd46aa615b?w=200&h=200&fit=crop'),
          VocabItem(word: 'Neuf (9)', pronunciation: 'nœf / nœv', definition: 'Le neuvième nombre', example: '"Neuf ans" → [nœv ɑ̃] en liaison.', imageUrl: 'https://images.unsplash.com/photo-1513360371669-4adaaee41e15?w=200&h=200&fit=crop'),
          VocabItem(word: 'Dix (10)', pronunciation: 'dis / di', definition: 'Le dixième nombre', example: 'J\'ai dix doigts.', imageUrl: 'https://images.unsplash.com/photo-1555685812-4b943f1cb0eb?w=200&h=200&fit=crop'),
        ],
        phoneticsExplanation: '• "Six" : [sis] seul, [si] devant consonne, [siz] devant voyelle.\n• "Sept" : "p" muet, "t" prononcé [sɛt].\n• "Huit" : son rare [ɥit], comme "nuit" avec h.\n• "Neuf" : "f" → [v] devant heures et ans. "Neuf heures" = [nœv œʁ].\n• "Dix" : [dis] seul, [di] devant consonne, [diz] devant voyelle.',
        usageExamples: ['"Il est six heures du matin." → It is six in the morning.', '"Il y a sept jours dans une semaine." → There are seven days in a week.', '"Le magasin ouvre à huit heures." → The shop opens at eight.', '"Elle a neuf ans." [nœv ɑ̃] → She is nine years old.', '"J\'ai dix euros en poche." → I have ten euros in my pocket.'],
        summaryPoints: ['Six (6) [sis/si/siz] — 3 prononciations', 'Sept (7) [sɛt] — p muet, t prononcé', 'Huit (8) [ɥit] — son semi-consonne', 'Neuf (9) [nœf/nœv] — alternance f/v', 'Dix (10) [dis/di/diz] — comme six'],
        learningMethod: 'Phonétique + répétition', estimatedDuration: '5 min', prerequisites: 'Cours 1 : nombres 1–5',
      ),
      LessonCourse(
        id: 'fr_nombres_n1_c3', title: 'Compter et exprimer des quantités',
        language: 'Français', category: 'Les nombres', levelIndex: 0, courseIndex: 2,
        introduction: 'Dans ce cours de pratique, vous allez consolider l\'utilisation des nombres 0 à 10 dans des contextes réels du quotidien : au marché, à l\'école, en famille.',
        objectives: ['Réutiliser les nombres 0–10 à l\'oral', 'Employer "il y a", "j\'ai", "combien ?"', 'Comprendre les nombres dans des contextes variés'],
        vocabulary: [
          VocabItem(word: 'Zéro (0)', pronunciation: 'zeʁo', definition: 'Absence de quantité', example: '"Zéro erreur de ma part !" → Not a single mistake!'),
          VocabItem(word: 'Combien ?', pronunciation: 'kɔ̃bjɛ̃', definition: 'Question sur une quantité', example: '"Combien de frères as-tu ?" → How many brothers do you have?'),
          VocabItem(word: 'Il y a', pronunciation: 'il ja', definition: 'Exprimer l\'existence / quantité', example: '"Il y a trois élèves absents."'),
          VocabItem(word: 'J\'ai / Tu as', pronunciation: 'ʒɛ / ty a', definition: 'Verbe avoir pour la possession', example: '"J\'ai deux chats. Tu as un chien."'),
          VocabItem(word: 'Assez / Pas assez', pronunciation: 'ase / pa ase', definition: 'Suffisance ou insuffisance', example: '"J\'ai assez d\'argent." / "Je n\'ai pas assez de temps."'),
        ],
        phoneticsExplanation: '• "Combien" [kɔ̃bjɛ̃] : deux nasales, fréquent à l\'oral.\n• "Il y a" se réduit souvent à [ja] en langage familier.\n• "J\'ai" = élision de "je" + "ai" → [ʒɛ].',
        usageExamples: ['"Combien ça coûte ? — Cinq euros." → How much is it? — Five euros.', '"Il y a dix élèves dans la salle." → There are ten students in the room.', '"J\'ai trois frères et deux sœurs." → I have three brothers and two sisters.', '"Tu as assez d\'argent pour payer ?" → Do you have enough money to pay?', '"Zéro mois de retard cette année !" → Zero months late this year!'],
        summaryPoints: ['Zéro = absence de quantité', '"Combien ?" = question universelle sur la quantité', '"Il y a + nombre" = existence dans un lieu', '"J\'ai" = possession au présent', 'Pratiquez les nombres dans des phrases complètes !'],
        learningMethod: 'Contextuelle + mémorisation active', estimatedDuration: '7 min', prerequisites: 'Cours 1 et 2 du Niveau 1',
      ),
      LessonCourse(
        id: 'fr_nombres_n2_c1', title: 'Les dizaines : 10 à 60',
        language: 'Français', category: 'Les nombres', levelIndex: 1, courseIndex: 0,
        introduction: 'Apprenez les dizaines en français : 10, 20, 30, 40, 50, 60. Ces formes régulières se terminent toutes par "-te" et forment la base des grands nombres.',
        objectives: ['Nommer les dizaines jusqu\'à 60', 'Comprendre la régularité des suffixes', 'Créer des nombres composés : 21, 35, 48…'],
        vocabulary: [
          VocabItem(word: 'Dix (10)', pronunciation: 'dis', definition: 'Première dizaine', example: '"Il y a dix élèves absents."', imageUrl: 'https://images.unsplash.com/photo-1555685812-4b943f1cb0eb?w=200&h=200&fit=crop'),
          VocabItem(word: 'Vingt (20)', pronunciation: 'vɛ̃', definition: 'Deuxième dizaine', example: '"Il a vingt ans."', imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=200&h=200&fit=crop'),
          VocabItem(word: 'Trente (30)', pronunciation: 'tʁɑ̃t', definition: 'Troisième dizaine', example: '"La réunion dure trente minutes."', imageUrl: 'https://images.unsplash.com/photo-1509114397022-ed747cca3f65?w=200&h=200&fit=crop'),
          VocabItem(word: 'Quarante (40)', pronunciation: 'kaʁɑ̃t', definition: 'Quatrième dizaine', example: '"Il fait quarante degrés en été."', imageUrl: 'https://images.unsplash.com/photo-1444491741275-3747c53c99b4?w=200&h=200&fit=crop'),
          VocabItem(word: 'Cinquante (50)', pronunciation: 'sɛ̃kɑ̃t', definition: 'Cinquième dizaine', example: '"Il y a cinquante États aux USA."', imageUrl: 'https://images.unsplash.com/photo-1508672019048-805c876b67e2?w=200&h=200&fit=crop'),
          VocabItem(word: 'Soixante (60)', pronunciation: 'swasɑ̃t', definition: 'Sixième dizaine', example: '"Soixante secondes = une minute."', imageUrl: 'https://images.unsplash.com/photo-1501139083538-0139583c060f?w=200&h=200&fit=crop'),
        ],
        phoneticsExplanation: '• "Vingt" [vɛ̃] : "gt" muet dans 20 seul, mais [t] dans 21–29 (vingt-et-un, vingt-deux…).\n• Les autres dizaines : consonne finale muette (-te).\n• "Trente" [tʁɑ̃t], "Quarante" [kaʁɑ̃t], "Cinquante" [sɛ̃kɑ̃t], "Soixante" [swasɑ̃t].',
        usageExamples: ['"Il a vingt ans aujourd\'hui." → He turns twenty today.', '"La réunion dure trente minutes." → The meeting lasts thirty minutes.', '"On est en train de chercher depuis quarante minutes." → We\'ve been looking for forty minutes.', '"La France compte de nombreuses villes. La plus peuplée a plus de cinquante quartiers." → Contextual.', '"Soixante secondes font une minute." → Sixty seconds make one minute.'],
        summaryPoints: ['10 à 60 : formes régulières', 'Vingt [vɛ̃] — exception : t dans 21–29', 'Formation composée : vingt-deux, trente-cinq…', 'Soixante marque la fin de la partie régulière'],
        learningMethod: 'Progressive + patterns', estimatedDuration: '7 min', prerequisites: 'Niveau 1 complété',
      ),
      LessonCourse(
        id: 'fr_nombres_n3_c1', title: 'Les grands nombres : 100 à 1000',
        language: 'Français', category: 'Les nombres', levelIndex: 2, courseIndex: 0,
        introduction: 'Préparez-vous à compter en grand ! Nous allons explorer les centaines (100, 200...) jusqu\'au millénaire. Ces nombres sont cruciaux pour les prix, les années et les statistiques.',
        objectives: ['Compter par centaines de 100 à 900', 'Dire le nombre "1000" (mille)', 'Former des nombres complexes comme 150, 485…'],
        vocabulary: [
          VocabItem(word: 'Cent (100)', pronunciation: 'sɑ̃', definition: 'Une centaine', example: '"Ce livre a cent pages."', imageUrl: 'https://images.unsplash.com/photo-1543269865-cbf427effbad?w=200&h=200&fit=crop'),
          VocabItem(word: 'Deux cents (200)', pronunciation: 'dø sɑ̃', definition: 'Deux centaines', example: '"Il y a deux cents personnes."', imageUrl: 'https://images.unsplash.com/photo-1516214104703-d870798883c5?w=200&h=200&fit=crop'),
          VocabItem(word: 'Cinq cents (500)', pronunciation: 'sɛ̃k sɑ̃', definition: 'La moitié de mille', example: '"Ce vélo coûte cinq cents euros."', imageUrl: 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=200&h=200&fit=crop'),
          VocabItem(word: 'Mille (1000)', pronunciation: 'mil', definition: 'Un millier', example: '"Un kilomètre fait mille mètres."', imageUrl: 'https://images.unsplash.com/photo-1526772662000-3f88f10405ff?w=200&h=200&fit=crop'),
        ],
        phoneticsExplanation: '• "Cent" [sɑ̃] : comme "sans" ou "sang".\n• "Mille" [mil] : comme le prénom "Emile" sans le E.\n• Attention aux liaisons : "deux cents [sɑ̃] euros" vs "deux cents [sɑ̃z] arbres".',
        usageExamples: ['"Le loyer est de huit cents euros." → The rent is eight hundred euros.', '"Ce monument a mille ans." → This monument is a thousand years old.', '"J\'ai lu cent cinquante pages." → I read one hundred and fifty pages.'],
        summaryPoints: ['Cent = 100', 'Mille = 1000', 'Pas de "s" à cent s\'il est suivi d\'un autre nombre', 'Mille est invariable'],
        learningMethod: 'Logique mathématique', estimatedDuration: '8 min', prerequisites: 'Niveau 2 complété',
      ),
    ],

    // ════════════════════════════════════
    // ARABE – NOMBRES
    // ════════════════════════════════════
    'ar_cat_nombres_ar': [
      LessonCourse(
        id: 'ar_nombres_n1_c1', title: 'الأرقام من ١ إلى ٥',
        language: 'Arabe', category: 'Les nombres', levelIndex: 0, courseIndex: 0,
        introduction: 'Dans ce premier cours, vous apprendrez les cinq premiers chiffres en arabe. L\'arabe utilise deux systèmes de chiffres : les chiffres arabes-orientaux (١٢٣) et les chiffres latins (123). Les deux sont couramment utilisés.',
        objectives: ['Reconnaître les chiffres arabes ١ à ٥', 'Prononcer chaque nombre correctement', 'Utiliser ces nombres dans une phrase simple'],
        vocabulary: [
          VocabItem(word: 'وَاحِد ١', pronunciation: 'wāḥid', definition: 'Un — premier nombre', example: 'عِنْدِي كِتَابٌ وَاحِد = J\'ai un livre.'),
          VocabItem(word: 'اثْنَان ٢', pronunciation: 'ithnān', definition: 'Deux — première paire', example: 'عِنْدِي قِطَّتَانِ اثْنَتَان = J\'ai deux chats.'),
          VocabItem(word: 'ثَلَاثَة ٣', pronunciation: 'thalātha', definition: 'Trois', example: 'ثَلَاثَةُ أَيَّام = Trois jours.'),
          VocabItem(word: 'أَرْبَعَة ٤', pronunciation: 'arbaʿa', definition: 'Quatre', example: 'أَرْبَعَةُ فُصُول = Quatre saisons.'),
          VocabItem(word: 'خَمْسَة ٥', pronunciation: 'khamsa', definition: 'Cinq', example: 'خَمْسَةُ أَصَابِع = Cinq doigts.'),
        ],
        phoneticsExplanation: '• وَاحِد [wāḥid] : ح = fricative pharyngale sourde, produite au fond de la gorge.\n• اثْنَان [ithnān] : "th" = [θ] comme dans l\'anglais "think".\n• ثَلَاثَة [thalātha] : deux sons [θ] encadrent le mot.\n• أَرْبَعَة [arbaʿa] : ع = son unique arabe, fricative pharyngale sonore.\n• خَمْسَة [khamsa] : خ = [x] comme le "ch" allemand de "Bach".',
        usageExamples: ['عِنْدِي وَلَدٌ وَاحِد = J\'ai un fils.', 'اشْتَرَيْتُ اثْنَيْنِ مِنَ الكُتُب = J\'ai acheté deux livres.', 'مَضَتْ ثَلَاثَةُ أَيَّام = Trois jours se sont écoulés.', 'عِنْدَهُ أَرْبَعَةُ أَشْقِاء = Il a quatre frères.', 'أَكَلْتُ خَمْسَ تُفَّاحَات = J\'ai mangé cinq pommes.'],
        summaryPoints: ['وَاحِد [wāḥid] — attention au ح pharyngal', 'اثْنَان [ithnān] — accord en genre (اثنتان féminin)', 'ثَلَاثَة [thalātha] — deux sons ث', 'أَرْبَعَة [arbaʿa] — son ع unique à l\'arabe', 'خَمْسَة [khamsa] — خ comme "Bach"'],
        learningMethod: 'Visuelle + phonétique', estimatedDuration: '8 min', prerequisites: 'Aucun',
      ),
      LessonCourse(
        id: 'ar_nombres_n1_c2', title: 'الأرقام من ٦ إلى ١٠',
        language: 'Arabe', category: 'Les nombres', levelIndex: 0, courseIndex: 1,
        introduction: 'Continuez avec les chiffres 6 à 10 en arabe. En arabe, les nombres 3 à 10 s\'accordent en genre de façon inversée par rapport au nom qu\'ils accompagnent — une règle importante à connaître !',
        objectives: ['Apprendre les chiffres arabes ٦ à ١٠', 'Comprendre la règle d\'accord inversé (3–10)', 'Prononcer correctement chaque nombre'],
        vocabulary: [
          VocabItem(word: 'سِتَّة ٦', pronunciation: 'sitta', definition: 'Six', example: 'سِتَّةُ أَشْهُر = Six mois.'),
          VocabItem(word: 'سَبْعَة ٧', pronunciation: 'sabʿa', definition: 'Sept', example: 'سَبْعَةُ أَيَّام = Sept jours.'),
          VocabItem(word: 'ثَمَانِيَة ٨', pronunciation: 'thamāniya', definition: 'Huit', example: 'ثَمَانِيَةُ سَاعَات = Huit heures.'),
          VocabItem(word: 'تِسْعَة ٩', pronunciation: 'tisʿa', definition: 'Neuf', example: 'تِسْعَةُ طُلَّاب = Neuf étudiants.'),
          VocabItem(word: 'عَشَرَة ١٠', pronunciation: 'ʿashara', definition: 'Dix', example: 'عَشَرَةُ دَقَائِق = Dix minutes.'),
        ],
        phoneticsExplanation: '• سِتَّة [sitta] : double "t" (تّ) — consonne géminée.\n• سَبْعَة [sabʿa] : ع pharyngal au milieu.\n• ثَمَانِيَة [thamāniya] : ث = [θ] + ā long + ya finale.\n• تِسْعَة [tisʿa] : ع en finale.\n• عَشَرَة [ʿashara] : commence par ع pharyngal.',
        usageExamples: ['الأُسْبُوعُ سَبْعَةُ أَيَّام = La semaine a sept jours.', 'أَنَا أَنَامُ ثَمَانِيَ سَاعَات = Je dors huit heures.', 'عِنْدِي تِسْعَةُ كُتُب = J\'ai neuf livres.', 'انْتَظَرْتُ عَشَرَ دَقَائِق = J\'ai attendu dix minutes.', 'فِي الأُسْبُوعِ سِتَّةُ أَيَّام عَمَل = Il y a six jours de travail par semaine.'],
        summaryPoints: ['سِتَّة [sitta] — double consonne', 'سَبْعَة [sabʿa] — ع central', 'ثَمَانِيَة [thamāniya] — ث + ā long', 'تِسْعَة [tisʿa] — ع final', 'عَشَرَة [ʿashara] — commence par ع'],
        learningMethod: 'Phonétique + exemples contextuels', estimatedDuration: '8 min', prerequisites: 'Cours 1 : ١–٥',
      ),
    ],

    // ════════════════════════════════════
    // ANGLAIS – NOMBRES
    // ════════════════════════════════════
    'en_cat_nombres_en': [
      LessonCourse(
        id: 'en_nombres_n1_c1', title: 'Numbers 1 to 5',
        language: 'Anglais', category: 'Les nombres', levelIndex: 0, courseIndex: 0,
        introduction: 'In this lesson, you will learn the first five numbers in English. Numbers are essential for everyday life — telling time, shopping, giving your age, and much more.',
        objectives: ['Learn to say and write 1 to 5 in English', 'Pronounce each number correctly', 'Use numbers in simple everyday sentences'],
        vocabulary: [
          VocabItem(word: 'One (1)', pronunciation: '/wʌn/', definition: 'The first whole number', example: 'I have one question for you.'),
          VocabItem(word: 'Two (2)', pronunciation: '/tuː/', definition: 'The number after one', example: 'There are two cats on the sofa.'),
          VocabItem(word: 'Three (3)', pronunciation: '/θriː/', definition: 'The number after two', example: 'She has three sisters.'),
          VocabItem(word: 'Four (4)', pronunciation: '/fɔːr/', definition: 'The number after three', example: 'A table has four legs.'),
          VocabItem(word: 'Five (5)', pronunciation: '/faɪv/', definition: 'The number after four', example: 'Take five deep breaths.'),
        ],
        phoneticsExplanation: '• "One" /wʌn/ : sounds like "won" — the O is silent!\n• "Two" /tuː/ : the W is completely silent.\n• "Three" /θriː/ : TH = tongue between teeth, like in "think".\n• "Four" /fɔːr/ : rhymes with "more", "door", "floor".\n• "Five" /faɪv/ : ends with a voiced V sound.',
        usageExamples: ['"I have one brother." → J\'ai un frère.', '"Can I get two coffees, please?" → Puis-je avoir deux cafés, s\'il vous plaît ?', '"We need three more chairs." → Nous avons besoin de trois chaises de plus.', '"The meeting is in four hours." → La réunion est dans quatre heures.', '"She smiled five times." → Elle a souri cinq fois.'],
        summaryPoints: ['One /wʌn/ — O silent, starts with W sound', 'Two /tuː/ — W silent', 'Three /θriː/ — dental fricative TH', 'Four /fɔːr/ — rhymes with door', 'Five /faɪv/ — voiced V'],
        learningMethod: 'Phonétique + contextuelle', estimatedDuration: '5 min', prerequisites: 'Aucun',
      ),
      LessonCourse(
        id: 'en_nombres_n1_c2', title: 'Numbers 6 to 10',
        language: 'Anglais', category: 'Les nombres', levelIndex: 0, courseIndex: 1,
        introduction: 'Complete your first ten numbers in English! These numbers are used constantly in daily life — for time, phone numbers, addresses, and scores.',
        objectives: ['Learn numbers 6 to 10 in English', 'Notice spelling patterns (teen/ty confusion to avoid)', 'Use these numbers in practical contexts'],
        vocabulary: [
          VocabItem(word: 'Six (6)', pronunciation: '/sɪks/', definition: 'The sixth number', example: 'There are six eggs left.'),
          VocabItem(word: 'Seven (7)', pronunciation: '/ˈsɛvən/', definition: 'The seventh number', example: 'There are seven days in a week.'),
          VocabItem(word: 'Eight (8)', pronunciation: '/eɪt/', definition: 'The eighth number', example: 'I sleep eight hours a night.'),
          VocabItem(word: 'Nine (9)', pronunciation: '/naɪn/', definition: 'The ninth number', example: 'My office is on the ninth floor.'),
          VocabItem(word: 'Ten (10)', pronunciation: '/tɛn/', definition: 'The tenth number', example: 'On a scale of one to ten, it\'s a ten!'),
        ],
        phoneticsExplanation: '• "Six" /sɪks/ : ends with the cluster [ks].\n• "Seven" /ˈsɛvən/ : stress on first syllable SEV-en.\n• "Eight" /eɪt/ : the GH is silent — rhymes with "late", "gate".\n• "Nine" /naɪn/ : rhymes with "mine", "line".\n• "Ten" /tɛn/ : short E sound, rhymes with "pen", "hen".',
        usageExamples: ['"I\'ll be there in six minutes." → J\'y serai dans six minutes.', '"The movie starts at seven." → Le film commence à sept heures.', '"I work eight hours a day." → Je travaille huit heures par jour.', '"Call me at nine tonight." → Appelle-moi à neuf heures ce soir.', '"Perfect score — ten out of ten!" → Note parfaite — dix sur dix !'],
        summaryPoints: ['Six /sɪks/ — ends with [ks]', 'Seven /ˈsɛvən/ — stress: SEV-en', 'Eight /eɪt/ — GH silent, rhymes with "late"', 'Nine /naɪn/ — rhymes with "mine"', 'Ten /tɛn/ — short E, rhymes with "pen"'],
        learningMethod: 'Phonétique + mémorisation', estimatedDuration: '5 min', prerequisites: 'Cours 1 : 1–5',
      ),
    ],

    // ════════════════════════════════════
    // ESPAGNOL – NOMBRES
    // ════════════════════════════════════
    'es_cat_nombres_es': [
      LessonCourse(
        id: 'es_nombres_n1_c1', title: 'Los números del 1 al 5',
        language: 'Espagnol', category: 'Les nombres', levelIndex: 0, courseIndex: 0,
        introduction: 'En este primer curso aprenderás los cinco primeros números en español. El español es una lengua fonética, lo que significa que se pronuncia tal como se escribe — ¡una gran ventaja!',
        objectives: ['Aprender los números 1 al 5 en español', 'Pronunciar correctamente cada número', 'Usar los números en frases sencillas del día a día'],
        vocabulary: [
          VocabItem(word: 'Uno (1)', pronunciation: '/ˈuno/', definition: 'Premier nombre', example: 'Tengo un hermano. (J\'ai un frère.)'),
          VocabItem(word: 'Dos (2)', pronunciation: '/dos/', definition: 'Deuxième nombre', example: 'Hay dos gatos en el sofá. (Il y a deux chats sur le canapé.)'),
          VocabItem(word: 'Tres (3)', pronunciation: '/tres/', definition: 'Troisième nombre', example: 'Faltan tres días. (Il reste trois jours.)'),
          VocabItem(word: 'Cuatro (4)', pronunciation: '/ˈkwatro/', definition: 'Quatrième nombre', example: 'Hay cuatro estaciones. (Il y a quatre saisons.)'),
          VocabItem(word: 'Cinco (5)', pronunciation: '/ˈθinko/', definition: 'Cinquième nombre', example: 'Tengo cinco dedos en cada mano. (J\'ai cinq doigts à chaque main.)'),
        ],
        phoneticsExplanation: '• "Uno" /ˈuno/ : devient "un" devant un nom masculin (un libro).\n• "Dos" /dos/ : court et clair, s final prononcé.\n• "Tres" /tres/ : "r" roulé + "es" final.\n• "Cuatro" /ˈkwatro/ : "cu" = [kw], "tr" = pas de e entre les deux.\n• "Cinco" /ˈθinko/ en Espagne, /ˈsinko/ en Amérique latine.',
        usageExamples: ['¿Tienes un minuto? — Oui, j\'ai une minute.', 'Dame dos entradas, por favor. — Donne-moi deux billets, s\'il te plaît.', 'Quedan tres días para el examen. — Il reste trois jours avant l\'examen.', 'Mi coche tiene cuatro puertas. — Ma voiture a quatre portes.', 'Cinco personas esperan afuera. — Cinq personnes attendent dehors.'],
        summaryPoints: ['Uno (1) → "un" devant nom masculin', 'Dos (2) /dos/ — clair et court', 'Tres (3) /tres/ — r roulé', 'Cuatro (4) /ˈkwatro/ — cu=[kw]', 'Cinco (5) — prononciation varie selon région'],
        learningMethod: 'Phonétique + contextuelle', estimatedDuration: '5 min', prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // TURC – NOMBRES
    // ════════════════════════════════════
    'tr_cat_nombres_tr': [
      LessonCourse(
        id: 'tr_nombres_n1_c1', title: 'Bir\'den Beş\'e Kadar Sayılar',
        language: 'Turc', category: 'Les nombres', levelIndex: 0, courseIndex: 0,
        introduction: 'Dans ce cours, vous découvrirez les cinq premiers chiffres en turc. Le turc est une langue agglutinante — les mots s\'enrichissent par l\'ajout de suffixes. Mais les chiffres, eux, sont simples et invariables !',
        objectives: ['Apprendre les nombres 1 à 5 en turc', 'Prononcer les sons spéciaux : ı, ü, ş', 'Utiliser les nombres dans des phrases simples'],
        vocabulary: [
          VocabItem(word: 'Bir (1)', pronunciation: '/biɾ/', definition: 'Un — premier nombre', example: 'Bir elma var. (Il y a une pomme.)'),
          VocabItem(word: 'İki (2)', pronunciation: '/iki/', definition: 'Deux', example: 'İki kedi var. (Il y a deux chats.)'),
          VocabItem(word: 'Üç (3)', pronunciation: '/ytʃ/', definition: 'Trois', example: 'Üç gün kaldı. (Il reste trois jours.)'),
          VocabItem(word: 'Dört (4)', pronunciation: '/døɾt/', definition: 'Quatre', example: 'Dört mevsim var. (Il y a quatre saisons.)'),
          VocabItem(word: 'Beş (5)', pronunciation: '/beʃ/', definition: 'Cinq', example: 'Beş parmak var. (Il y a cinq doigts.)'),
        ],
        phoneticsExplanation: '• "Bir" /biɾ/ : r final est un r "battu" (tap), comme en espagnol.\n• "İki" /iki/ : i majuscule (İ) = i avec point — différent du "ı" sans point.\n• "Üç" /ytʃ/ : ü = comme le "u" français dans "lune".\n• "Dört" /døɾt/ : ö = comme le "eu" français dans "feu".\n• "Beş" /beʃ/ : ş = "ch" français dans "chat".',
        usageExamples: ['Bir dakika bekleyin. → Attendez une minute.', 'İki çay lütfen. → Deux thés, s\'il vous plaît.', 'Üç kardeşim var. → J\'ai trois frères/sœurs.', 'Dört koltuk var. → Il y a quatre fauteuils.', 'Beş dakika sonra geliyorum. → Je reviens dans cinq minutes.'],
        summaryPoints: ['Bir /biɾ/ — r battu', 'İki /iki/ — attention au İ (avec point)', 'Üç /ytʃ/ — ü comme "lune"', 'Dört /døɾt/ — ö comme "feu"', 'Beş /beʃ/ — ş comme "ch"'],
        learningMethod: 'Phonétique + contextuelle', estimatedDuration: '7 min', prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // ALLEMAND – NOMBRES
    // ════════════════════════════════════
    'de_cat_nombres_de': [
      LessonCourse(
        id: 'de_nombres_n1_c1', title: 'Die Zahlen von 1 bis 5',
        language: 'Allemand', category: 'Les nombres', levelIndex: 0, courseIndex: 0,
        introduction: 'Willkommen! Dans ce cours, vous apprendrez les cinq premiers chiffres en allemand. L\'allemand a quelques sons qui n\'existent pas en français — suivez le guide phonétique pour les maîtriser.',
        objectives: ['Mémoriser les nombres 1 à 5 en allemand', 'Prononcer les sons spéciaux : ü, ei, ch', 'Utiliser les nombres dans des contextes quotidiens'],
        vocabulary: [
          VocabItem(word: 'Eins (1)', pronunciation: '/aɪns/', definition: 'Un — nombre cardinal', example: 'Ich habe einen Bruder. (J\'ai un frère.)'),
          VocabItem(word: 'Zwei (2)', pronunciation: '/tsvaɪ/', definition: 'Deux', example: 'Zwei Katzen schlafen. (Deux chats dorment.)'),
          VocabItem(word: 'Drei (3)', pronunciation: '/dʁaɪ/', definition: 'Trois', example: 'Drei Tage sind vergangen. (Trois jours se sont écoulés.)'),
          VocabItem(word: 'Vier (4)', pronunciation: '/fiːɐ/', definition: 'Quatre', example: 'Es gibt vier Jahreszeiten. (Il y a quatre saisons.)'),
          VocabItem(word: 'Fünf (5)', pronunciation: '/fʏnf/', definition: 'Cinq', example: 'Ich habe fünf Finger. (J\'ai cinq doigts.)'),
        ],
        phoneticsExplanation: '• "Eins" /aɪns/ : "ei" se prononce [aɪ] comme "I" en anglais.\n• "Zwei" /tsvaɪ/ : "z" allemand = [ts] comme dans "pizza".\n• "Drei" /dʁaɪ/ : "dr" = d + r guttural allemand [ʁ].\n• "Vier" /fiːɐ/ : "ie" = [iː] long, "r" final réduit à [ɐ].\n• "Fünf" /fʏnf/ : "ü" ≈ entre "u" et "i" en français.',
        usageExamples: ['Ich habe eine Frage. → J\'ai une question.', 'Zwei Kaffee, bitte! → Deux cafés, s\'il vous plaît !', 'Drei Minuten noch. → Encore trois minutes.', 'Vier Leute warten draußen. → Quatre personnes attendent dehors.', 'Fünf Euro, bitte. → Cinq euros, s\'il vous plaît.'],
        summaryPoints: ['Eins /aɪns/ — ei=[aɪ]', 'Zwei /tsvaɪ/ — z=[ts]', 'Drei /dʁaɪ/ — r guttural', 'Vier /fiːɐ/ — ie long', 'Fünf /fʏnf/ — ü spécial allemand'],
        learningMethod: 'Phonétique + exemples', estimatedDuration: '7 min', prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // ITALIEN – NOMBRES
    // ════════════════════════════════════
    'it_cat_nombres_it': [
      LessonCourse(
        id: 'it_nombres_n1_c1', title: 'I numeri da 1 a 5',
        language: 'Italien', category: 'Les nombres', levelIndex: 0, courseIndex: 0,
        introduction: 'Benvenuti! L\'italien est une langue musicale — chaque syllabe se prononce clairement. Les nombres italiens sont proches du français et de l\'espagnol, ce qui les rend faciles à apprendre !',
        objectives: ['Apprendre les nombres 1 à 5 en italien', 'Prononcer chaque syllabe distinctement', 'Former des phrases simples avec des nombres'],
        vocabulary: [
          VocabItem(word: 'Uno (1)', pronunciation: '/ˈuːno/', definition: 'Un — premier nombre', example: 'Ho un fratello. (J\'ai un frère.)'),
          VocabItem(word: 'Due (2)', pronunciation: '/ˈduːe/', definition: 'Deux', example: 'Ci sono due gatti. (Il y a deux chats.)'),
          VocabItem(word: 'Tre (3)', pronunciation: '/treː/', definition: 'Trois', example: 'Mancano tre giorni. (Il reste trois jours.)'),
          VocabItem(word: 'Quattro (4)', pronunciation: '/ˈkwattro/', definition: 'Quatre', example: 'Ci sono quattro stagioni. (Il y a quatre saisons.)'),
          VocabItem(word: 'Cinque (5)', pronunciation: '/ˈtʃiŋkwe/', definition: 'Cinq', example: 'Ho cinque dita per mano. (J\'ai cinq doigts par main.)'),
        ],
        phoneticsExplanation: '• "Uno" /ˈuːno/ : "u" long, sans diphtongue.\n• "Due" /ˈduːe/ : deux syllabes distinctes DU-E, pas comme "do" en anglais.\n• "Tre" /treː/ : "e" final long, r roulé léger.\n• "Quattro" /ˈkwattro/ : "qu" = [kw], double "t" tendu.\n• "Cinque" /ˈtʃiŋkwe/ : "ci" = [tʃi] comme "tchi" ; "qu" = [kw].',
        usageExamples: ['Ho una domanda. → J\'ai une question.', 'Vorrei due biglietti. → Je voudrais deux billets.', 'Tre giorni di viaggio. → Trois jours de voyage.', 'Quattro persone aspettano. → Quatre personnes attendent.', 'Cinque minuti, per favore. → Cinq minutes, s\'il vous plaît.'],
        summaryPoints: ['Uno /ˈuːno/ — u long', 'Due /ˈduːe/ — 2 syllabes : DU-E', 'Tre /treː/ — e ouvert long', 'Quattro /ˈkwattro/ — qu=[kw], double t', 'Cinque /ˈtʃiŋkwe/ — ci=[tʃi]'],
        learningMethod: 'Phonétique + mémorisation', estimatedDuration: '5 min', prerequisites: 'Aucun',
      ),
    ],
  };
}
