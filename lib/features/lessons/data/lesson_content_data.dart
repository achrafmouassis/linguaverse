// lib/features/lessons/data/lesson_content_data.dart
// Contenu éducatif réel par langue et par catégorie

class LessonItem {
  final String term;          // Mot dans la langue cible
  final String pronunciation; // Prononciation phonétique
  final String translation;   // Traduction en français (ou anglais pour cours de français)
  final String example;       // Exemple de phrase
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
        LessonItem(term: 'أ', pronunciation: 'Alif', translation: 'Lettre A', example: 'أسد (asad) = lion', emoji: '🔤'),
        LessonItem(term: 'ب', pronunciation: 'Ba', translation: 'Lettre B', example: 'بيت (bayt) = maison', emoji: '🔤'),
        LessonItem(term: 'ت', pronunciation: 'Ta', translation: 'Lettre T', example: 'تفاح (tuffāḥ) = pomme', emoji: '🔤'),
        LessonItem(term: 'ث', pronunciation: "Tha", translation: 'Lettre Th', example: 'ثعلب (tha\'lab) = renard', emoji: '🔤'),
        LessonItem(term: 'ج', pronunciation: 'Jeem', translation: 'Lettre J', example: 'جمل (jamal) = chameau', emoji: '🔤'),
        LessonItem(term: 'ح', pronunciation: 'Ha', translation: 'Lettre H (aspiré)', example: 'حصان (ḥiṣān) = cheval', emoji: '🔤'),
        LessonItem(term: 'خ', pronunciation: 'Kha', translation: 'Lettre Kh', example: 'خبز (khubz) = pain', emoji: '🔤'),
        LessonItem(term: 'د', pronunciation: 'Dal', translation: 'Lettre D', example: 'دار (dār) = maison', emoji: '🔤'),
        LessonItem(term: 'ذ', pronunciation: 'Dhal', translation: 'Lettre Dh', example: 'ذئب (dhi\'b) = loup', emoji: '🔤'),
        LessonItem(term: 'ر', pronunciation: 'Ra', translation: 'Lettre R (roulé)', example: 'رأس (ra\'s) = tête', emoji: '🔤'),
      ],
      'cat_nombres_ar': [
        LessonItem(term: 'صِفْر', pronunciation: 'ṣifr', translation: '0 — Zéro', example: 'صِفْر طالب = zéro élève', emoji: '0️⃣'),
        LessonItem(term: 'وَاحِد', pronunciation: 'wāḥid', translation: '1 — Un', example: 'وَاحِد كتاب = un livre', emoji: '1️⃣'),
        LessonItem(term: 'اثْنَان', pronunciation: 'ithnān', translation: '2 — Deux', example: 'اثْنَان قط = deux chats', emoji: '2️⃣'),
        LessonItem(term: 'ثَلَاثَة', pronunciation: 'thalātha', translation: '3 — Trois', example: 'ثَلَاثَة أيام = trois jours', emoji: '3️⃣'),
        LessonItem(term: 'أَرْبَعَة', pronunciation: 'arba\'a', translation: '4 — Quatre', example: 'أَرْبَعَة فصول = quatre saisons', emoji: '4️⃣'),
        LessonItem(term: 'خَمْسَة', pronunciation: 'khamsa', translation: '5 — Cinq', example: 'خَمْسَة أصابع = cinq doigts', emoji: '5️⃣'),
        LessonItem(term: 'سِتَّة', pronunciation: 'sitta', translation: '6 — Six', example: 'سِتَّة أشهر = six mois', emoji: '6️⃣'),
        LessonItem(term: 'سَبْعَة', pronunciation: 'sab\'a', translation: '7 — Sept', example: 'سَبْعَة أيام = sept jours', emoji: '7️⃣'),
        LessonItem(term: 'ثَمَانِيَة', pronunciation: 'thamāniya', translation: '8 — Huit', example: 'ثَمَانِيَة ساعات = huit heures', emoji: '8️⃣'),
        LessonItem(term: 'تِسْعَة', pronunciation: 'tis\'a', translation: '9 — Neuf', example: 'تِسْعَة طلاب = neuf étudiants', emoji: '9️⃣'),
      ],
      'cat_salutations_ar': [
        LessonItem(term: 'السَّلَامُ عَلَيْكُمْ', pronunciation: 'As-salāmu \'alaykum', translation: 'Bonjour / La paix sur vous', example: 'يُقال عند اللقاء = dit à la rencontre', emoji: '👋'),
        LessonItem(term: 'مَرْحَبًا', pronunciation: 'Marḥaban', translation: 'Bonjour / Bienvenue', example: 'مَرْحَبًا بك = Bienvenue chez toi', emoji: '😊'),
        LessonItem(term: 'كَيْفَ حَالُكَ؟', pronunciation: 'Kayfa ḥāluk?', translation: 'Comment vas-tu ?', example: 'كَيْفَ حَالُكَ اليوم؟ = Comment vas-tu aujourd\'hui ?', emoji: '🤔'),
        LessonItem(term: 'بِخَيْر', pronunciation: 'Bikhair', translation: 'Bien', example: 'أنا بِخَيْر, شكرًا = Je vais bien, merci', emoji: '✅'),
        LessonItem(term: 'شُكْرًا', pronunciation: 'Shukran', translation: 'Merci', example: 'شُكْرًا جزيلاً = Merci beaucoup', emoji: '🙏'),
        LessonItem(term: 'مِنْ فَضْلِكَ', pronunciation: 'Min faḍlik', translation: 'S\'il vous plaît', example: 'مِنْ فَضْلِكَ، ساعدني = Aide-moi s\'il te plaît', emoji: '🙏'),
        LessonItem(term: 'مَعَ السَّلَامَة', pronunciation: 'Ma\'a as-salāma', translation: 'Au revoir', example: 'مَعَ السَّلَامَة يا صديقي = Au revoir mon ami', emoji: '👋'),
        LessonItem(term: 'نَعَم', pronunciation: 'Na\'am', translation: 'Oui', example: 'نَعَم، أنا متأكد = Oui, j\'en suis sûr', emoji: '✅'),
        LessonItem(term: 'لَا', pronunciation: 'Lā', translation: 'Non', example: 'لَا، شكرًا = Non, merci', emoji: '❌'),
        LessonItem(term: 'مَا اسْمُكَ؟', pronunciation: 'Mā ismuk?', translation: 'Comment tu t\'appelles ?', example: 'مَا اسْمُكَ؟ اسمي أحمد = Je m\'appelle Ahmed', emoji: '👤'),
      ],
      'cat_famille_ar': [
        LessonItem(term: 'أَب', pronunciation: 'Ab', translation: 'Père', example: 'أَبِي طَبِيب = Mon père est médecin', emoji: '👨'),
        LessonItem(term: 'أُم', pronunciation: 'Umm', translation: 'Mère', example: 'أُمِّي مُعَلِّمَة = Ma mère est enseignante', emoji: '👩'),
        LessonItem(term: 'أَخ', pronunciation: 'Akh', translation: 'Frère', example: 'لِي أَخٌ كَبِير = J\'ai un grand frère', emoji: '👦'),
        LessonItem(term: 'أُخْت', pronunciation: 'Ukht', translation: 'Sœur', example: 'أُخْتِي صَغِيرَة = Ma sœur est petite', emoji: '👧'),
        LessonItem(term: 'جَد', pronunciation: 'Jadd', translation: 'Grand-père', example: 'جَدِّي كَبِير السِّنِّ = Mon grand-père est âgé', emoji: '👴'),
        LessonItem(term: 'جَدَّة', pronunciation: 'Jadda', translation: 'Grand-mère', example: 'جَدَّتِي تَطْبُخ جَيِّدًا = Ma grand-mère cuisine bien', emoji: '👵'),
        LessonItem(term: 'عَم', pronunciation: '\'Amm', translation: 'Oncle (paternel)', example: 'عَمِّي يَسْكُن بَعِيدًا = Mon oncle habite loin', emoji: '👨'),
        LessonItem(term: 'عَمَّة', pronunciation: '\'Amma', translation: 'Tante (paternelle)', example: 'عَمَّتِي لَطِيفَة = Ma tante est gentille', emoji: '👩'),
        LessonItem(term: 'وَلَد', pronunciation: 'Walad', translation: 'Garçon / Fils', example: 'هَذَا وَلَدِي = Voici mon fils', emoji: '👦'),
        LessonItem(term: 'بِنْت', pronunciation: 'Bint', translation: 'Fille', example: 'هَذِهِ بِنْتِي = Voici ma fille', emoji: '👧'),
      ],
      'cat_couleurs_ar': [
        LessonItem(term: 'أَحْمَر', pronunciation: 'Aḥmar', translation: 'Rouge', example: 'التُّفَّاحَة حَمْرَاء = La pomme est rouge', emoji: '🔴'),
        LessonItem(term: 'أَزْرَق', pronunciation: 'Azraq', translation: 'Bleu', example: 'السَّمَاء زَرْقَاء = Le ciel est bleu', emoji: '🔵'),
        LessonItem(term: 'أَخْضَر', pronunciation: 'Akhḍar', translation: 'Vert', example: 'الشَّجَرَة خَضْرَاء = L\'arbre est vert', emoji: '🟢'),
        LessonItem(term: 'أَصْفَر', pronunciation: 'Aṣfar', translation: 'Jaune', example: 'الشَّمْس صَفْرَاء = Le soleil est jaune', emoji: '🟡'),
        LessonItem(term: 'أَبْيَض', pronunciation: 'Abyaḍ', translation: 'Blanc', example: 'الثَّلج أَبْيَض = La neige est blanche', emoji: '⬜'),
        LessonItem(term: 'أَسْوَد', pronunciation: 'Aswad', translation: 'Noir', example: 'اللَّيل أَسْوَد = La nuit est noire', emoji: '⬛'),
        LessonItem(term: 'بُنِّي', pronunciation: 'Bunnī', translation: 'Marron', example: 'الخبz بُنِّي = Le pain est marron', emoji: '🟫'),
        LessonItem(term: 'بُرْتُقَالِي', pronunciation: 'Burtuqālī', translation: 'Orange', example: 'البُرْتُقَالة بُرْتُقَالِيَّة = L\'orange est orange', emoji: '🟠'),
        LessonItem(term: 'وَرْدِي', pronunciation: 'Wardī', translation: 'Rose', example: 'الوَرْدَة وَرْدِيَّة = La rose est rose', emoji: '🌸'),
        LessonItem(term: 'رَمَادِي', pronunciation: 'Ramādī', translation: 'Gris', example: 'الغَيم رَمَادِي = Le nuage est gris', emoji: '🩶'),
      ],
    },
    // ───────── ANGLAIS ─────────
    'en': {
      'cat_nombres_en': [
        LessonItem(term: 'Zero', pronunciation: 'ZI-roh', translation: '0 — Zéro', example: 'Zero mistakes! = Aucune erreur !', emoji: '0️⃣'),
        LessonItem(term: 'One', pronunciation: 'WUN', translation: '1 — Un', example: 'One apple a day = Une pomme par jour', emoji: '1️⃣'),
        LessonItem(term: 'Two', pronunciation: 'TOO', translation: '2 — Deux', example: 'Two cats = Deux chats', emoji: '2️⃣'),
        LessonItem(term: 'Three', pronunciation: 'THRII', translation: '3 — Trois', example: 'Three days = Trois jours', emoji: '3️⃣'),
        LessonItem(term: 'Four', pronunciation: 'FOR', translation: '4 — Quatre', example: 'Four seasons = Quatre saisons', emoji: '4️⃣'),
        LessonItem(term: 'Five', pronunciation: 'FAYV', translation: '5 — Cinq', example: 'High five! = Tape m\'en cinq !', emoji: '5️⃣'),
        LessonItem(term: 'Six', pronunciation: 'SIKS', translation: '6 — Six', example: 'Six months = Six mois', emoji: '6️⃣'),
        LessonItem(term: 'Seven', pronunciation: 'SEV-en', translation: '7 — Sept', example: 'Seven days a week = Sept jours par semaine', emoji: '7️⃣'),
        LessonItem(term: 'Eight', pronunciation: 'AYT', translation: '8 — Huit', example: 'Eight hours of sleep = Huit heures de sommeil', emoji: '8️⃣'),
        LessonItem(term: 'Nine', pronunciation: 'NAYN', translation: '9 — Neuf', example: 'Nine lives = Neuf vies', emoji: '9️⃣'),
      ],
      'cat_salutations_en': [
        LessonItem(term: 'Hello', pronunciation: 'heh-LOH', translation: 'Bonjour', example: 'Hello, how are you? = Bonjour, comment allez-vous ?', emoji: '👋'),
        LessonItem(term: 'Good morning', pronunciation: 'good MOR-ning', translation: 'Bonjour (matin)', example: 'Good morning, sir! = Bonjour, monsieur !', emoji: '🌅'),
        LessonItem(term: 'Good evening', pronunciation: 'good EEV-ning', translation: 'Bonsoir', example: 'Good evening, everyone! = Bonsoir tout le monde !', emoji: '🌆'),
        LessonItem(term: 'Goodbye', pronunciation: 'good-BY', translation: 'Au revoir', example: 'Goodbye, see you tomorrow! = Au revoir, à demain !', emoji: '👋'),
        LessonItem(term: 'Please', pronunciation: 'PLEEZ', translation: 'S\'il vous plaît', example: 'Please help me = Aidez-moi s\'il vous plaît', emoji: '🙏'),
        LessonItem(term: 'Thank you', pronunciation: 'THANGK yoo', translation: 'Merci', example: 'Thank you very much! = Merci beaucoup !', emoji: '🙏'),
        LessonItem(term: 'Yes', pronunciation: 'YES', translation: 'Oui', example: 'Yes, I agree = Oui, je suis d\'accord', emoji: '✅'),
        LessonItem(term: 'No', pronunciation: 'NOH', translation: 'Non', example: 'No, thank you = Non, merci', emoji: '❌'),
        LessonItem(term: 'How are you?', pronunciation: 'how ar YOO', translation: 'Comment allez-vous ?', example: 'Hi! How are you? = Salut ! Comment vas-tu ?', emoji: '🤔'),
        LessonItem(term: 'I\'m fine', pronunciation: 'aym FAYN', translation: 'Je vais bien', example: 'I\'m fine, thanks! = Je vais bien, merci !', emoji: '😊'),
      ],
    },
    // ───────── ESPAGNOL ─────────
    'es': {
      'cat_nombres_es': [
        LessonItem(term: 'Cero', pronunciation: 'THE-ro', translation: '0 — Zéro', example: 'Cero errores = Zéro erreur', emoji: '0️⃣'),
        LessonItem(term: 'Uno', pronunciation: 'OO-no', translation: '1 — Un', example: 'Uno, dos, tres... = Un, deux, trois...', emoji: '1️⃣'),
        LessonItem(term: 'Dos', pronunciation: 'DOSS', translation: '2 — Deux', example: 'Dos personas = Deux personnes', emoji: '2️⃣'),
        LessonItem(term: 'Tres', pronunciation: 'TRAYS', translation: '3 — Trois', example: 'Tres días = Trois jours', emoji: '3️⃣'),
        LessonItem(term: 'Cuatro', pronunciation: 'KWAH-tro', translation: '4 — Quatre', example: 'Cuatro estaciones = Quatre saisons', emoji: '4️⃣'),
        LessonItem(term: 'Cinco', pronunciation: 'SEEN-ko', translation: '5 — Cinq', example: 'Cinco dedos = Cinq doigts', emoji: '5️⃣'),
        LessonItem(term: 'Seis', pronunciation: 'SAYS', translation: '6 — Six', example: 'Seis meses = Six mois', emoji: '6️⃣'),
        LessonItem(term: 'Siete', pronunciation: 'SYAY-tay', translation: '7 — Sept', example: 'Siete días = Sept jours', emoji: '7️⃣'),
        LessonItem(term: 'Ocho', pronunciation: 'OH-cho', translation: '8 — Huit', example: 'Ocho horas = Huit heures', emoji: '8️⃣'),
        LessonItem(term: 'Nueve', pronunciation: 'NWAY-vay', translation: '9 — Neuf', example: 'Nueve vidas = Neuf vies', emoji: '9️⃣'),
      ],
      'cat_salutations_es': [
        LessonItem(term: 'Hola', pronunciation: 'OH-la', translation: 'Bonjour / Salut', example: '¡Hola! ¿Cómo estás? = Salut ! Comment vas-tu ?', emoji: '👋'),
        LessonItem(term: 'Buenos días', pronunciation: 'BWAY-nos DEE-as', translation: 'Bonjour (matin)', example: '¡Buenos días, señor! = Bonjour, monsieur !', emoji: '🌅'),
        LessonItem(term: 'Adiós', pronunciation: 'ah-DYOSS', translation: 'Au revoir', example: '¡Adiós! ¡Hasta luego! = Au revoir ! À bientôt !', emoji: '👋'),
        LessonItem(term: 'Gracias', pronunciation: 'GRAH-syass', translation: 'Merci', example: '¡Muchas gracias! = Merci beaucoup !', emoji: '🙏'),
        LessonItem(term: 'Por favor', pronunciation: 'por fa-VOR', translation: 'S\'il vous plaît', example: 'Por favor, ayúdame = Aide-moi s\'il te plaît', emoji: '🙏'),
        LessonItem(term: 'Sí', pronunciation: 'SEE', translation: 'Oui', example: 'Sí, claro = Oui, bien sûr', emoji: '✅'),
        LessonItem(term: 'No', pronunciation: 'NOH', translation: 'Non', example: 'No, gracias = Non, merci', emoji: '❌'),
        LessonItem(term: '¿Cómo te llamas?', pronunciation: 'KOH-mo tay YAH-mass', translation: 'Comment tu t\'appelles ?', example: '¿Cómo te llamas? Me llamo Ana. = Je m\'appelle Ana.', emoji: '👤'),
        LessonItem(term: 'Mucho gusto', pronunciation: 'MOO-cho GOOS-to', translation: 'Enchanté(e)', example: 'Mucho gusto en conocerte = Enchanté de te rencontrer', emoji: '🤝'),
        LessonItem(term: '¿Cómo estás?', pronunciation: 'KOH-mo es-TAHSS', translation: 'Comment vas-tu ?', example: '¿Cómo estás hoy? = Comment vas-tu aujourd\'hui ?', emoji: '🤔'),
      ],
    },
    // ───────── FRANÇAIS ─────────
    'fr': {
      // ── L'Alphabet ───────────────────────────────────────────
      'cat_alphabet_fr': [
        LessonItem(term: 'A',  pronunciation: '[a]',     translation: 'Letter A — vowel',    example: 'A comme Avion ✈️',      emoji: '🔤'),
        LessonItem(term: 'E',  pronunciation: '[ə/e/ɛ]', translation: 'Letter E — vowel',    example: 'E comme École 🏫',       emoji: '🔤'),
        LessonItem(term: 'I',  pronunciation: '[i]',     translation: 'Letter I — vowel',    example: 'I comme Île 🏝️',         emoji: '🔤'),
        LessonItem(term: 'O',  pronunciation: '[o/ɔ]',   translation: 'Letter O — vowel',    example: 'O comme Oiseau 🐦',      emoji: '🔤'),
        LessonItem(term: 'U',  pronunciation: '[y]',     translation: 'Letter U — vowel',    example: 'U comme Usine 🏭',       emoji: '🔤'),
        LessonItem(term: 'Y',  pronunciation: '[i.gʁɛk]',translation: 'Letter Y — semi-vowel',example: 'Y comme Yeux 👀',      emoji: '🔤'),
        LessonItem(term: 'B',  pronunciation: '[be]',    translation: 'Letter B — consonant', example: 'B comme Bateau ⛵',     emoji: '🔤'),
        LessonItem(term: 'C',  pronunciation: '[se]',    translation: 'Letter C — consonant', example: 'C comme Chat 🐱',       emoji: '🔤'),
        LessonItem(term: 'D',  pronunciation: '[de]',    translation: 'Letter D — consonant', example: 'D comme Danseur 💃',    emoji: '🔤'),
        LessonItem(term: 'F',  pronunciation: '[ɛf]',    translation: 'Letter F — consonant', example: 'F comme Forêt 🌲',      emoji: '🔤'),
      ],

      // ── Les Nombres ──────────────────────────────────────────
      'cat_nombres_fr': [
        LessonItem(term: 'Zéro',   pronunciation: '[ze.ʁo]',   translation: '0 — Zero',    example: 'J\'ai zéro idée pour ce soir.', emoji: '0️⃣'),
        LessonItem(term: 'Un',     pronunciation: '[œ̃]',       translation: '1 — One',     example: 'Il reste un billet.', emoji: '1️⃣'),
        LessonItem(term: 'Deux',   pronunciation: '[dø]',       translation: '2 — Two',     example: 'Deux cafés, s\'il vous plaît !', emoji: '2️⃣'),
        LessonItem(term: 'Trois',  pronunciation: '[tʁwa]',     translation: '3 — Three',   example: 'Il y a trois erreurs ici.', emoji: '3️⃣'),
        LessonItem(term: 'Quatre', pronunciation: '[katʁ]',     translation: '4 — Four',    example: 'J\'ai quatre frères.', emoji: '4️⃣'),
        LessonItem(term: 'Cinq',   pronunciation: '[sɛ̃k]',     translation: '5 — Five',    example: 'Cinq doigts à chaque main.', emoji: '5️⃣'),
        LessonItem(term: 'Six',    pronunciation: '[sis]',      translation: '6 — Six',     example: 'Six mois se sont écoulés.', emoji: '6️⃣'),
        LessonItem(term: 'Sept',   pronunciation: '[sɛt]',      translation: '7 — Seven',   example: 'Sept jours dans la semaine.', emoji: '7️⃣'),
        LessonItem(term: 'Huit',   pronunciation: '[ɥit]',      translation: '8 — Eight',   example: 'Huit heures de sommeil chaque nuit.', emoji: '8️⃣'),
        LessonItem(term: 'Neuf',   pronunciation: '[nœf]',      translation: '9 — Nine',    example: 'Un chat a neuf vies.', emoji: '9️⃣'),
      ],

      // ── Les Salutations ──────────────────────────────────────
      'cat_salutations_fr': [
        LessonItem(term: 'Bonjour',                  pronunciation: '[bɔ̃.ʒuʁ]',     translation: 'Good morning / Hello',       example: 'Bonjour ! Bien dormi ?', emoji: '🌅'),
        LessonItem(term: 'Bonsoir',                  pronunciation: '[bɔ̃.swaʁ]',    translation: 'Good evening',               example: 'Bonsoir, bienvenue au restaurant.', emoji: '🌆'),
        LessonItem(term: 'Salut',                    pronunciation: '[sa.ly]',       translation: 'Hi / Hey',                   example: 'Salut ! Ça fait longtemps !', emoji: '👋'),
        LessonItem(term: 'Au revoir',                pronunciation: '[o.ʁe.vwaʁ]',  translation: 'Goodbye',                    example: 'Au revoir, à lundi !', emoji: '👋'),
        LessonItem(term: 'Merci',                    pronunciation: '[mɛʁ.si]',      translation: 'Thank you',                  example: 'Merci pour votre aide.', emoji: '🙏'),
        LessonItem(term: 'De rien',                  pronunciation: '[də.ʁjɛ̃]',    translation: 'You\'re welcome',            example: 'Merci ! — De rien !', emoji: '😊'),
        LessonItem(term: 'S\'il vous plaît',         pronunciation: '[sil.vu.plɛ]',  translation: 'Please (formal)',            example: 'Un café, s\'il vous plaît.', emoji: '🙏'),
        LessonItem(term: 'Comment allez-vous ?',     pronunciation: '[kɔ.mɑ̃.ta.le.vu]', translation: 'How are you? (formal)',   example: 'Bonjour ! Comment allez-vous ?', emoji: '🤔'),
        LessonItem(term: 'Je vais bien',             pronunciation: '[ʒə.vɛ.bjɛ̃]', translation: 'I am fine',                  example: 'Je vais bien, merci beaucoup !', emoji: '😊'),
        LessonItem(term: 'Enchanté(e)',              pronunciation: '[ɑ̃.ʃɑ̃.te]',  translation: 'Nice to meet you',           example: 'Je m\'appelle Sophie. — Enchanté !', emoji: '🤝'),
      ],

      // ── La Famille ───────────────────────────────────────────
      'cat_famille_fr': [
        LessonItem(term: 'Le père',        pronunciation: '[lə.pɛʁ]',      translation: 'The father',       example: 'Mon père est médecin.', emoji: '👨'),
        LessonItem(term: 'La mère',        pronunciation: '[la.mɛʁ]',      translation: 'The mother',       example: 'Ma mère fait la cuisine.', emoji: '👩'),
        LessonItem(term: 'Le frère',       pronunciation: '[lə.fʁɛʁ]',     translation: 'The brother',      example: 'J\'ai un grand frère.', emoji: '👦'),
        LessonItem(term: 'La sœur',        pronunciation: '[la.sœʁ]',      translation: 'The sister',       example: 'Ma sœur est au lycée.', emoji: '👧'),
        LessonItem(term: 'Le grand-père',  pronunciation: '[lə.gʁɑ̃.pɛʁ]', translation: 'The grandfather', example: 'Mon grand-père a 75 ans.', emoji: '👴'),
        LessonItem(term: 'La grand-mère', pronunciation: '[la.gʁɑ̃.mɛʁ]', translation: 'The grandmother', example: 'Ma grand-mère fait d\'excellentes tartes.', emoji: '👵'),
        LessonItem(term: 'L\'oncle',       pronunciation: '[lɔ̃kl]',        translation: 'The uncle',        example: 'Mon oncle vit à Lyon.', emoji: '🧔'),
        LessonItem(term: 'La tante',       pronunciation: '[la.tɑ̃t]',      translation: 'The aunt',         example: 'Ma tante est très gentille.', emoji: '👩'),
        LessonItem(term: 'Le fils',        pronunciation: '[lə.fis]',       translation: 'The son',          example: 'Voici mon fils, il a 10 ans.', emoji: '👦'),
        LessonItem(term: 'La fille',       pronunciation: '[la.fij]',       translation: 'The daughter',     example: 'Sa fille est très intelligente.', emoji: '👧'),
      ],

      // ── Les Couleurs ─────────────────────────────────────────
      'cat_couleurs_fr': [
        LessonItem(term: 'Rouge',   pronunciation: '[ʁuʒ]',   translation: 'Red',    example: 'Une pomme rouge.', emoji: '🔴'),
        LessonItem(term: 'Bleu',    pronunciation: '[blø]',   translation: 'Blue',   example: 'Le ciel est bleu.', emoji: '🔵'),
        LessonItem(term: 'Vert',    pronunciation: '[vɛʁ]',   translation: 'Green',  example: 'L\'herbe est verte.', emoji: '🟢'),
        LessonItem(term: 'Jaune',   pronunciation: '[ʒon]',   translation: 'Yellow', example: 'Un citron jaune.', emoji: '🟡'),
        LessonItem(term: 'Orange',  pronunciation: '[ɔ.ʁɑ̃ʒ]',translation: 'Orange', example: 'Une orange orange !', emoji: '🟠'),
        LessonItem(term: 'Violet',  pronunciation: '[vjɔ.lɛ]',translation: 'Purple', example: 'Une fleur violette.', emoji: '🟣'),
        LessonItem(term: 'Rose',    pronunciation: '[ʁoz]',   translation: 'Pink',   example: 'Un flamant rose.', emoji: '🌸'),
        LessonItem(term: 'Noir',    pronunciation: '[nwaʁ]',  translation: 'Black',  example: 'Un chat noir porte bonheur.', emoji: '⬛'),
        LessonItem(term: 'Blanc',   pronunciation: '[blɑ̃]',  translation: 'White',  example: 'La neige est blanche.', emoji: '⬜'),
        LessonItem(term: 'Gris',    pronunciation: '[gʁi]',   translation: 'Grey',   example: 'Un ciel gris en automne.', emoji: '🩶'),
      ],

      // ── Les Jours ────────────────────────────────────────────
      'cat_jours_fr': [
        LessonItem(term: 'Lundi',    pronunciation: '[lœ̃.di]',   translation: 'Monday',    example: 'Lundi, retour au travail !', emoji: '📅'),
        LessonItem(term: 'Mardi',    pronunciation: '[maʁ.di]',   translation: 'Tuesday',   example: 'On se voit mardi ?', emoji: '📅'),
        LessonItem(term: 'Mercredi', pronunciation: '[mɛʁ.kʁe.di]', translation: 'Wednesday', example: 'Mercredi, pas d\'école !', emoji: '📅'),
        LessonItem(term: 'Jeudi',    pronunciation: '[ʒø.di]',    translation: 'Thursday',  example: 'Jeudi soir, ciné !', emoji: '📅'),
        LessonItem(term: 'Vendredi', pronunciation: '[vɑ̃.dʁe.di]',translation: 'Friday',    example: 'Vendredi, fin de la semaine !', emoji: '🎉'),
        LessonItem(term: 'Samedi',   pronunciation: '[sam.di]',   translation: 'Saturday',  example: 'Samedi marché au village.', emoji: '🛍️'),
        LessonItem(term: 'Dimanche', pronunciation: '[di.mɑ̃ʃ]',  translation: 'Sunday',    example: 'Dimanche, repos et famille.', emoji: '☀️'),
        LessonItem(term: 'Aujourd\'hui', pronunciation: '[o.ʒuʁ.dɥi]', translation: 'Today', example: 'Aujourd\'hui c\'est lundi.', emoji: '📆'),
        LessonItem(term: 'Demain',   pronunciation: '[də.mɛ̃]',   translation: 'Tomorrow',  example: 'À demain !', emoji: '⏭️'),
        LessonItem(term: 'Hier',     pronunciation: '[jɛʁ]',      translation: 'Yesterday', example: 'Hier il faisait beau.', emoji: '⏮️'),
      ],

      // ── Les Animaux ──────────────────────────────────────────
      'cat_animaux_fr': [
        LessonItem(term: 'Le chien',  pronunciation: '[lə.ʃjɛ̃]',  translation: 'The dog',      example: 'Mon chien s\'appelle Rex.', emoji: '🐕'),
        LessonItem(term: 'Le chat',   pronunciation: '[lə.ʃa]',    translation: 'The cat',      example: 'Le chat dort sur le canapé.', emoji: '🐈'),
        LessonItem(term: 'L\'oiseau', pronunciation: '[lwa.zo]',   translation: 'The bird',     example: 'L\'oiseau chante le matin.', emoji: '🐦'),
        LessonItem(term: 'Le cheval', pronunciation: '[lə.ʃval]',  translation: 'The horse',    example: 'Le cheval court dans le pré.', emoji: '🐴'),
        LessonItem(term: 'La vache',  pronunciation: '[la.vaʃ]',   translation: 'The cow',      example: 'La vache donne du lait.', emoji: '🐄'),
        LessonItem(term: 'Le lapin',  pronunciation: '[lə.lapɛ̃]', translation: 'The rabbit',   example: 'Le lapin mange des carottes.', emoji: '🐇'),
        LessonItem(term: 'Le poisson',pronunciation: '[lə.pwa.sɔ̃]',translation: 'The fish',    example: 'Le poisson nage dans l\'aquarium.', emoji: '🐟'),
        LessonItem(term: 'L\'éléphant',pronunciation: '[le.le.fɑ̃]',translation: 'The elephant',example: 'L\'éléphant est le plus grand animal terrestre.', emoji: '🐘'),
        LessonItem(term: 'Le lion',   pronunciation: '[lə.ljɔ̃]',  translation: 'The lion',     example: 'Le lion rugit dans la savane.', emoji: '🦁'),
        LessonItem(term: 'Le canard', pronunciation: '[lə.ka.naʁ]',translation: 'The duck',    example: 'Le canard barbote dans l\'eau.', emoji: '🦆'),
      ],

      // ── Les Aliments ─────────────────────────────────────────
      'cat_aliments_fr': [
        LessonItem(term: 'Le pain',    pronunciation: '[lə.pɛ̃]',   translation: 'The bread',   example: 'Je mange du pain au petit-déjeuner.', emoji: '🍞'),
        LessonItem(term: 'Le lait',    pronunciation: '[lə.lɛ]',    translation: 'The milk',    example: 'Un verre de lait froid.', emoji: '🥛'),
        LessonItem(term: 'Le café',    pronunciation: '[lə.ka.fe]', translation: 'The coffee',  example: 'Un café, s\'il vous plaît.', emoji: '☕'),
        LessonItem(term: 'La pomme',   pronunciation: '[la.pɔm]',   translation: 'The apple',   example: 'Une pomme par jour éloigne le médecin.', emoji: '🍎'),
        LessonItem(term: 'Le fromage', pronunciation: '[lə.fʁo.maʒ]',translation: 'The cheese', example: 'La France produit 1000 fromages.', emoji: '🧀'),
        LessonItem(term: 'Le poulet',  pronunciation: '[lə.pu.lɛ]', translation: 'The chicken', example: 'Du poulet rôti pour ce soir.', emoji: '🍗'),
        LessonItem(term: 'L\'eau',     pronunciation: '[lo]',        translation: 'The water',   example: 'Boire de l\'eau chaque jour.', emoji: '💧'),
        LessonItem(term: 'Le riz',     pronunciation: '[lə.ʁi]',     translation: 'The rice',    example: 'Du riz avec des légumes.', emoji: '🍚'),
        LessonItem(term: 'La tomate',  pronunciation: '[la.tɔ.mat]', translation: 'The tomato',  example: 'Une tomate bien rouge et juteuse.', emoji: '🍅'),
        LessonItem(term: 'Le chocolat',pronunciation: '[lə.ʃɔ.kɔ.la]',translation: 'The chocolate',example: 'Un carré de chocolat noir.', emoji: '🍫'),
      ],

      // ── Les Verbes de Base ───────────────────────────────────
      'cat_verbes_fr': [
        LessonItem(term: 'Être',    pronunciation: '[ɛtʁ]',    translation: 'To be',      example: 'Je suis français.', emoji: '🔵'),
        LessonItem(term: 'Avoir',   pronunciation: '[a.vwaʁ]', translation: 'To have',    example: 'J\'ai deux enfants.', emoji: '🤲'),
        LessonItem(term: 'Aller',   pronunciation: '[a.le]',   translation: 'To go',      example: 'Je vais à Paris demain.', emoji: '🚶'),
        LessonItem(term: 'Faire',   pronunciation: '[fɛʁ]',    translation: 'To do / make', example: 'Je fais du sport le matin.', emoji: '💪'),
        LessonItem(term: 'Manger',  pronunciation: '[mɑ̃.ʒe]', translation: 'To eat',     example: 'Nous mangeons à midi.', emoji: '🍽️'),
        LessonItem(term: 'Boire',   pronunciation: '[bwaʁ]',   translation: 'To drink',   example: 'Il boit un verre d\'eau.', emoji: '🥤'),
        LessonItem(term: 'Parler',  pronunciation: '[paʁ.le]', translation: 'To speak',   example: 'Elle parle trois langues.', emoji: '💬'),
        LessonItem(term: 'Aimer',   pronunciation: '[ɛ.me]',   translation: 'To love / like', example: 'J\'aime la musique classique.', emoji: '❤️'),
        LessonItem(term: 'Vouloir', pronunciation: '[vu.lwaʁ]',translation: 'To want',    example: 'Je veux apprendre le français.', emoji: '🌟'),
        LessonItem(term: 'Dormir',  pronunciation: '[dɔʁ.miʁ]',translation: 'To sleep',   example: 'Il dort huit heures par nuit.', emoji: '😴'),
      ],

      // ── Les Mois ─────────────────────────────────────────────
      'cat_mois_fr': [
        LessonItem(term: 'Janvier',   pronunciation: '[ʒɑ̃.vje]',  translation: 'January',   example: 'Janvier est le premier mois de l\'année.', emoji: '❄️'),
        LessonItem(term: 'Février',   pronunciation: '[fe.vʁije]', translation: 'February',  example: 'Février est le mois le plus court.', emoji: '💝'),
        LessonItem(term: 'Mars',      pronunciation: '[maʁs]',     translation: 'March',     example: 'En mars, le printemps arrive.', emoji: '🌱'),
        LessonItem(term: 'Avril',     pronunciation: '[avʁil]',    translation: 'April',     example: 'En avril, ne te découvre pas d\'un fil !', emoji: '🌸'),
        LessonItem(term: 'Mai',       pronunciation: '[mɛ]',       translation: 'May',       example: 'Le muguet symbolise le 1er mai.', emoji: '🌼'),
        LessonItem(term: 'Juin',      pronunciation: '[ʒɥɛ̃]',     translation: 'June',      example: 'Juin marque le début de l\'été.', emoji: '☀️'),
        LessonItem(term: 'Juillet',   pronunciation: '[ʒɥijɛ]',    translation: 'July',      example: 'Le 14 juillet est la fête nationale française.', emoji: '🎆'),
        LessonItem(term: 'Août',      pronunciation: '[u]',         translation: 'August',    example: 'En août, tout le monde est en vacances.', emoji: '🏖️'),
        LessonItem(term: 'Septembre', pronunciation: '[sɛp.tɑ̃bʁ]',translation: 'September', example: 'La rentrée scolaire est en septembre.', emoji: '📚'),
        LessonItem(term: 'Octobre',   pronunciation: '[ɔk.tɔbʁ]',  translation: 'October',   example: 'En octobre, les feuilles tombent des arbres.', emoji: '🍂'),
      ],
    },
    // ───────── TURC ─────────
    'tr': {
      'cat_nombres_tr': [
        LessonItem(term: 'Sıfır', pronunciation: 'sı-fır', translation: '0 — Zéro', example: 'Sıfır hata.', emoji: '0️⃣'),
        LessonItem(term: 'Bir', pronunciation: 'bir', translation: '1 — Un', example: 'Bir elma yedim.', emoji: '1️⃣'),
        LessonItem(term: 'İki', pronunciation: 'i-ki', translation: '2 — Deux', example: 'İki kitap okudum.', emoji: '2️⃣'),
        LessonItem(term: 'Üç', pronunciation: 'üç', translation: '3 — Trois', example: 'Üç kardeşiz.', emoji: '3️⃣'),
        LessonItem(term: 'Dört', pronunciation: 'dört', translation: '4 — Quatre', example: 'Dört mevsim var.', emoji: '4️⃣'),
        LessonItem(term: 'Beş', pronunciation: 'beş', translation: '5 — Cinq', example: 'Beş parmağım var.', emoji: '5️⃣'),
      ],
      'cat_salutations_tr': [
        LessonItem(term: 'Merhaba', pronunciation: 'mer-ha-ba', translation: 'Bonjour / Hello', example: 'Merhaba, nasılsın? = Salut, comment vas-tu ?', emoji: '👋'),
        LessonItem(term: 'Selam', pronunciation: 'se-lam', translation: 'Salut / Hi', example: 'Selam arkadaşlar!', emoji: '👋'),
        LessonItem(term: 'Güle güle', pronunciation: 'gü-le gü-le', translation: 'Au revoir', example: 'Güle güle, yine bekleriz!', emoji: '👋'),
        LessonItem(term: 'Teşekkür ederim', pronunciation: 'te-shek-kür e-de-rim', translation: 'Merci', example: 'Yardımın için teşekkür ederim.', emoji: '🙏'),
        LessonItem(term: 'Lütfen', pronunciation: 'lüt-fen', translation: 'S\'il vous plaît', example: 'Lütfen buraya gel.', emoji: '🙏'),
        LessonItem(term: 'Evet', pronunciation: 'e-vet', translation: 'Oui', example: 'Evet, geliyorum.', emoji: '✅'),
        LessonItem(term: 'Hayır', pronunciation: 'ha-yır', translation: 'Non', example: 'Hayır, istemiyorum.', emoji: '❌'),
        LessonItem(term: 'Nasılsın?', pronunciation: 'na-sıl-sın', translation: 'Comment vas-tu ?', example: 'Nasılsın bugün?', emoji: '🤔'),
        LessonItem(term: 'İyiyim', pronunciation: 'i-yi-yim', translation: 'Je vais bien', example: 'İyiyim, teşekkürler.', emoji: '😊'),
        LessonItem(term: 'Adın ne?', pronunciation: 'a-dın ne', translation: 'Comment t\'appelles-tu ?', example: 'Adın ne? Benim adım Elif.', emoji: '👤'),
      ],
    },
    // ───────── ALLEMAND ─────────
    'de': {
      'cat_nombres_de': [
        LessonItem(term: 'Null', pronunciation: 'NOOL', translation: '0 — Zéro', example: 'Null Fehler = Zéro erreur', emoji: '0️⃣'),
        LessonItem(term: 'Eins', pronunciation: 'AYNS', translation: '1 — Un', example: 'Eins, zwei, drei = Un, deux, trois', emoji: '1️⃣'),
        LessonItem(term: 'Zwei', pronunciation: 'TSVAY', translation: '2 — Deux', example: 'Zwei Katzen = Deux chats', emoji: '2️⃣'),
        LessonItem(term: 'Drei', pronunciation: 'DRAY', translation: '3 — Trois', example: 'Drei Tage = Trois jours', emoji: '3️⃣'),
        LessonItem(term: 'Vier', pronunciation: 'FEER', translation: '4 — Quatre', example: 'Vier Jahreszeiten = Quatre saisons', emoji: '4️⃣'),
        LessonItem(term: 'Fünf', pronunciation: 'FÜNF', translation: '5 — Cinq', example: 'Fünf Finger = Cinq doigts', emoji: '5️⃣'),
        LessonItem(term: 'Sechs', pronunciation: 'ZEKS', translation: '6 — Six', example: 'Sechs Monate = Six mois', emoji: '6️⃣'),
        LessonItem(term: 'Sieben', pronunciation: 'ZEE-ben', translation: '7 — Sept', example: 'Sieben Tage = Sept jours', emoji: '7️⃣'),
        LessonItem(term: 'Acht', pronunciation: 'AKHT', translation: '8 — Huit', example: 'Acht Stunden = Huit heures', emoji: '8️⃣'),
        LessonItem(term: 'Neun', pronunciation: 'NOYN', translation: '9 — Neuf', example: 'Neun Leben = Neuf vies', emoji: '9️⃣'),
      ],
      'cat_salutations_de': [
        LessonItem(term: 'Hallo', pronunciation: 'HA-lo', translation: 'Bonjour / Salut', example: 'Hallo! Wie geht\'s? = Salut ! Comment ça va ?', emoji: '👋'),
        LessonItem(term: 'Guten Morgen', pronunciation: 'GOO-ten MOR-gen', translation: 'Bonjour (matin)', example: 'Guten Morgen, Herr Müller! = Bonjour, M. Müller !', emoji: '🌅'),
        LessonItem(term: 'Danke', pronunciation: 'DANK-uh', translation: 'Merci', example: 'Danke schön! = Merci beaucoup !', emoji: '🙏'),
        LessonItem(term: 'Bitte', pronunciation: 'BIT-uh', translation: 'S\'il vous plaît / De rien', example: 'Bitte hilf mir = Aide-moi s\'il te plaît', emoji: '🙏'),
        LessonItem(term: 'Ja', pronunciation: 'YAH', translation: 'Oui', example: 'Ja, natürlich! = Oui, bien sûr !', emoji: '✅'),
        LessonItem(term: 'Nein', pronunciation: 'NAYN', translation: 'Non', example: 'Nein, danke = Non, merci', emoji: '❌'),
        LessonItem(term: 'Auf Wiedersehen', pronunciation: 'owf VEE-der-zayn', translation: 'Au revoir', example: 'Auf Wiedersehen! Tschüss! = Au revoir !', emoji: '👋'),
        LessonItem(term: 'Wie geht es Ihnen?', pronunciation: 'vee gayt es EE-nen', translation: 'Comment allez-vous ?', example: 'Wie geht es Ihnen heute? = Comment allez-vous aujourd\'hui ?', emoji: '🤔'),
        LessonItem(term: 'Mir geht\'s gut', pronunciation: 'meer gayts goot', translation: 'Je vais bien', example: 'Mir geht\'s gut, danke! = Je vais bien, merci !', emoji: '😊'),
        LessonItem(term: 'Wie heißen Sie?', pronunciation: 'vee HY-sen zee', translation: 'Comment vous appelez-vous ?', example: 'Wie heißen Sie? Ich heiße Anna = Je m\'appelle Anna', emoji: '👤'),
      ],
    },
    // ───────── ITALIEN ─────────
    'it': {
      'cat_nombres_it': [
        LessonItem(term: 'Zero', pronunciation: 'DZE-ro', translation: '0 — Zéro', example: 'Zero errori = Zéro erreur', emoji: '0️⃣'),
        LessonItem(term: 'Uno', pronunciation: 'OO-no', translation: '1 — Un', example: 'Uno, due, tre = Un, deux, trois', emoji: '1️⃣'),
        LessonItem(term: 'Due', pronunciation: 'DOO-eh', translation: '2 — Deux', example: 'Due gatti = Deux chats', emoji: '2️⃣'),
        LessonItem(term: 'Tre', pronunciation: 'TRAY', translation: '3 — Trois', example: 'Tre giorni = Trois jours', emoji: '3️⃣'),
        LessonItem(term: 'Quattro', pronunciation: 'KWAT-tro', translation: '4 — Quatre', example: 'Quattro stagioni = Quatre saisons', emoji: '4️⃣'),
        LessonItem(term: 'Cinque', pronunciation: 'CHEEN-kweh', translation: '5 — Cinq', example: 'Cinque dita = Cinq doigts', emoji: '5️⃣'),
        LessonItem(term: 'Sei', pronunciation: 'SAY', translation: '6 — Six', example: 'Sei mesi = Six mois', emoji: '6️⃣'),
        LessonItem(term: 'Sette', pronunciation: 'SET-teh', translation: '7 — Sept', example: 'Sette giorni = Sept jours', emoji: '7️⃣'),
        LessonItem(term: 'Otto', pronunciation: 'OT-to', translation: '8 — Huit', example: 'Otto ore = Huit heures', emoji: '8️⃣'),
        LessonItem(term: 'Nove', pronunciation: 'NO-veh', translation: '9 — Neuf', example: 'Nove vite = Neuf vies', emoji: '9️⃣'),
      ],
      'cat_salutations_it': [
        LessonItem(term: 'Ciao', pronunciation: 'CHOW', translation: 'Salut / Au revoir', example: 'Ciao! Come stai? = Salut ! Comment vas-tu ?', emoji: '👋'),
        LessonItem(term: 'Buongiorno', pronunciation: 'bwon-JOR-no', translation: 'Bonjour', example: 'Buongiorno, professore! = Bonjour, professeur !', emoji: '🌅'),
        LessonItem(term: 'Grazie', pronunciation: 'GRAT-syeh', translation: 'Merci', example: 'Grazie mille! = Merci mille fois !', emoji: '🙏'),
        LessonItem(term: 'Per favore', pronunciation: 'per fa-VO-reh', translation: 'S\'il vous plaît', example: 'Aiutami, per favore = Aide-moi s\'il te plaît', emoji: '🙏'),
        LessonItem(term: 'Sì', pronunciation: 'SEE', translation: 'Oui', example: 'Sì, certo! = Oui, bien sûr !', emoji: '✅'),
        LessonItem(term: 'No', pronunciation: 'NOH', translation: 'Non', example: 'No, grazie = Non, merci', emoji: '❌'),
        LessonItem(term: 'Arrivederci', pronunciation: 'ar-ree-veh-DER-chee', translation: 'Au revoir', example: 'Arrivederci! A presto! = Au revoir ! À bientôt !', emoji: '👋'),
        LessonItem(term: 'Come stai?', pronunciation: 'KO-meh STAI', translation: 'Comment vas-tu ?', example: 'Come stai oggi? = Comment vas-tu aujourd\'hui ?', emoji: '🤔'),
        LessonItem(term: 'Sto bene', pronunciation: 'STO BEH-neh', translation: 'Je vais bien', example: 'Sto bene, grazie! = Je vais bien, merci !', emoji: '😊'),
        LessonItem(term: 'Come ti chiami?', pronunciation: 'KO-meh tee KYAH-mee', translation: 'Comment tu t\'appelles ?', example: 'Come ti chiami? Mi chiamo Marco = Je m\'appelle Marco', emoji: '👤'),
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
      if (categoryId.contains('salutations') && key.contains('salutations')) return langContent[key]!;
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
        const LessonItem(term: '0', pronunciation: 'Zéro', translation: '0 — Zéro', example: 'Zéro = le début de tout', emoji: '0️⃣'),
        const LessonItem(term: '1', pronunciation: 'Un', translation: '1 — Un', example: 'Un = l\'unité', emoji: '1️⃣'),
        const LessonItem(term: '2', pronunciation: 'Deux', translation: '2 — Deux', example: 'Deux = une paire', emoji: '2️⃣'),
        const LessonItem(term: '3', pronunciation: 'Trois', translation: '3 — Trois', example: 'Trois = un trio', emoji: '3️⃣'),
        const LessonItem(term: '4', pronunciation: 'Quatre', translation: '4 — Quatre', example: 'Quatre = les quatre coins', emoji: '4️⃣'),
      ];
    }
    return [
      const LessonItem(term: '📚', pronunciation: '--', translation: 'Contenu bientôt disponible', example: 'Revenez plus tard pour accéder à ce cours !', emoji: '🔜'),
      const LessonItem(term: 'Bonjour', pronunciation: '...', translation: 'Hello', example: 'Bonjour !', emoji: '👋'),
      const LessonItem(term: 'Merci', pronunciation: '...', translation: 'Thank you', example: 'Merci beaucoup !', emoji: '🙏'),
    ];
  }
}
