// lib/features/lessons/data/lesson_content_data.dart
// Contenu éducatif réel par langue et par catégorie

class LessonItem {
  final String term; // Mot dans la langue cible
  final String pronunciation; // Prononciation phonétique
  final String translation; // Traduction en français (ou anglais pour cours de français)
  final String example; // Exemple de phrase
  final String emoji;

  const LessonItem({
    required this.term,
    required this.pronunciation,
    required this.translation,
    required this.example,
    required this.emoji,
  });
}

class LessonContentData {
  static Map<String, Map<String, List<LessonItem>>> content = {
    // ───────── ARABE ─────────
    'ar': {
      'cat_alphabet_ar': [
        const LessonItem(
            term: 'أ',
            pronunciation: 'Alif',
            translation: 'Lettre A',
            example: 'أسد (asad) = lion',
            emoji: '🔤'),
        const LessonItem(
            term: 'ب',
            pronunciation: 'Ba',
            translation: 'Lettre B',
            example: 'بيت (bayt) = maison',
            emoji: '🔤'),
        const LessonItem(
            term: 'ت',
            pronunciation: 'Ta',
            translation: 'Lettre T',
            example: 'تفاح (tuffāḥ) = pomme',
            emoji: '🔤'),
        const LessonItem(
            term: 'ث',
            pronunciation: "Tha",
            translation: 'Lettre Th',
            example: 'ثعلب (tha\'lab) = renard',
            emoji: '🔤'),
        const LessonItem(
            term: 'ج',
            pronunciation: 'Jeem',
            translation: 'Lettre J',
            example: 'جمل (jamal) = chameau',
            emoji: '🔤'),
        const LessonItem(
            term: 'ح',
            pronunciation: 'Ha',
            translation: 'Lettre H (aspiré)',
            example: 'حصان (ḥiṣān) = cheval',
            emoji: '🔤'),
        const LessonItem(
            term: 'خ',
            pronunciation: 'Kha',
            translation: 'Lettre Kh',
            example: 'خبز (khubz) = pain',
            emoji: '🔤'),
        const LessonItem(
            term: 'د',
            pronunciation: 'Dal',
            translation: 'Lettre D',
            example: 'دار (dār) = maison',
            emoji: '🔤'),
        const LessonItem(
            term: 'ذ',
            pronunciation: 'Dhal',
            translation: 'Lettre Dh',
            example: 'ذئب (dhi\'b) = loup',
            emoji: '🔤'),
        const LessonItem(
            term: 'ر',
            pronunciation: 'Ra',
            translation: 'Lettre R (roulé)',
            example: 'رأس (ra\'s) = tête',
            emoji: '🔤'),
      ],
      'cat_nombres_ar': [
        const LessonItem(
            term: 'صِفْر',
            pronunciation: 'ṣifr',
            translation: '0 — Zéro',
            example: 'صِفْر طالب = zéro élève',
            emoji: '0️⃣'),
        const LessonItem(
            term: 'وَاحِد',
            pronunciation: 'wāḥid',
            translation: '1 — Un',
            example: 'وَاحِد كتاب = un livre',
            emoji: '1️⃣'),
        const LessonItem(
            term: 'اثْنَان',
            pronunciation: 'ithnān',
            translation: '2 — Deux',
            example: 'اثْنَان قط = deux chats',
            emoji: '2️⃣'),
        const LessonItem(
            term: 'ثَلَاثَة',
            pronunciation: 'thalātha',
            translation: '3 — Trois',
            example: 'ثَلَاثَة أيام = trois jours',
            emoji: '3️⃣'),
        const LessonItem(
            term: 'أَرْبَعَة',
            pronunciation: 'arba\'a',
            translation: '4 — Quatre',
            example: 'أَرْبَعَة فصول = quatre saisons',
            emoji: '4️⃣'),
        const LessonItem(
            term: 'خَمْسَة',
            pronunciation: 'khamsa',
            translation: '5 — Cinq',
            example: 'خَمْسَة أصابع = cinq doigts',
            emoji: '5️⃣'),
        const LessonItem(
            term: 'سِتَّة',
            pronunciation: 'sitta',
            translation: '6 — Six',
            example: 'سِتَّة أشهر = six mois',
            emoji: '6️⃣'),
        const LessonItem(
            term: 'سَبْعَة',
            pronunciation: 'sab\'a',
            translation: '7 — Sept',
            example: 'سَبْعَة أيام = sept jours',
            emoji: '7️⃣'),
        const LessonItem(
            term: 'ثَمَانِيَة',
            pronunciation: 'thamāniya',
            translation: '8 — Huit',
            example: 'ثَمَانِيَة ساعات = huit heures',
            emoji: '8️⃣'),
        const LessonItem(
            term: 'تِسْعَة',
            pronunciation: 'tis\'a',
            translation: '9 — Neuf',
            example: 'تِسْعَة طلاب = neuf étudiants',
            emoji: '9️⃣'),
      ],
      'cat_salutations_ar': [
        const LessonItem(
            term: 'السَّلَامُ عَلَيْكُمْ',
            pronunciation: 'As-salāmu \'alaykum',
            translation: 'Bonjour / La paix sur vous',
            example: 'يُقال عند اللقاء = dit à la rencontre',
            emoji: '👋'),
        const LessonItem(
            term: 'مَرْحَبًا',
            pronunciation: 'Marḥaban',
            translation: 'Bonjour / Bienvenue',
            example: 'مَرْحَبًا بك = Bienvenue chez toi',
            emoji: '😊'),
        const LessonItem(
            term: 'كَيْفَ حَالُكَ؟',
            pronunciation: 'Kayfa ḥāluk?',
            translation: 'Comment vas-tu ?',
            example: 'كَيْفَ حَالُكَ اليوم؟ = Comment vas-tu aujourd\'hui ?',
            emoji: '🤔'),
        const LessonItem(
            term: 'بِخَيْر',
            pronunciation: 'Bikhair',
            translation: 'Bien',
            example: 'أنا بِخَيْر, شكرًا = Je vais bien, merci',
            emoji: '✅'),
        const LessonItem(
            term: 'شُكْرًا',
            pronunciation: 'Shukran',
            translation: 'Merci',
            example: 'شُكْرًا جزيلاً = Merci beaucoup',
            emoji: '🙏'),
        const LessonItem(
            term: 'مِنْ فَضْلِكَ',
            pronunciation: 'Min faḍlik',
            translation: 'S\'il vous plaît',
            example: 'مِنْ فَضْلِكَ، ساعدني = Aide-moi s\'il te plaît',
            emoji: '🙏'),
        const LessonItem(
            term: 'مَعَ السَّلَامَة',
            pronunciation: 'Ma\'a as-salāma',
            translation: 'Au revoir',
            example: 'مَعَ السَّلَامَة يا صديقي = Au revoir mon ami',
            emoji: '👋'),
        const LessonItem(
            term: 'نَعَم',
            pronunciation: 'Na\'am',
            translation: 'Oui',
            example: 'نَعَم، أنا متأكد = Oui, j\'en suis sûr',
            emoji: '✅'),
        const LessonItem(
            term: 'لَا',
            pronunciation: 'Lā',
            translation: 'Non',
            example: 'لَا، شكرًا = Non, merci',
            emoji: '❌'),
        const LessonItem(
            term: 'مَا اسْمُكَ؟',
            pronunciation: 'Mā ismuk?',
            translation: 'Comment tu t\'appelles ?',
            example: 'مَا اسْمُكَ؟ اسمي أحمد = Je m\'appelle Ahmed',
            emoji: '👤'),
      ],
      'cat_famille_ar': [
        const LessonItem(
            term: 'أَب',
            pronunciation: 'Ab',
            translation: 'Père',
            example: 'أَبِي طَبِيب = Mon père est médecin',
            emoji: '👨'),
        const LessonItem(
            term: 'أُم',
            pronunciation: 'Umm',
            translation: 'Mère',
            example: 'أُمِّي مُعَلِّمَة = Ma mère est enseignante',
            emoji: '👩'),
        const LessonItem(
            term: 'أَخ',
            pronunciation: 'Akh',
            translation: 'Frère',
            example: 'لِي أَخٌ كَبِير = J\'ai un grand frère',
            emoji: '👦'),
        const LessonItem(
            term: 'أُخْت',
            pronunciation: 'Ukht',
            translation: 'Sœur',
            example: 'أُخْتِي صَغِيرَة = Ma sœur est petite',
            emoji: '👧'),
        const LessonItem(
            term: 'جَد',
            pronunciation: 'Jadd',
            translation: 'Grand-père',
            example: 'جَدِّي كَبِير السِّنِّ = Mon grand-père est âgé',
            emoji: '👴'),
        const LessonItem(
            term: 'جَدَّة',
            pronunciation: 'Jadda',
            translation: 'Grand-mère',
            example: 'جَدَّتِي تَطْبُخ جَيِّدًا = Ma grand-mère cuisine bien',
            emoji: '👵'),
        const LessonItem(
            term: 'عَم',
            pronunciation: '\'Amm',
            translation: 'Oncle (paternel)',
            example: 'عَمِّي يَسْكُن بَعِيدًا = Mon oncle habite loin',
            emoji: '👨'),
        const LessonItem(
            term: 'عَمَّة',
            pronunciation: '\'Amma',
            translation: 'Tante (paternelle)',
            example: 'عَمَّتِي لَطِيفَة = Ma tante est gentille',
            emoji: '👩'),
        const LessonItem(
            term: 'وَلَد',
            pronunciation: 'Walad',
            translation: 'Garçon / Fils',
            example: 'هَذَا وَلَدِي = Voici mon fils',
            emoji: '👦'),
        const LessonItem(
            term: 'بِنْت',
            pronunciation: 'Bint',
            translation: 'Fille',
            example: 'هَذِهِ بِنْتِي = Voici ma fille',
            emoji: '👧'),
      ],
      'cat_couleurs_ar': [
        const LessonItem(
            term: 'أَحْمَر',
            pronunciation: 'Aḥmar',
            translation: 'Rouge',
            example: 'التُّفَّاحَة حَمْرَاء = La pomme est rouge',
            emoji: '🔴'),
        const LessonItem(
            term: 'أَزْرَق',
            pronunciation: 'Azraq',
            translation: 'Bleu',
            example: 'السَّمَاء زَرْقَاء = Le ciel est bleu',
            emoji: '🔵'),
        const LessonItem(
            term: 'أَخْضَر',
            pronunciation: 'Akhḍar',
            translation: 'Vert',
            example: 'الشَّجَرَة خَضْرَاء = L\'arbre est vert',
            emoji: '🟢'),
        const LessonItem(
            term: 'أَصْفَر',
            pronunciation: 'Aṣfar',
            translation: 'Jaune',
            example: 'الشَّمْس صَفْرَاء = Le soleil est jaune',
            emoji: '🟡'),
        const LessonItem(
            term: 'أَبْيَض',
            pronunciation: 'Abyaḍ',
            translation: 'Blanc',
            example: 'الثَّلج أَبْيَض = La neige est blanche',
            emoji: '⬜'),
        const LessonItem(
            term: 'أَسْوَد',
            pronunciation: 'Aswad',
            translation: 'Noir',
            example: 'اللَّيل أَسْوَد = La nuit est noire',
            emoji: '⬛'),
        const LessonItem(
            term: 'بُنِّي',
            pronunciation: 'Bunnī',
            translation: 'Marron',
            example: 'الخبz بُنِّي = Le pain est marron',
            emoji: '🟫'),
        const LessonItem(
            term: 'بُرْتُقَالِي',
            pronunciation: 'Burtuqālī',
            translation: 'Orange',
            example: 'البُرْتُقَالة بُرْتُقَالِيَّة = L\'orange est orange',
            emoji: '🟠'),
        const LessonItem(
            term: 'وَرْدِي',
            pronunciation: 'Wardī',
            translation: 'Rose',
            example: 'الوَرْدَة وَرْدِيَّة = La rose est rose',
            emoji: '🌸'),
        const LessonItem(
            term: 'رَمَادِي',
            pronunciation: 'Ramādī',
            translation: 'Gris',
            example: 'الغَيم رَمَادِي = Le nuage est gris',
            emoji: '🩶'),
      ],
    },
    // ───────── ANGLAIS ─────────
    'en': {
      'cat_nombres_en': [
        const LessonItem(
            term: 'Zero',
            pronunciation: 'ZI-roh',
            translation: '0 — Zéro',
            example: 'Zero mistakes! = Aucune erreur !',
            emoji: '0️⃣'),
        const LessonItem(
            term: 'One',
            pronunciation: 'WUN',
            translation: '1 — Un',
            example: 'One apple a day = Une pomme par jour',
            emoji: '1️⃣'),
        const LessonItem(
            term: 'Two',
            pronunciation: 'TOO',
            translation: '2 — Deux',
            example: 'Two cats = Deux chats',
            emoji: '2️⃣'),
        const LessonItem(
            term: 'Three',
            pronunciation: 'THRII',
            translation: '3 — Trois',
            example: 'Three days = Trois jours',
            emoji: '3️⃣'),
        const LessonItem(
            term: 'Four',
            pronunciation: 'FOR',
            translation: '4 — Quatre',
            example: 'Four seasons = Quatre saisons',
            emoji: '4️⃣'),
        const LessonItem(
            term: 'Five',
            pronunciation: 'FAYV',
            translation: '5 — Cinq',
            example: 'High five! = Tape m\'en cinq !',
            emoji: '5️⃣'),
        const LessonItem(
            term: 'Six',
            pronunciation: 'SIKS',
            translation: '6 — Six',
            example: 'Six months = Six mois',
            emoji: '6️⃣'),
        const LessonItem(
            term: 'Seven',
            pronunciation: 'SEV-en',
            translation: '7 — Sept',
            example: 'Seven days a week = Sept jours par semaine',
            emoji: '7️⃣'),
        const LessonItem(
            term: 'Eight',
            pronunciation: 'AYT',
            translation: '8 — Huit',
            example: 'Eight hours of sleep = Huit heures de sommeil',
            emoji: '8️⃣'),
        const LessonItem(
            term: 'Nine',
            pronunciation: 'NAYN',
            translation: '9 — Neuf',
            example: 'Nine lives = Neuf vies',
            emoji: '9️⃣'),
      ],
      'cat_salutations_en': [
        const LessonItem(
            term: 'Hello',
            pronunciation: 'heh-LOH',
            translation: 'Bonjour',
            example: 'Hello, how are you? = Bonjour, comment allez-vous ?',
            emoji: '👋'),
        const LessonItem(
            term: 'Good morning',
            pronunciation: 'good MOR-ning',
            translation: 'Bonjour (matin)',
            example: 'Good morning, sir! = Bonjour, monsieur !',
            emoji: '🌅'),
        const LessonItem(
            term: 'Good evening',
            pronunciation: 'good EEV-ning',
            translation: 'Bonsoir',
            example: 'Good evening, everyone! = Bonsoir tout le monde !',
            emoji: '🌆'),
        const LessonItem(
            term: 'Goodbye',
            pronunciation: 'good-BY',
            translation: 'Au revoir',
            example: 'Goodbye, see you tomorrow! = Au revoir, à demain !',
            emoji: '👋'),
        const LessonItem(
            term: 'Please',
            pronunciation: 'PLEEZ',
            translation: 'S\'il vous plaît',
            example: 'Please help me = Aidez-moi s\'il vous plaît',
            emoji: '🙏'),
        const LessonItem(
            term: 'Thank you',
            pronunciation: 'THANGK yoo',
            translation: 'Merci',
            example: 'Thank you very much! = Merci beaucoup !',
            emoji: '🙏'),
        const LessonItem(
            term: 'Yes',
            pronunciation: 'YES',
            translation: 'Oui',
            example: 'Yes, I agree = Oui, je suis d\'accord',
            emoji: '✅'),
        const LessonItem(
            term: 'No',
            pronunciation: 'NOH',
            translation: 'Non',
            example: 'No, thank you = Non, merci',
            emoji: '❌'),
        const LessonItem(
            term: 'How are you?',
            pronunciation: 'how ar YOO',
            translation: 'Comment allez-vous ?',
            example: 'Hi! How are you? = Salut ! Comment vas-tu ?',
            emoji: '🤔'),
        const LessonItem(
            term: 'I\'m fine',
            pronunciation: 'aym FAYN',
            translation: 'Je vais bien',
            example: 'I\'m fine, thanks! = Je vais bien, merci !',
            emoji: '😊'),
      ],
    },
    // ───────── ESPAGNOL ─────────
    'es': {
      'cat_nombres_es': [
        const LessonItem(
            term: 'Cero',
            pronunciation: 'THE-ro',
            translation: '0 — Zéro',
            example: 'Cero errores = Zéro erreur',
            emoji: '0️⃣'),
        const LessonItem(
            term: 'Uno',
            pronunciation: 'OO-no',
            translation: '1 — Un',
            example: 'Uno, dos, tres... = Un, deux, trois...',
            emoji: '1️⃣'),
        const LessonItem(
            term: 'Dos',
            pronunciation: 'DOSS',
            translation: '2 — Deux',
            example: 'Dos personas = Deux personnes',
            emoji: '2️⃣'),
        const LessonItem(
            term: 'Tres',
            pronunciation: 'TRAYS',
            translation: '3 — Trois',
            example: 'Tres días = Trois jours',
            emoji: '3️⃣'),
        const LessonItem(
            term: 'Cuatro',
            pronunciation: 'KWAH-tro',
            translation: '4 — Quatre',
            example: 'Cuatro estaciones = Quatre saisons',
            emoji: '4️⃣'),
        const LessonItem(
            term: 'Cinco',
            pronunciation: 'SEEN-ko',
            translation: '5 — Cinq',
            example: 'Cinco dedos = Cinq doigts',
            emoji: '5️⃣'),
        const LessonItem(
            term: 'Seis',
            pronunciation: 'SAYS',
            translation: '6 — Six',
            example: 'Seis meses = Six mois',
            emoji: '6️⃣'),
        const LessonItem(
            term: 'Siete',
            pronunciation: 'SYAY-tay',
            translation: '7 — Sept',
            example: 'Siete días = Sept jours',
            emoji: '7️⃣'),
        const LessonItem(
            term: 'Ocho',
            pronunciation: 'OH-cho',
            translation: '8 — Huit',
            example: 'Ocho horas = Huit heures',
            emoji: '8️⃣'),
        const LessonItem(
            term: 'Nueve',
            pronunciation: 'NWAY-vay',
            translation: '9 — Neuf',
            example: 'Nueve vidas = Neuf vies',
            emoji: '9️⃣'),
      ],
      'cat_salutations_es': [
        const LessonItem(
            term: 'Hola',
            pronunciation: 'OH-la',
            translation: 'Bonjour / Salut',
            example: '¡Hola! ¿Cómo estás? = Salut ! Comment vas-tu ?',
            emoji: '👋'),
        const LessonItem(
            term: 'Buenos días',
            pronunciation: 'BWAY-nos DEE-as',
            translation: 'Bonjour (matin)',
            example: '¡Buenos días, señor! = Bonjour, monsieur !',
            emoji: '🌅'),
        const LessonItem(
            term: 'Adiós',
            pronunciation: 'ah-DYOSS',
            translation: 'Au revoir',
            example: '¡Adiós! ¡Hasta luego! = Au revoir ! À bientôt !',
            emoji: '👋'),
        const LessonItem(
            term: 'Gracias',
            pronunciation: 'GRAH-syass',
            translation: 'Merci',
            example: '¡Muchas gracias! = Merci beaucoup !',
            emoji: '🙏'),
        const LessonItem(
            term: 'Por favor',
            pronunciation: 'por fa-VOR',
            translation: 'S\'il vous plaît',
            example: 'Por favor, ayúdame = Aide-moi s\'il te plaît',
            emoji: '🙏'),
        const LessonItem(
            term: 'Sí',
            pronunciation: 'SEE',
            translation: 'Oui',
            example: 'Sí, claro = Oui, bien sûr',
            emoji: '✅'),
        const LessonItem(
            term: 'No',
            pronunciation: 'NOH',
            translation: 'Non',
            example: 'No, gracias = Non, merci',
            emoji: '❌'),
        const LessonItem(
            term: '¿Cómo te llamas?',
            pronunciation: 'KOH-mo tay YAH-mass',
            translation: 'Comment tu t\'appelles ?',
            example: '¿Cómo te llamas? Me llamo Ana. = Je m\'appelle Ana.',
            emoji: '👤'),
        const LessonItem(
            term: 'Mucho gusto',
            pronunciation: 'MOO-cho GOOS-to',
            translation: 'Enchanté(e)',
            example: 'Mucho gusto en conocerte = Enchanté de te rencontrer',
            emoji: '🤝'),
        const LessonItem(
            term: '¿Cómo estás?',
            pronunciation: 'KOH-mo es-TAHSS',
            translation: 'Comment vas-tu ?',
            example: '¿Cómo estás hoy? = Comment vas-tu aujourd\'hui ?',
            emoji: '🤔'),
      ],
    },
    // ───────── FRANÇAIS ─────────
    'fr': {
      // ── L'Alphabet ───────────────────────────────────────────
      'cat_alphabet_fr': [
        const LessonItem(
            term: 'A',
            pronunciation: '[a]',
            translation: 'Letter A — vowel',
            example: 'A comme Avion ✈️',
            emoji: '🔤'),
        const LessonItem(
            term: 'E',
            pronunciation: '[ə/e/ɛ]',
            translation: 'Letter E — vowel',
            example: 'E comme École 🏫',
            emoji: '🔤'),
        const LessonItem(
            term: 'I',
            pronunciation: '[i]',
            translation: 'Letter I — vowel',
            example: 'I comme Île 🏝️',
            emoji: '🔤'),
        const LessonItem(
            term: 'O',
            pronunciation: '[o/ɔ]',
            translation: 'Letter O — vowel',
            example: 'O comme Oiseau 🐦',
            emoji: '🔤'),
        const LessonItem(
            term: 'U',
            pronunciation: '[y]',
            translation: 'Letter U — vowel',
            example: 'U comme Usine 🏭',
            emoji: '🔤'),
        const LessonItem(
            term: 'Y',
            pronunciation: '[i.gʁɛk]',
            translation: 'Letter Y — semi-vowel',
            example: 'Y comme Yeux 👀',
            emoji: '🔤'),
        const LessonItem(
            term: 'B',
            pronunciation: '[be]',
            translation: 'Letter B — consonant',
            example: 'B comme Bateau ⛵',
            emoji: '🔤'),
        const LessonItem(
            term: 'C',
            pronunciation: '[se]',
            translation: 'Letter C — consonant',
            example: 'C comme Chat 🐱',
            emoji: '🔤'),
        const LessonItem(
            term: 'D',
            pronunciation: '[de]',
            translation: 'Letter D — consonant',
            example: 'D comme Danseur 💃',
            emoji: '🔤'),
        const LessonItem(
            term: 'F',
            pronunciation: '[ɛf]',
            translation: 'Letter F — consonant',
            example: 'F comme Forêt 🌲',
            emoji: '🔤'),
      ],

      // ── Les Nombres ──────────────────────────────────────────
      'cat_nombres_fr': [
        const LessonItem(
            term: 'Zéro',
            pronunciation: '[ze.ʁo]',
            translation: '0 — Zero',
            example: 'J\'ai zéro idée pour ce soir.',
            emoji: '0️⃣'),
        const LessonItem(
            term: 'Un',
            pronunciation: '[œ̃]',
            translation: '1 — One',
            example: 'Il reste un billet.',
            emoji: '1️⃣'),
        const LessonItem(
            term: 'Deux',
            pronunciation: '[dø]',
            translation: '2 — Two',
            example: 'Deux cafés, s\'il vous plaît !',
            emoji: '2️⃣'),
        const LessonItem(
            term: 'Trois',
            pronunciation: '[tʁwa]',
            translation: '3 — Three',
            example: 'Il y a trois erreurs ici.',
            emoji: '3️⃣'),
        const LessonItem(
            term: 'Quatre',
            pronunciation: '[katʁ]',
            translation: '4 — Four',
            example: 'J\'ai quatre frères.',
            emoji: '4️⃣'),
        const LessonItem(
            term: 'Cinq',
            pronunciation: '[sɛ̃k]',
            translation: '5 — Five',
            example: 'Cinq doigts à chaque main.',
            emoji: '5️⃣'),
        const LessonItem(
            term: 'Six',
            pronunciation: '[sis]',
            translation: '6 — Six',
            example: 'Six mois se sont écoulés.',
            emoji: '6️⃣'),
        const LessonItem(
            term: 'Sept',
            pronunciation: '[sɛt]',
            translation: '7 — Seven',
            example: 'Sept jours dans la semaine.',
            emoji: '7️⃣'),
        const LessonItem(
            term: 'Huit',
            pronunciation: '[ɥit]',
            translation: '8 — Eight',
            example: 'Huit heures de sommeil chaque nuit.',
            emoji: '8️⃣'),
        const LessonItem(
            term: 'Neuf',
            pronunciation: '[nœf]',
            translation: '9 — Nine',
            example: 'Un chat a neuf vies.',
            emoji: '9️⃣'),
      ],

      // ── Les Salutations ──────────────────────────────────────
      'cat_salutations_fr': [
        const LessonItem(
            term: 'Bonjour',
            pronunciation: '[bɔ̃.ʒuʁ]',
            translation: 'Good morning / Hello',
            example: 'Bonjour ! Bien dormi ?',
            emoji: '🌅'),
        const LessonItem(
            term: 'Bonsoir',
            pronunciation: '[bɔ̃.swaʁ]',
            translation: 'Good evening',
            example: 'Bonsoir, bienvenue au restaurant.',
            emoji: '🌆'),
        const LessonItem(
            term: 'Salut',
            pronunciation: '[sa.ly]',
            translation: 'Hi / Hey',
            example: 'Salut ! Ça fait longtemps !',
            emoji: '👋'),
        const LessonItem(
            term: 'Au revoir',
            pronunciation: '[o.ʁe.vwaʁ]',
            translation: 'Goodbye',
            example: 'Au revoir, à lundi !',
            emoji: '👋'),
        const LessonItem(
            term: 'Merci',
            pronunciation: '[mɛʁ.si]',
            translation: 'Thank you',
            example: 'Merci pour votre aide.',
            emoji: '🙏'),
        const LessonItem(
            term: 'De rien',
            pronunciation: '[də.ʁjɛ̃]',
            translation: 'You\'re welcome',
            example: 'Merci ! — De rien !',
            emoji: '😊'),
        const LessonItem(
            term: 'S\'il vous plaît',
            pronunciation: '[sil.vu.plɛ]',
            translation: 'Please (formal)',
            example: 'Un café, s\'il vous plaît.',
            emoji: '🙏'),
        const LessonItem(
            term: 'Comment allez-vous ?',
            pronunciation: '[kɔ.mɑ̃.ta.le.vu]',
            translation: 'How are you? (formal)',
            example: 'Bonjour ! Comment allez-vous ?',
            emoji: '🤔'),
        const LessonItem(
            term: 'Je vais bien',
            pronunciation: '[ʒə.vɛ.bjɛ̃]',
            translation: 'I am fine',
            example: 'Je vais bien, merci beaucoup !',
            emoji: '😊'),
        const LessonItem(
            term: 'Enchanté(e)',
            pronunciation: '[ɑ̃.ʃɑ̃.te]',
            translation: 'Nice to meet you',
            example: 'Je m\'appelle Sophie. — Enchanté !',
            emoji: '🤝'),
      ],

      // ── La Famille ───────────────────────────────────────────
      'cat_famille_fr': [
        const LessonItem(
            term: 'Le père',
            pronunciation: '[lə.pɛʁ]',
            translation: 'The father',
            example: 'Mon père est médecin.',
            emoji: '👨'),
        const LessonItem(
            term: 'La mère',
            pronunciation: '[la.mɛʁ]',
            translation: 'The mother',
            example: 'Ma mère fait la cuisine.',
            emoji: '👩'),
        const LessonItem(
            term: 'Le frère',
            pronunciation: '[lə.fʁɛʁ]',
            translation: 'The brother',
            example: 'J\'ai un grand frère.',
            emoji: '👦'),
        const LessonItem(
            term: 'La sœur',
            pronunciation: '[la.sœʁ]',
            translation: 'The sister',
            example: 'Ma sœur est au lycée.',
            emoji: '👧'),
        const LessonItem(
            term: 'Le grand-père',
            pronunciation: '[lə.gʁɑ̃.pɛʁ]',
            translation: 'The grandfather',
            example: 'Mon grand-père a 75 ans.',
            emoji: '👴'),
        const LessonItem(
            term: 'La grand-mère',
            pronunciation: '[la.gʁɑ̃.mɛʁ]',
            translation: 'The grandmother',
            example: 'Ma grand-mère fait d\'excellentes tartes.',
            emoji: '👵'),
        const LessonItem(
            term: 'L\'oncle',
            pronunciation: '[lɔ̃kl]',
            translation: 'The uncle',
            example: 'Mon oncle vit à Lyon.',
            emoji: '🧔'),
        const LessonItem(
            term: 'La tante',
            pronunciation: '[la.tɑ̃t]',
            translation: 'The aunt',
            example: 'Ma tante est très gentille.',
            emoji: '👩'),
        const LessonItem(
            term: 'Le fils',
            pronunciation: '[lə.fis]',
            translation: 'The son',
            example: 'Voici mon fils, il a 10 ans.',
            emoji: '👦'),
        const LessonItem(
            term: 'La fille',
            pronunciation: '[la.fij]',
            translation: 'The daughter',
            example: 'Sa fille est très intelligente.',
            emoji: '👧'),
      ],

      // ── Les Couleurs ─────────────────────────────────────────
      'cat_couleurs_fr': [
        const LessonItem(
            term: 'Rouge',
            pronunciation: '[ʁuʒ]',
            translation: 'Red',
            example: 'Une pomme rouge.',
            emoji: '🔴'),
        const LessonItem(
            term: 'Bleu',
            pronunciation: '[blø]',
            translation: 'Blue',
            example: 'Le ciel est bleu.',
            emoji: '🔵'),
        const LessonItem(
            term: 'Vert',
            pronunciation: '[vɛʁ]',
            translation: 'Green',
            example: 'L\'herbe est verte.',
            emoji: '🟢'),
        const LessonItem(
            term: 'Jaune',
            pronunciation: '[ʒon]',
            translation: 'Yellow',
            example: 'Un citron jaune.',
            emoji: '🟡'),
        const LessonItem(
            term: 'Orange',
            pronunciation: '[ɔ.ʁɑ̃ʒ]',
            translation: 'Orange',
            example: 'Une orange orange !',
            emoji: '🟠'),
        const LessonItem(
            term: 'Violet',
            pronunciation: '[vjɔ.lɛ]',
            translation: 'Purple',
            example: 'Une fleur violette.',
            emoji: '🟣'),
        const LessonItem(
            term: 'Rose',
            pronunciation: '[ʁoz]',
            translation: 'Pink',
            example: 'Un flamant rose.',
            emoji: '🌸'),
        const LessonItem(
            term: 'Noir',
            pronunciation: '[nwaʁ]',
            translation: 'Black',
            example: 'Un chat noir porte bonheur.',
            emoji: '⬛'),
        const LessonItem(
            term: 'Blanc',
            pronunciation: '[blɑ̃]',
            translation: 'White',
            example: 'La neige est blanche.',
            emoji: '⬜'),
        const LessonItem(
            term: 'Gris',
            pronunciation: '[gʁi]',
            translation: 'Grey',
            example: 'Un ciel gris en automne.',
            emoji: '🩶'),
      ],

      // ── Les Jours ────────────────────────────────────────────
      'cat_jours_fr': [
        const LessonItem(
            term: 'Lundi',
            pronunciation: '[lœ̃.di]',
            translation: 'Monday',
            example: 'Lundi, retour au travail !',
            emoji: '📅'),
        const LessonItem(
            term: 'Mardi',
            pronunciation: '[maʁ.di]',
            translation: 'Tuesday',
            example: 'On se voit mardi ?',
            emoji: '📅'),
        const LessonItem(
            term: 'Mercredi',
            pronunciation: '[mɛʁ.kʁe.di]',
            translation: 'Wednesday',
            example: 'Mercredi, pas d\'école !',
            emoji: '📅'),
        const LessonItem(
            term: 'Jeudi',
            pronunciation: '[ʒø.di]',
            translation: 'Thursday',
            example: 'Jeudi soir, ciné !',
            emoji: '📅'),
        const LessonItem(
            term: 'Vendredi',
            pronunciation: '[vɑ̃.dʁe.di]',
            translation: 'Friday',
            example: 'Vendredi, fin de la semaine !',
            emoji: '🎉'),
        const LessonItem(
            term: 'Samedi',
            pronunciation: '[sam.di]',
            translation: 'Saturday',
            example: 'Samedi marché au village.',
            emoji: '🛍️'),
        const LessonItem(
            term: 'Dimanche',
            pronunciation: '[di.mɑ̃ʃ]',
            translation: 'Sunday',
            example: 'Dimanche, repos et famille.',
            emoji: '☀️'),
        const LessonItem(
            term: 'Aujourd\'hui',
            pronunciation: '[o.ʒuʁ.dɥi]',
            translation: 'Today',
            example: 'Aujourd\'hui c\'est lundi.',
            emoji: '📆'),
        const LessonItem(
            term: 'Demain',
            pronunciation: '[də.mɛ̃]',
            translation: 'Tomorrow',
            example: 'À demain !',
            emoji: '⏭️'),
        const LessonItem(
            term: 'Hier',
            pronunciation: '[jɛʁ]',
            translation: 'Yesterday',
            example: 'Hier il faisait beau.',
            emoji: '⏮️'),
      ],

      // ── Les Animaux ──────────────────────────────────────────
      'cat_animaux_fr': [
        const LessonItem(
            term: 'Le chien',
            pronunciation: '[lə.ʃjɛ̃]',
            translation: 'The dog',
            example: 'Mon chien s\'appelle Rex.',
            emoji: '🐕'),
        const LessonItem(
            term: 'Le chat',
            pronunciation: '[lə.ʃa]',
            translation: 'The cat',
            example: 'Le chat dort sur le canapé.',
            emoji: '🐈'),
        const LessonItem(
            term: 'L\'oiseau',
            pronunciation: '[lwa.zo]',
            translation: 'The bird',
            example: 'L\'oiseau chante le matin.',
            emoji: '🐦'),
        const LessonItem(
            term: 'Le cheval',
            pronunciation: '[lə.ʃval]',
            translation: 'The horse',
            example: 'Le cheval court dans le pré.',
            emoji: '🐴'),
        const LessonItem(
            term: 'La vache',
            pronunciation: '[la.vaʃ]',
            translation: 'The cow',
            example: 'La vache donne du lait.',
            emoji: '🐄'),
        const LessonItem(
            term: 'Le lapin',
            pronunciation: '[lə.lapɛ̃]',
            translation: 'The rabbit',
            example: 'Le lapin mange des carottes.',
            emoji: '🐇'),
        const LessonItem(
            term: 'Le poisson',
            pronunciation: '[lə.pwa.sɔ̃]',
            translation: 'The fish',
            example: 'Le poisson nage dans l\'aquarium.',
            emoji: '🐟'),
        const LessonItem(
            term: 'L\'éléphant',
            pronunciation: '[le.le.fɑ̃]',
            translation: 'The elephant',
            example: 'L\'éléphant est le plus grand animal terrestre.',
            emoji: '🐘'),
        const LessonItem(
            term: 'Le lion',
            pronunciation: '[lə.ljɔ̃]',
            translation: 'The lion',
            example: 'Le lion rugit dans la savane.',
            emoji: '🦁'),
        const LessonItem(
            term: 'Le canard',
            pronunciation: '[lə.ka.naʁ]',
            translation: 'The duck',
            example: 'Le canard barbote dans l\'eau.',
            emoji: '🦆'),
      ],

      // ── Les Aliments ─────────────────────────────────────────
      'cat_aliments_fr': [
        const LessonItem(
            term: 'Le pain',
            pronunciation: '[lə.pɛ̃]',
            translation: 'The bread',
            example: 'Je mange du pain au petit-déjeuner.',
            emoji: '🍞'),
        const LessonItem(
            term: 'Le lait',
            pronunciation: '[lə.lɛ]',
            translation: 'The milk',
            example: 'Un verre de lait froid.',
            emoji: '🥛'),
        const LessonItem(
            term: 'Le café',
            pronunciation: '[lə.ka.fe]',
            translation: 'The coffee',
            example: 'Un café, s\'il vous plaît.',
            emoji: '☕'),
        const LessonItem(
            term: 'La pomme',
            pronunciation: '[la.pɔm]',
            translation: 'The apple',
            example: 'Une pomme par jour éloigne le médecin.',
            emoji: '🍎'),
        const LessonItem(
            term: 'Le fromage',
            pronunciation: '[lə.fʁo.maʒ]',
            translation: 'The cheese',
            example: 'La France produit 1000 fromages.',
            emoji: '🧀'),
        const LessonItem(
            term: 'Le poulet',
            pronunciation: '[lə.pu.lɛ]',
            translation: 'The chicken',
            example: 'Du poulet rôti pour ce soir.',
            emoji: '🍗'),
        const LessonItem(
            term: 'L\'eau',
            pronunciation: '[lo]',
            translation: 'The water',
            example: 'Boire de l\'eau chaque jour.',
            emoji: '💧'),
        const LessonItem(
            term: 'Le riz',
            pronunciation: '[lə.ʁi]',
            translation: 'The rice',
            example: 'Du riz avec des légumes.',
            emoji: '🍚'),
        const LessonItem(
            term: 'La tomate',
            pronunciation: '[la.tɔ.mat]',
            translation: 'The tomato',
            example: 'Une tomate bien rouge et juteuse.',
            emoji: '🍅'),
        const LessonItem(
            term: 'Le chocolat',
            pronunciation: '[lə.ʃɔ.kɔ.la]',
            translation: 'The chocolate',
            example: 'Un carré de chocolat noir.',
            emoji: '🍫'),
      ],

      // ── Les Verbes de Base ───────────────────────────────────
      'cat_verbes_fr': [
        const LessonItem(
            term: 'Être',
            pronunciation: '[ɛtʁ]',
            translation: 'To be',
            example: 'Je suis français.',
            emoji: '🔵'),
        const LessonItem(
            term: 'Avoir',
            pronunciation: '[a.vwaʁ]',
            translation: 'To have',
            example: 'J\'ai deux enfants.',
            emoji: '🤲'),
        const LessonItem(
            term: 'Aller',
            pronunciation: '[a.le]',
            translation: 'To go',
            example: 'Je vais à Paris demain.',
            emoji: '🚶'),
        const LessonItem(
            term: 'Faire',
            pronunciation: '[fɛʁ]',
            translation: 'To do / make',
            example: 'Je fais du sport le matin.',
            emoji: '💪'),
        const LessonItem(
            term: 'Manger',
            pronunciation: '[mɑ̃.ʒe]',
            translation: 'To eat',
            example: 'Nous mangeons à midi.',
            emoji: '🍽️'),
        const LessonItem(
            term: 'Boire',
            pronunciation: '[bwaʁ]',
            translation: 'To drink',
            example: 'Il boit un verre d\'eau.',
            emoji: '🥤'),
        const LessonItem(
            term: 'Parler',
            pronunciation: '[paʁ.le]',
            translation: 'To speak',
            example: 'Elle parle trois langues.',
            emoji: '💬'),
        const LessonItem(
            term: 'Aimer',
            pronunciation: '[ɛ.me]',
            translation: 'To love / like',
            example: 'J\'aime la musique classique.',
            emoji: '❤️'),
        const LessonItem(
            term: 'Vouloir',
            pronunciation: '[vu.lwaʁ]',
            translation: 'To want',
            example: 'Je veux apprendre le français.',
            emoji: '🌟'),
        const LessonItem(
            term: 'Dormir',
            pronunciation: '[dɔʁ.miʁ]',
            translation: 'To sleep',
            example: 'Il dort huit heures par nuit.',
            emoji: '😴'),
      ],

      // ── Les Mois ─────────────────────────────────────────────
      'cat_mois_fr': [
        const LessonItem(
            term: 'Janvier',
            pronunciation: '[ʒɑ̃.vje]',
            translation: 'January',
            example: 'Janvier est le premier mois de l\'année.',
            emoji: '❄️'),
        const LessonItem(
            term: 'Février',
            pronunciation: '[fe.vʁije]',
            translation: 'February',
            example: 'Février est le mois le plus court.',
            emoji: '💝'),
        const LessonItem(
            term: 'Mars',
            pronunciation: '[maʁs]',
            translation: 'March',
            example: 'En mars, le printemps arrive.',
            emoji: '🌱'),
        const LessonItem(
            term: 'Avril',
            pronunciation: '[avʁil]',
            translation: 'April',
            example: 'En avril, ne te découvre pas d\'un fil !',
            emoji: '🌸'),
        const LessonItem(
            term: 'Mai',
            pronunciation: '[mɛ]',
            translation: 'May',
            example: 'Le muguet symbolise le 1er mai.',
            emoji: '🌼'),
        const LessonItem(
            term: 'Juin',
            pronunciation: '[ʒɥɛ̃]',
            translation: 'June',
            example: 'Juin marque le début de l\'été.',
            emoji: '☀️'),
        const LessonItem(
            term: 'Juillet',
            pronunciation: '[ʒɥijɛ]',
            translation: 'July',
            example: 'Le 14 juillet est la fête nationale française.',
            emoji: '🎆'),
        const LessonItem(
            term: 'Août',
            pronunciation: '[u]',
            translation: 'August',
            example: 'En août, tout le monde est en vacances.',
            emoji: '🏖️'),
        const LessonItem(
            term: 'Septembre',
            pronunciation: '[sɛp.tɑ̃bʁ]',
            translation: 'September',
            example: 'La rentrée scolaire est en septembre.',
            emoji: '📚'),
        const LessonItem(
            term: 'Octobre',
            pronunciation: '[ɔk.tɔbʁ]',
            translation: 'October',
            example: 'En octobre, les feuilles tombent des arbres.',
            emoji: '🍂'),
      ],
    },
    // ───────── TURC ─────────
    'tr': {
      'cat_nombres_tr': [
        const LessonItem(
            term: 'Sıfır',
            pronunciation: 'sı-fır',
            translation: '0 — Zéro',
            example: 'Sıfır hata.',
            emoji: '0️⃣'),
        const LessonItem(
            term: 'Bir',
            pronunciation: 'bir',
            translation: '1 — Un',
            example: 'Bir elma yedim.',
            emoji: '1️⃣'),
        const LessonItem(
            term: 'İki',
            pronunciation: 'i-ki',
            translation: '2 — Deux',
            example: 'İki kitap okudum.',
            emoji: '2️⃣'),
        const LessonItem(
            term: 'Üç',
            pronunciation: 'üç',
            translation: '3 — Trois',
            example: 'Üç kardeşiz.',
            emoji: '3️⃣'),
        const LessonItem(
            term: 'Dört',
            pronunciation: 'dört',
            translation: '4 — Quatre',
            example: 'Dört mevsim var.',
            emoji: '4️⃣'),
        const LessonItem(
            term: 'Beş',
            pronunciation: 'beş',
            translation: '5 — Cinq',
            example: 'Beş parmağım var.',
            emoji: '5️⃣'),
      ],
      'cat_salutations_tr': [
        const LessonItem(
            term: 'Merhaba',
            pronunciation: 'mer-ha-ba',
            translation: 'Bonjour / Hello',
            example: 'Merhaba, nasılsın? = Salut, comment vas-tu ?',
            emoji: '👋'),
        const LessonItem(
            term: 'Selam',
            pronunciation: 'se-lam',
            translation: 'Salut / Hi',
            example: 'Selam arkadaşlar!',
            emoji: '👋'),
        const LessonItem(
            term: 'Güle güle',
            pronunciation: 'gü-le gü-le',
            translation: 'Au revoir',
            example: 'Güle güle, yine bekleriz!',
            emoji: '👋'),
        const LessonItem(
            term: 'Teşekkür ederim',
            pronunciation: 'te-shek-kür e-de-rim',
            translation: 'Merci',
            example: 'Yardımın için teşekkür ederim.',
            emoji: '🙏'),
        const LessonItem(
            term: 'Lütfen',
            pronunciation: 'lüt-fen',
            translation: 'S\'il vous plaît',
            example: 'Lütfen buraya gel.',
            emoji: '🙏'),
        const LessonItem(
            term: 'Evet',
            pronunciation: 'e-vet',
            translation: 'Oui',
            example: 'Evet, geliyorum.',
            emoji: '✅'),
        const LessonItem(
            term: 'Hayır',
            pronunciation: 'ha-yır',
            translation: 'Non',
            example: 'Hayır, istemiyorum.',
            emoji: '❌'),
        const LessonItem(
            term: 'Nasılsın?',
            pronunciation: 'na-sıl-sın',
            translation: 'Comment vas-tu ?',
            example: 'Nasılsın bugün?',
            emoji: '🤔'),
        const LessonItem(
            term: 'İyiyim',
            pronunciation: 'i-yi-yim',
            translation: 'Je vais bien',
            example: 'İyiyim, teşekkürler.',
            emoji: '😊'),
        const LessonItem(
            term: 'Adın ne?',
            pronunciation: 'a-dın ne',
            translation: 'Comment t\'appelles-tu ?',
            example: 'Adın ne? Benim adım Elif.',
            emoji: '👤'),
      ],
    },
    // ───────── ALLEMAND ─────────
    'de': {
      'cat_nombres_de': [
        const LessonItem(
            term: 'Null',
            pronunciation: 'NOOL',
            translation: '0 — Zéro',
            example: 'Null Fehler = Zéro erreur',
            emoji: '0️⃣'),
        const LessonItem(
            term: 'Eins',
            pronunciation: 'AYNS',
            translation: '1 — Un',
            example: 'Eins, zwei, drei = Un, deux, trois',
            emoji: '1️⃣'),
        const LessonItem(
            term: 'Zwei',
            pronunciation: 'TSVAY',
            translation: '2 — Deux',
            example: 'Zwei Katzen = Deux chats',
            emoji: '2️⃣'),
        const LessonItem(
            term: 'Drei',
            pronunciation: 'DRAY',
            translation: '3 — Trois',
            example: 'Drei Tage = Trois jours',
            emoji: '3️⃣'),
        const LessonItem(
            term: 'Vier',
            pronunciation: 'FEER',
            translation: '4 — Quatre',
            example: 'Vier Jahreszeiten = Quatre saisons',
            emoji: '4️⃣'),
        const LessonItem(
            term: 'Fünf',
            pronunciation: 'FÜNF',
            translation: '5 — Cinq',
            example: 'Fünf Finger = Cinq doigts',
            emoji: '5️⃣'),
        const LessonItem(
            term: 'Sechs',
            pronunciation: 'ZEKS',
            translation: '6 — Six',
            example: 'Sechs Monate = Six mois',
            emoji: '6️⃣'),
        const LessonItem(
            term: 'Sieben',
            pronunciation: 'ZEE-ben',
            translation: '7 — Sept',
            example: 'Sieben Tage = Sept jours',
            emoji: '7️⃣'),
        const LessonItem(
            term: 'Acht',
            pronunciation: 'AKHT',
            translation: '8 — Huit',
            example: 'Acht Stunden = Huit heures',
            emoji: '8️⃣'),
        const LessonItem(
            term: 'Neun',
            pronunciation: 'NOYN',
            translation: '9 — Neuf',
            example: 'Neun Leben = Neuf vies',
            emoji: '9️⃣'),
      ],
      'cat_salutations_de': [
        const LessonItem(
            term: 'Hallo',
            pronunciation: 'HA-lo',
            translation: 'Bonjour / Salut',
            example: 'Hallo! Wie geht\'s? = Salut ! Comment ça va ?',
            emoji: '👋'),
        const LessonItem(
            term: 'Guten Morgen',
            pronunciation: 'GOO-ten MOR-gen',
            translation: 'Bonjour (matin)',
            example: 'Guten Morgen, Herr Müller! = Bonjour, M. Müller !',
            emoji: '🌅'),
        const LessonItem(
            term: 'Danke',
            pronunciation: 'DANK-uh',
            translation: 'Merci',
            example: 'Danke schön! = Merci beaucoup !',
            emoji: '🙏'),
        const LessonItem(
            term: 'Bitte',
            pronunciation: 'BIT-uh',
            translation: 'S\'il vous plaît / De rien',
            example: 'Bitte hilf mir = Aide-moi s\'il te plaît',
            emoji: '🙏'),
        const LessonItem(
            term: 'Ja',
            pronunciation: 'YAH',
            translation: 'Oui',
            example: 'Ja, natürlich! = Oui, bien sûr !',
            emoji: '✅'),
        const LessonItem(
            term: 'Nein',
            pronunciation: 'NAYN',
            translation: 'Non',
            example: 'Nein, danke = Non, merci',
            emoji: '❌'),
        const LessonItem(
            term: 'Auf Wiedersehen',
            pronunciation: 'owf VEE-der-zayn',
            translation: 'Au revoir',
            example: 'Auf Wiedersehen! Tschüss! = Au revoir !',
            emoji: '👋'),
        const LessonItem(
            term: 'Wie geht es Ihnen?',
            pronunciation: 'vee gayt es EE-nen',
            translation: 'Comment allez-vous ?',
            example: 'Wie geht es Ihnen heute? = Comment allez-vous aujourd\'hui ?',
            emoji: '🤔'),
        const LessonItem(
            term: 'Mir geht\'s gut',
            pronunciation: 'meer gayts goot',
            translation: 'Je vais bien',
            example: 'Mir geht\'s gut, danke! = Je vais bien, merci !',
            emoji: '😊'),
        const LessonItem(
            term: 'Wie heißen Sie?',
            pronunciation: 'vee HY-sen zee',
            translation: 'Comment vous appelez-vous ?',
            example: 'Wie heißen Sie? Ich heiße Anna = Je m\'appelle Anna',
            emoji: '👤'),
      ],
    },
    // ───────── ITALIEN ─────────
    'it': {
      'cat_nombres_it': [
        const LessonItem(
            term: 'Zero',
            pronunciation: 'DZE-ro',
            translation: '0 — Zéro',
            example: 'Zero errori = Zéro erreur',
            emoji: '0️⃣'),
        const LessonItem(
            term: 'Uno',
            pronunciation: 'OO-no',
            translation: '1 — Un',
            example: 'Uno, due, tre = Un, deux, trois',
            emoji: '1️⃣'),
        const LessonItem(
            term: 'Due',
            pronunciation: 'DOO-eh',
            translation: '2 — Deux',
            example: 'Due gatti = Deux chats',
            emoji: '2️⃣'),
        const LessonItem(
            term: 'Tre',
            pronunciation: 'TRAY',
            translation: '3 — Trois',
            example: 'Tre giorni = Trois jours',
            emoji: '3️⃣'),
        const LessonItem(
            term: 'Quattro',
            pronunciation: 'KWAT-tro',
            translation: '4 — Quatre',
            example: 'Quattro stagioni = Quatre saisons',
            emoji: '4️⃣'),
        const LessonItem(
            term: 'Cinque',
            pronunciation: 'CHEEN-kweh',
            translation: '5 — Cinq',
            example: 'Cinque dita = Cinq doigts',
            emoji: '5️⃣'),
        const LessonItem(
            term: 'Sei',
            pronunciation: 'SAY',
            translation: '6 — Six',
            example: 'Sei mesi = Six mois',
            emoji: '6️⃣'),
        const LessonItem(
            term: 'Sette',
            pronunciation: 'SET-teh',
            translation: '7 — Sept',
            example: 'Sette giorni = Sept jours',
            emoji: '7️⃣'),
        const LessonItem(
            term: 'Otto',
            pronunciation: 'OT-to',
            translation: '8 — Huit',
            example: 'Otto ore = Huit heures',
            emoji: '8️⃣'),
        const LessonItem(
            term: 'Nove',
            pronunciation: 'NO-veh',
            translation: '9 — Neuf',
            example: 'Nove vite = Neuf vies',
            emoji: '9️⃣'),
      ],
      'cat_salutations_it': [
        const LessonItem(
            term: 'Ciao',
            pronunciation: 'CHOW',
            translation: 'Salut / Au revoir',
            example: 'Ciao! Come stai? = Salut ! Comment vas-tu ?',
            emoji: '👋'),
        const LessonItem(
            term: 'Buongiorno',
            pronunciation: 'bwon-JOR-no',
            translation: 'Bonjour',
            example: 'Buongiorno, professore! = Bonjour, professeur !',
            emoji: '🌅'),
        const LessonItem(
            term: 'Grazie',
            pronunciation: 'GRAT-syeh',
            translation: 'Merci',
            example: 'Grazie mille! = Merci mille fois !',
            emoji: '🙏'),
        const LessonItem(
            term: 'Per favore',
            pronunciation: 'per fa-VO-reh',
            translation: 'S\'il vous plaît',
            example: 'Aiutami, per favore = Aide-moi s\'il te plaît',
            emoji: '🙏'),
        const LessonItem(
            term: 'Sì',
            pronunciation: 'SEE',
            translation: 'Oui',
            example: 'Sì, certo! = Oui, bien sûr !',
            emoji: '✅'),
        const LessonItem(
            term: 'No',
            pronunciation: 'NOH',
            translation: 'Non',
            example: 'No, grazie = Non, merci',
            emoji: '❌'),
        const LessonItem(
            term: 'Arrivederci',
            pronunciation: 'ar-ree-veh-DER-chee',
            translation: 'Au revoir',
            example: 'Arrivederci! A presto! = Au revoir ! À bientôt !',
            emoji: '👋'),
        const LessonItem(
            term: 'Come stai?',
            pronunciation: 'KO-meh STAI',
            translation: 'Comment vas-tu ?',
            example: 'Come stai oggi? = Comment vas-tu aujourd\'hui ?',
            emoji: '🤔'),
        const LessonItem(
            term: 'Sto bene',
            pronunciation: 'STO BEH-neh',
            translation: 'Je vais bien',
            example: 'Sto bene, grazie! = Je vais bien, merci !',
            emoji: '😊'),
        const LessonItem(
            term: 'Come ti chiami?',
            pronunciation: 'KO-meh tee KYAH-mee',
            translation: 'Comment tu t\'appelles ?',
            example: 'Come ti chiami? Mi chiamo Marco = Je m\'appelle Marco',
            emoji: '👤'),
      ],
    },
  };

  /// Retourne la liste des items de contenu pour une langue et une catégorie données.
  /// Fait un fallback intelligent sur la catégorie générique si la langue spécifique n'est pas trouvée.
  static List<LessonItem> getItems(String languageId, String categoryId) {
    final langContent = content[languageId];
    if (langContent == null) return _defaultItems(categoryId);

    // Try to match by categoryId directly
    if (langContent.containsKey(categoryId)) return langContent[categoryId]!;

    // Try to find by category type (nombres, salutations, etc.)
    for (final key in langContent.keys) {
      if (categoryId.contains('nombres') && key.contains('nombres')) return langContent[key]!;
      if (categoryId.contains('salutations') && key.contains('salutations'))
        return langContent[key]!;
      if (categoryId.contains('alphabet') && key.contains('alphabet')) return langContent[key]!;
      if (categoryId.contains('famille') && key.contains('famille')) return langContent[key]!;
      if (categoryId.contains('couleurs') && key.contains('couleurs')) return langContent[key]!;
    }

    return _defaultItems(categoryId);
  }

  /// Retourne tous les items d'une langue (pour les distracteurs cross-catégorie).
  static List<LessonItem> getAllItemsForLanguage(String languageId) {
    final langContent = content[languageId];
    if (langContent == null) return _defaultItems('all').take(10).toList();
    return langContent.values.expand((list) => list).toList();
  }

  static List<LessonItem> _defaultItems(String categoryId) {
    if (categoryId.contains('nombres')) {
      return [
        const LessonItem(
            term: '0',
            pronunciation: 'Zéro',
            translation: '0 — Zéro',
            example: 'Zéro = le début de tout',
            emoji: '0️⃣'),
        const LessonItem(
            term: '1',
            pronunciation: 'Un',
            translation: '1 — Un',
            example: 'Un = l\'unité',
            emoji: '1️⃣'),
        const LessonItem(
            term: '2',
            pronunciation: 'Deux',
            translation: '2 — Deux',
            example: 'Deux = une paire',
            emoji: '2️⃣'),
        const LessonItem(
            term: '3',
            pronunciation: 'Trois',
            translation: '3 — Trois',
            example: 'Trois = un trio',
            emoji: '3️⃣'),
        const LessonItem(
            term: '4',
            pronunciation: 'Quatre',
            translation: '4 — Quatre',
            example: 'Quatre = les quatre coins',
            emoji: '4️⃣'),
      ];
    }
    return [
      const LessonItem(
          term: '📚',
          pronunciation: '--',
          translation: 'Contenu bientôt disponible',
          example: 'Revenez plus tard pour accéder à ce cours !',
          emoji: '🔜'),
      const LessonItem(
          term: 'Bonjour',
          pronunciation: '...',
          translation: 'Hello',
          example: 'Bonjour !',
          emoji: '👋'),
      const LessonItem(
          term: 'Merci',
          pronunciation: '...',
          translation: 'Thank you',
          example: 'Merci beaucoup !',
          emoji: '🙏'),
    ];
  }
}
