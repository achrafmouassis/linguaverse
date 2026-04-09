// lib/features/lessons/data/courses/greetings_courses.dart
import '../course_catalog.dart';
import '../../models/lesson_course.dart';

class GreetingsCourses {
  static Map<String, List<LessonCourse>> all = {

    // ════════════════════════════════════
    // ARABE – SALUTATIONS
    // ════════════════════════════════════
    'ar_cat_salutations_ar': [
      LessonCourse(
        id: 'ar_salutations_n1_c1', title: 'التَّحِيَّات الأَسَاسِيَّة (Salutations de base)',
        language: 'Arabe', category: 'Les salutations', levelIndex: 0, courseIndex: 0,
        introduction: 'Les salutations sont la porte d\'entrée dans toute langue. En arabe, elles sont chargées de sens culturel et de politesse. Le mot le plus courant pour saluer signifie littéralement "La paix sur vous". Apprenez-les pour créer un contact immédiat et respectueux.',
        objectives: ['Apprendre 8 formules de salutation en arabe', 'Comprendre leurs sens et contextes d\'utilisation', 'Savoir répondre correctement à chaque salutation'],
        vocabulary: [
          VocabItem(word: 'السَّلَامُ عَلَيْكُمْ', pronunciation: 'As-salāmu ʿalaykum', definition: 'La paix sur vous — salutation universelle', example: 'يُقَال عِنْدَ اللِّقَاء = Dit lors d\'une rencontre.'),
          VocabItem(word: 'وَعَلَيْكُمُ السَّلَام', pronunciation: 'Wa ʿalaykum as-salām', definition: 'Et sur vous la paix — réponse obligatoire', example: 'الرَّد عَلَى السَّلَام = La réponse au salam.'),
          VocabItem(word: 'مَرْحَبًا', pronunciation: 'Marḥaban', definition: 'Bonjour / Bienvenue (informel)', example: 'مَرْحَبًا بِكَ! = Bienvenue chez toi !'),
          VocabItem(word: 'كَيْفَ حَالُكَ؟', pronunciation: 'Kayfa ḥāluk?', definition: 'Comment vas-tu ? (masc.)', example: 'كَيْفَ حَالُكَ اليَوْم؟ = Comment vas-tu aujourd\'hui ?'),
          VocabItem(word: 'بِخَيْر، شُكْرًا', pronunciation: 'Bikhair, shukran', definition: 'Bien, merci — réponse standard', example: 'أَنَا بِخَيْر، شُكْرًا = Je vais bien, merci.'),
          VocabItem(word: 'شُكْرًا جَزِيلًا', pronunciation: 'Shukran jazīlan', definition: 'Merci beaucoup', example: 'شُكْرًا جَزِيلًا عَلَى المُسَاعَدَة = Merci beaucoup pour l\'aide.'),
          VocabItem(word: 'مِنْ فَضْلِكَ', pronunciation: 'Min faḍlik', definition: 'S\'il vous plaît', example: 'مِنْ فَضْلِكَ، سَاعِدْنِي = Aide-moi s\'il te plaît.'),
          VocabItem(word: 'مَعَ السَّلَامَة', pronunciation: 'Maʿa as-salāma', definition: 'Au revoir (littér. : "pars en sécurité")', example: 'إِلَى اللِّقَاء! مَعَ السَّلَامَة! = À bientôt ! Au revoir !'),
        ],
        phoneticsExplanation: '• السَّلَام [as-salām] : le "s" de "السّ" est emphatique [sˁ].\n• كَيْفَ [kayfa] : diphtongue [ay] + finale ouverte [a].\n• حَال [ḥāl] : ح = fricative pharyngale sourde, au fond de la gorge.\n• شُكْرًا [shukran] : "sh" = [ʃ] comme "ch" français.\n• مَعَ [maʿa] : ع = fricative pharyngale sonore.',
        usageExamples: [
          'En entrant dans un magasin → "السَّلَامُ عَلَيْكُمْ" — Réponse du vendeur → "وَعَلَيْكُمُ السَّلَام".',
          'À un ami → "مَرْحَبًا! كَيْفَ حَالُكَ؟" → "بِخَيْر، شُكْرًا، وَأَنْتَ؟"',
          'Pour demander quelque chose poliment → "مِنْ فَضْلِكَ، أَيْنَ المَحَطَّة؟" = Où est la gare, s\'il vous plaît ?',
          'En partant → "مَعَ السَّلَامَة" — Réponse → "إِلَى اللِّقَاء".',
        ],
        summaryPoints: ['السَّلَام عليكم — salutation formelle universelle', 'مَرْحَبًا — informel, proche de "salut"', 'كَيْفَ حَالُكَ؟ — masc., كَيْفَ حَالُكِ؟ — fém.', 'شُكْرًا — merci, جَزِيلًا intensifie (beaucoup)', 'مَعَ السَّلَامَة — littéralement "pars avec la paix"'],
        learningMethod: 'Contextuelle + culturelle', estimatedDuration: '8 min', prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // ANGLAIS – SALUTATIONS
    // ════════════════════════════════════
    'en_cat_salutations_en': [
      LessonCourse(
        id: 'en_salutations_n1_c1', title: 'Basic Greetings in English',
        language: 'Anglais', category: 'Les salutations', levelIndex: 0, courseIndex: 0,
        introduction: 'Greetings are the first thing you say when you meet someone. In English, greetings vary depending on the time of day, how well you know the person, and how formal the situation is. Let\'s learn the most important ones!',
        objectives: ['Learn the most common English greetings', 'Understand when each greeting is appropriate', 'Practice natural responses to each greeting'],
        vocabulary: [
          VocabItem(word: 'Hello', pronunciation: '/həˈloʊ/', definition: 'Universal greeting for any situation', example: '"Hello, my name is Sarah." → Bonjour, je m\'appelle Sarah.'),
          VocabItem(word: 'Hi', pronunciation: '/haɪ/', definition: 'Informal, casual greeting', example: '"Hi! How are you?" → Salut ! Comment vas-tu ?'),
          VocabItem(word: 'Good morning', pronunciation: '/ɡʊd ˈmɔːrnɪŋ/', definition: 'Used until around midday', example: '"Good morning, everyone!" → Bonjour tout le monde !'),
          VocabItem(word: 'Good afternoon', pronunciation: '/ɡʊd ˌæftərˈnuːn/', definition: 'Used from midday to about 6pm', example: '"Good afternoon, Dr. Smith." → Bonjour, Docteur Smith.'),
          VocabItem(word: 'Good evening', pronunciation: '/ɡʊd ˈiːvnɪŋ/', definition: 'Used from around 6pm onwards', example: '"Good evening, welcome to the restaurant." → Bonsoir, bienvenue au restaurant.'),
          VocabItem(word: 'How are you?', pronunciation: '/haʊ ɑːr juː/', definition: 'Standard question about well-being', example: '"Hi Mark, how are you?" → Salut Marc, comment vas-tu ?'),
          VocabItem(word: 'I\'m fine, thank you', pronunciation: '/aɪm faɪn θæŋk juː/', definition: 'Standard positive response', example: '"How are you?" — "I\'m fine, thank you! And you?"'),
          VocabItem(word: 'Goodbye / Bye', pronunciation: '/ɡʊdˈbaɪ/ /baɪ/', definition: 'Farewell expression', example: '"Goodbye! See you tomorrow!" → Au revoir ! À demain !'),
        ],
        phoneticsExplanation: '• "Hello" /həˈloʊ/ : stress on second syllable hel-LO.\n• "Hi" /haɪ/ : single syllable, rhymes with "my", "sky".\n• "Good" /ɡʊd/ : short U sound, like "book", "foot".\n• "Morning" /ˈmɔːrnɪŋ/ : stress on MOR, silent G at end.\n• "How are you?" often reduced in speech to "Howaryou?" /haʊərjuː/.',
        usageExamples: [
          'Meeting a colleague in the morning → "Good morning, how are you?" → "I\'m very well, thanks!"',
          'Running into a friend on the street → "Hey! Hi! Long time no see!" → "I know, it\'s been ages!"',
          'Entering a shop → "Hello, I\'m looking for a blue jacket." → "Good afternoon, how can I help?"',
          'Ending a phone call → "Alright, talk soon. Goodbye!" → "Bye! Take care!"',
        ],
        summaryPoints: ['"Hello" — universal, works in any context', '"Hi" — informal, for friends and peers', '"Good morning/afternoon/evening" — time-specific', '"How are you?" → "I\'m fine/great/good, thanks!"', '"Goodbye/Bye" — farewell; "See you later" for informal'],
        learningMethod: 'Contextuelle + situationnelle', estimatedDuration: '6 min', prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // ESPAGNOL – SALUTATIONS
    // ════════════════════════════════════
    'es_cat_salutations_es': [
      LessonCourse(
        id: 'es_salutations_n1_c1', title: 'Los saludos básicos en español',
        language: 'Espagnol', category: 'Les salutations', levelIndex: 0, courseIndex: 0,
        introduction: '¡Bienvenido! Les salutations en espagnol sont chaleureuses et expressives. L\'espagnol change selon le moment de la journée et le niveau de formalité. Vous apprendrez les plus importantes dans ce cours.',
        objectives: ['Apprendre les salutations clés en espagnol', 'Distinguer le formel (usted) de l\'informel (tú)', 'Savoir répondre naturellement à chaque salutation'],
        vocabulary: [
          VocabItem(word: 'Hola', pronunciation: '/ˈola/', definition: 'Salut / Bonjour — universel', example: '¡Hola! ¿Cómo estás? → Salut ! Comment vas-tu ?'),
          VocabItem(word: 'Buenos días', pronunciation: '/ˈbwenos ˈdias/', definition: 'Bonjour (matin)', example: 'Buenos días, señora García. → Bonjour, Madame García.'),
          VocabItem(word: 'Buenas tardes', pronunciation: '/ˈbwenas ˈtardes/', definition: 'Bonjour / Bon après-midi', example: 'Buenas tardes, ¿en qué le puedo ayudar? → Comment puis-je vous aider ?'),
          VocabItem(word: 'Buenas noches', pronunciation: '/ˈbwenas ˈnotʃes/', definition: 'Bonsoir / Bonne nuit', example: 'Buenas noches, hasta mañana. → Bonne nuit, à demain.'),
          VocabItem(word: '¿Cómo estás? / ¿Cómo está usted?', pronunciation: '/ˈkomo esˈtas/', definition: 'Comment vas-tu ? (informel/formel)', example: '¿Cómo estás hoy? → Comment vas-tu aujourd\'hui ?'),
          VocabItem(word: 'Muy bien, gracias', pronunciation: '/mwi ˈbjen ˈɡrasjas/', definition: 'Très bien, merci', example: '¿Cómo estás? — Muy bien, gracias. ¿Y tú?'),
          VocabItem(word: 'Hasta luego', pronunciation: '/ˈasta ˈlweɣo/', definition: 'Au revoir (à bientôt)', example: 'Fue un placer. ¡Hasta luego! → Ravi de vous avoir rencontré. Au revoir !'),
          VocabItem(word: 'Por favor / Gracias', pronunciation: '/por faˈβor/ /ˈɡrasjas/', definition: 'S\'il vous plaît / Merci', example: 'Un café, por favor. ¡Gracias! → Un café, s\'il vous plaît. Merci !'),
        ],
        phoneticsExplanation: '• "Hola" /ˈola/ : H est muet en espagnol — on prononce directement le O.\n• "Buenos" /ˈbwenos/ : "ue" = diphtongue [we].\n• "¿Cómo?" : accent sur la première syllabe, "c" = [k].\n• "Gracias" /ˈɡrasjas/ : en Espagne "c" = [θ] (gracIAs = gra-THIAS), en Amérique = [s].\n• "Hasta" /ˈasta/ : H muet.',
        usageExamples: [
          'En entrant au bureau → "Buenos días a todos!" → Tout le monde répond "¡Buenos días!"',
          'Croiser un ami → "¡Hola! ¿Cómo estás?" → "Muy bien, ¿y tú?" → "Bien también, gracias."',
          'Au restaurant le soir → "Buenas noches, mesa para dos, por favor." → "¡Claro! Por aquí."',
          'En partant → "Bueno, me voy. ¡Hasta luego!" → "¡Cuídate! Adiós."',
        ],
        summaryPoints: ['"Hola" — universel et informel', '"Buenos días/tardes/noches" — selon l\'heure', '"¿Cómo estás?" → informel, "¿Cómo está usted?" → formel', '"Muy bien, gracias. ¿Y tú?" — réponse standard', '"Hasta luego/mañana/pronto" — formules d\'au revoir'],
        learningMethod: 'Contextuelle + culturelle', estimatedDuration: '7 min', prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // TURC – SALUTATIONS
    // ════════════════════════════════════
    'tr_cat_salutations_tr': [
      LessonCourse(
        id: 'tr_salutations_n1_c1', title: 'Temel Türkçe Selamlar',
        language: 'Turc', category: 'Les salutations', levelIndex: 0, courseIndex: 0,
        introduction: 'Merhaba! Les salutations turques reflètent une culture chaleureuse et respectueuse. Le turc dispose d\'un système de politesse distinct entre le tu (sen) et le vous (siz). Apprenez ces formules essentielles pour briser la glace à Istanbul ou Ankara !',
        objectives: ['Apprendre les salutations turques essentielles', 'Distinguer formal (siz) et informel (sen)', 'Répondre naturellement dans une conversation'],
        vocabulary: [
          VocabItem(word: 'Merhaba', pronunciation: '/merˈhaba/', definition: 'Bonjour / Salut — universel', example: 'Merhaba! Nasılsın? → Salut ! Comment vas-tu ?'),
          VocabItem(word: 'Günaydın', pronunciation: '/ɡynajˈdɯn/', definition: 'Bonjour (matin)', example: 'Günaydın! Kahvaltı hazır. → Bonjour ! Le petit-déjeuner est prêt.'),
          VocabItem(word: 'İyi akşamlar', pronunciation: '/iji akˈʃamlar/', definition: 'Bonsoir', example: 'İyi akşamlar, hoş geldiniz! → Bonsoir, bienvenue !'),
          VocabItem(word: 'Nasılsın? / Nasılsınız?', pronunciation: '/naˈsɯlsɯn/', definition: 'Comment vas-tu ? / vous ?', example: 'Merhaba! Nasılsınız? → Bonjour ! Comment allez-vous ?'),
          VocabItem(word: 'İyiyim, teşekkürler', pronunciation: '/ijjiim teʃekˈkyrler/', definition: 'Je vais bien, merci', example: 'Nasılsın? — İyiyim, teşekkürler. Ya sen?'),
          VocabItem(word: 'Teşekkür ederim', pronunciation: '/teʃekˈkyr ˈederim/', definition: 'Merci (formel)', example: 'Yardımınız için teşekkür ederim. → Merci pour votre aide.'),
          VocabItem(word: 'Lütfen', pronunciation: '/ˈlytfen/', definition: 'S\'il vous plaît', example: 'Bir çay lütfen. → Un thé, s\'il vous plaît.'),
          VocabItem(word: 'Hoşça kal / Güle güle', pronunciation: '/hoʃtʃa ˈkal/', definition: 'Au revoir (celui qui part / reste)', example: '"Hoşça kal!" dit celui qui part, "Güle güle!" dit celui qui reste.'),
        ],
        phoneticsExplanation: '• "Günaydın" : ü = [y] comme "u" français, ı = [ɯ] voyelle centrale sans équivalent français.\n• "İyi" : İ majuscule = i avec point, différent du ı sans point.\n• "Teşekkür" : ş = [ʃ] "ch", ü = [y].\n• "Nasılsın" : ı (sans point) = son entre [i] et [u].\n• "Lütfen" : ü = [y], comme "lune" en français.',
        usageExamples: [
          'Le matin au bureau → "Günaydın! Nasılsınız?" → "İyiyim, teşekkür ederim."',
          'Rencontrer un ami → "Hey! Merhaba! Nasılsın?" → "Süper! Sen nasılsın?"',
          'Dans un café → "Bir kahve lütfen." → "Tabii, hemen getiriyorum." → "Teşekkürler!"',
          'En partant d\'une maison → Visiteur: "Hoşça kal!" → Hôte: "Güle güle!"',
        ],
        summaryPoints: ['"Merhaba" — universel, matin et soirée', '"Günaydın" — seulement le matin', '"İyi akşamlar" — bonsoir, en arrivant', '"Nasılsın?" → informel / "Nasılsınız?" → formel', '"Hoşça kal" (partant) / "Güle güle" (restant) — unique au turc !'],
        learningMethod: 'Contextuelle + culturelle', estimatedDuration: '8 min', prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // ALLEMAND – SALUTATIONS
    // ════════════════════════════════════
    'de_cat_salutations_de': [
      LessonCourse(
        id: 'de_salutations_n1_c1', title: 'Deutsche Begrüßungen',
        language: 'Allemand', category: 'Les salutations', levelIndex: 0, courseIndex: 0,
        introduction: 'Willkommen! L\'allemand est une langue avec un système de politesse clair : tu (du) pour les proches, vous (Sie) pour les situations formelles. Les salutations varient aussi selon la région — "Guten Tag" au nord, "Grüß Gott" en Bavière !',
        objectives: ['Apprendre les salutations allemandes essentielles', 'Distinguer le du (tu) du Sie (vous)', 'Utiliser des formules adaptées au contexte'],
        vocabulary: [
          VocabItem(word: 'Guten Morgen', pronunciation: '/ˈɡuːtən ˈmɔʁɡən/', definition: 'Bonjour (matin)', example: 'Guten Morgen, Herr Müller! → Bonjour, M. Müller !'),
          VocabItem(word: 'Guten Tag', pronunciation: '/ˈɡuːtən taːk/', definition: 'Bonjour (journée)', example: 'Guten Tag, wie kann ich Ihnen helfen? → Comment puis-je vous aider ?'),
          VocabItem(word: 'Guten Abend', pronunciation: '/ˈɡuːtən ˈaːbənt/', definition: 'Bonsoir', example: 'Guten Abend! Schön, Sie zu sehen. → Bonsoir ! Ravi de vous voir.'),
          VocabItem(word: 'Hallo / Hi', pronunciation: '/ˈhalo/ /haɪ/', definition: 'Salut (informel)', example: 'Hallo Lisa! Wie geht\'s? → Salut Lisa ! Comment ça va ?'),
          VocabItem(word: 'Wie geht es Ihnen? / Wie geht\'s?', pronunciation: '/viː ɡeːt ɛs ˈiːnən/', definition: 'Comment allez-vous ? / ça va ?', example: 'Guten Morgen! Wie geht es Ihnen?'),
          VocabItem(word: 'Danke, gut!', pronunciation: '/ˈdaŋkə ɡuːt/', definition: 'Merci, bien !', example: 'Wie geht\'s? — Danke, gut! Und dir?'),
          VocabItem(word: 'Bitte', pronunciation: '/ˈbɪtə/', definition: 'S\'il vous plaît / De rien', example: 'Einen Kaffee, bitte. → Un café, s\'il vous plaît. — Bitte schön! → De rien !'),
          VocabItem(word: 'Auf Wiedersehen / Tschüss', pronunciation: '/aʊf ˈviːdɐzeːn/ /tʃyːs/', definition: 'Au revoir (formel/informel)', example: 'Auf Wiedersehen! Gute Reise! → Au revoir ! Bon voyage !'),
        ],
        phoneticsExplanation: '• "Guten" /ˈɡuːtən/ : "g" toujours occlusive [ɡ], jamais fricative.\n• "Tag" /taːk/ : "g" final → [k] en allemand (auslautverhärtung).\n• "Wie" /viː/ : "W" allemand = [v] français, long [iː].\n• "Danke" /ˈdaŋkə/ : "an" nasal + "ke" avec k dur.\n• "Tschüss" /tʃyːs/ : "tsch" = [tʃ] comme "ch" en anglais, ü = [y].',
        usageExamples: [
          'Au bureau le matin → "Guten Morgen, alle zusammen!" → "Morgen!" (réponse rapide habituelle)',
          'Avec un ami → "Hey, Hallo! Wie geht\'s?" → "Super, danke! Und dir?"',
          'Dans un magasin → "Guten Tag! Ich suche eine Jacke." → "Gerne, welche Größe?"',
          'En partant → "So, ich muss jetzt gehen. Tschüss!" → "Tschüss! Bis bald!"',
        ],
        summaryPoints: ['"Guten Morgen/Tag/Abend" — poli et formel selon l\'heure', '"Hallo" — informel universel', '"Wie geht es Ihnen?" → formel / "Wie geht\'s?" → informel', '"Auf Wiedersehen" → formel / "Tschüss" → informel', '"Bitte" = s\'il vous plaît ET de rien selon le contexte'],
        learningMethod: 'Contextuelle + culturelle', estimatedDuration: '7 min', prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // ITALIEN – SALUTATIONS
    // ════════════════════════════════════
    'it_cat_salutations_it': [
      LessonCourse(
        id: 'it_salutations_n1_c1', title: 'I saluti di base in italiano',
        language: 'Italien', category: 'Les salutations', levelIndex: 0, courseIndex: 0,
        introduction: 'Benvenuto! L\'italien est une langue très expressive, avec une grande variété de salutations selon le moment, le contexte et la proximité. "Ciao" est peut-être le mot le plus connu d\'Italie — mais il y en a tant d\'autres !',
        objectives: ['Apprendre les salutations italiennes fondamentales', 'Comprendre quand utiliser le "tu" et le "Lei" formel', 'Répondre naturellement dans une conversation'],
        vocabulary: [
          VocabItem(word: 'Ciao', pronunciation: '/tʃaʊ/', definition: 'Salut / Au revoir — très informel', example: 'Ciao Marco! Come stai? → Salut Marco ! Comment vas-tu ?'),
          VocabItem(word: 'Buongiorno', pronunciation: '/bwonˈdʒorno/', definition: 'Bonjour (matin/après-midi)', example: 'Buongiorno, dottore! → Bonjour, Docteur !'),
          VocabItem(word: 'Buona sera', pronunciation: '/ˈbwona ˈseːra/', definition: 'Bonsoir (à partir de 17h)', example: 'Buona sera! Benvenuti al ristorante. → Bonsoir ! Bienvenue au restaurant.'),
          VocabItem(word: 'Come stai? / Come sta?', pronunciation: '/ˈkoːme ˈstaɪ/', definition: 'Comment vas-tu ? / Comment allez-vous ?', example: 'Ciao! Come stai? → Salut ! Comment vas-tu ?'),
          VocabItem(word: 'Bene, grazie!', pronunciation: '/ˈbɛːne ˈɡraːtsje/', definition: 'Bien, merci !', example: 'Come stai? — Bene, grazie! E tu?'),
          VocabItem(word: 'Per favore', pronunciation: '/per faˈvoːre/', definition: 'S\'il vous plaît', example: 'Un caffè per favore! → Un café s\'il vous plaît !'),
          VocabItem(word: 'Grazie mille', pronunciation: '/ˈɡraːtsje ˈmille/', definition: 'Merci mille fois', example: 'Grazie mille per il tuo aiuto! → Merci mille fois pour ton aide !'),
          VocabItem(word: 'Arrivederci / Ciao', pronunciation: '/arriˌveˈdɛrtʃi/', definition: 'Au revoir (formel/informel)', example: 'Arrivederci! A presto! → Au revoir ! À bientôt !'),
        ],
        phoneticsExplanation: '• "Ciao" /tʃaʊ/ : "ci" = [tʃ] comme "tchi", + diphtongue [aʊ].\n• "Buongiorno" : "buon" = [bwon], "gi" = [dʒ] comme le "j" anglais.\n• "Grazie" /ˈɡraːtsje/ : "zi" = [tsj], terminaison musicale.\n• "Come" /ˈkoːme/ : "c" = [k] devant "o", "e" final prononcé.\n• "Arrivederci" : 5 syllabes — ar-ri-ve-der-ci, accent sur "der".',
        usageExamples: [
          'Entre amis → "Ciao! Come stai?" → "Tutto bene, e tu?" → "Anche io!"',
          'Au bureau → "Buongiorno a tutti! Pronti per la riunione?" → "Sì, pronti!"',
          'Dans un bar → "Buongiorno! Un cappuccino per favore." → "Subito! Grazie!"',
          'En partant → "Bene, arrivederci! A domani!" → "Ciao! A presto!"',
        ],
        summaryPoints: ['"Ciao" — universel mais informel (entre amis)', '"Buongiorno" — matin et après-midi, formel', '"Buona sera" — soir, formel', '"Come stai?" → tu / "Come sta?" → Lei formel', '"Grazie mille" — plus enthousiaste que simple "grazie"'],
        learningMethod: 'Contextuelle + culturelle', estimatedDuration: '7 min', prerequisites: 'Aucun',
      ),
    ],

    // ════════════════════════════════════
    // FRANÇAIS – SALUTATIONS
    // ════════════════════════════════════
    'fr_cat_salutations_fr': [
      LessonCourse(
        id: 'fr_salutations_n1_c1', title: 'Les salutations en français',
        language: 'Français', category: 'Les salutations', levelIndex: 0, courseIndex: 0,
        introduction: 'Les salutations françaises sont au cœur de la politesse. Le français distingue clairement le "tu" (familier) du "vous" (formel), et les salutations changent selon l\'heure de la journée. Ces formules ouvrent la porte à toute conversation.',
        objectives: ['Apprendre les salutations fondamentales en français', 'Distinguer le tu du vous', 'Savoir répondre à "Comment allez-vous ?"'],
        vocabulary: [
          VocabItem(word: 'Bonjour', pronunciation: '/bɔ̃ʒuʁ/', definition: 'Salutation universelle jusqu\'à 18h', example: 'Bonjour, madame Dupont! → Bonjour, Madame Dupont !'),
          VocabItem(word: 'Bonsoir', pronunciation: '/bɔ̃swaʁ/', definition: 'Salutation du soir (après 18h)', example: 'Bonsoir, bienvenue au restaurant. → Good evening, welcome to the restaurant.'),
          VocabItem(word: 'Salut', pronunciation: '/saly/', definition: 'Salut informel (amis)', example: 'Salut ! Ça va ? → Hey! How are you?'),
          VocabItem(word: 'Comment allez-vous ?', pronunciation: '/kɔmɑ̃ alevu/', definition: 'Comment allez-vous (formel)', example: 'Bonjour, comment allez-vous aujourd\'hui ?'),
          VocabItem(word: 'Comment vas-tu ?', pronunciation: '/kɔmɑ̃ vaty/', definition: 'Comment vas-tu (informel)', example: 'Salut ! Comment vas-tu ?'),
          VocabItem(word: 'Très bien, merci', pronunciation: '/tʁɛ bjɛ̃ mɛʁsi/', definition: 'Très bien, merci — réponse standard', example: 'Comment allez-vous ? — Très bien, merci ! Et vous ?'),
          VocabItem(word: 'S\'il vous plaît / S\'il te plaît', pronunciation: '/silvuple/ /siltəplɛ/', definition: 'Formel / informel', example: 'Un café, s\'il vous plaît. → A coffee, please.'),
          VocabItem(word: 'Au revoir / À bientôt', pronunciation: '/oʁəvwaʁ/ /abjɛ̃to/', definition: 'Au revoir / À bientôt', example: 'Au revoir! À demain! → Goodbye! See you tomorrow!'),
        ],
        phoneticsExplanation: '• "Bonjour" [bɔ̃ʒuʁ] : "on" nasal [ɔ̃], "j" = [ʒ] fricatif sonore.\n• "Bonsoir" [bɔ̃swaʁ] : "on" nasal + "soir" [swaʁ].\n• "Comment" [kɔmɑ̃] : t final muet, "en" nasalisé [ɑ̃].\n• "Merci" [mɛʁsi] : r guttural [ʁ], i final prononcé.\n• "S\'il vous plaît" [silvuple] : liaison et enchaînements fréquents en parole rapide.',
        usageExamples: [
          'Au bureau le matin → "Bonjour tout le monde !" → "Bonjour !" (collectif)',
          'Avec un ami → "Salut ! Ça fait longtemps !" → "Oui ! Comment tu vas ?"',
          'Dans un magasin → "Bonjour, je cherche une chemise bleue." → "Bonjour ! Quelle taille ?"',
          'En partant → "Bon, il faut que j\'y aille. Au revoir, à la prochaine !" → "À bientôt ! Prends soin de toi !"',
        ],
        summaryPoints: ['"Bonjour" — jusqu\'à 18h, universel', '"Bonsoir" — après 18h en arrivant quelque part', '"Salut" — uniquement entre amis ou collègues proches', '"Vous" → formel, "tu" → informel/familier', '"À bientôt / À demain / À tout à l\'heure" — selon la situation'],
        learningMethod: 'Contextuelle + culturelle', estimatedDuration: '6 min', prerequisites: 'Aucun',
      ),
    ],
  };
}
