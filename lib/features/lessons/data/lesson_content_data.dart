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
        LessonItem(term: 'خ', pronunciation: 'Kha', translation: 'Lettre Kh', example: 'خبz (khubz) = pain', emoji: '🔤'),
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
    },
    // ───────── ESPAGNOL ─────────
    'es': {
      'cat_nombres_es': [
        LessonItem(term: 'Cero', pronunciation: 'TZE-ro', translation: '0 — Zéro', example: 'Cero errores = Zéro erreur', emoji: '0️⃣'),
        LessonItem(term: 'Uno', pronunciation: 'OO-no', translation: '1 — Un', example: 'Uno, dos, tres = Un, deux, trois', emoji: '1️⃣'),
        LessonItem(term: 'Dos', pronunciation: 'DOSS', translation: '2 — Deux', example: 'Dos gatos = Deux chats', emoji: '2️⃣'),
        LessonItem(term: 'Tres', pronunciation: 'TRESS', translation: '3 — Trois', example: 'Tres días = Trois jours', emoji: '3️⃣'),
        LessonItem(term: 'Cuatro', pronunciation: 'KWA-tro', translation: '4 — Quatre', example: 'Cuatro estaciones = Quatre saisons', emoji: '4️⃣'),
        LessonItem(term: 'Cinco', pronunciation: 'SEEN-ko', translation: '5 — Cinq', example: 'Cinco dedos = Cinq doigts', emoji: '5️⃣'),
        LessonItem(term: 'Seis', pronunciation: 'SAYSS', translation: '6 — Six', example: 'Seis meses = Six mois', emoji: '6️⃣'),
        LessonItem(term: 'Siete', pronunciation: 'SYEH-teh', translation: '7 — Sept', example: 'Siete días = Sept jours', emoji: '7️⃣'),
        LessonItem(term: 'Ocho', pronunciation: 'OH-cho', translation: '8 — Huit', example: 'Ocho horas = Huit heures', emoji: '8️⃣'),
        LessonItem(term: 'Nueve', pronunciation: 'NWEH-beh', translation: '9 — Neuf', example: 'Nueve vidas = Neuf vies', emoji: '9️⃣'),
      ],
      'cat_salutations_es': [
        LessonItem(term: 'Hola', pronunciation: 'O-la', translation: 'Bonjour / Salut', example: 'Hola! ¿Cómo estás? = Salut ! Comment vas-tu ?', emoji: '👋'),
        LessonItem(term: 'Buenos días', pronunciation: 'BWEH-nos DEE-as', translation: 'Bonjour (matin)', example: 'Buenos días, señor = Bonjour, monsieur', emoji: '🌅'),
        LessonItem(term: 'Gracias', pronunciation: 'GRA-thyass', translation: 'Merci', example: 'Muchas gracias = Merci beaucoup', emoji: '🙏'),
        LessonItem(term: 'Por favor', pronunciation: 'por fa-BOR', translation: 'S\'il vous plaît', example: 'Ayúdame, por favor = Aide-moi s\'il te plaît', emoji: '🙏'),
        LessonItem(term: 'Sí', pronunciation: 'SEE', translation: 'Oui', example: 'Sí, claro = Oui, bien sûr', emoji: '✅'),
        LessonItem(term: 'No', pronunciation: 'NOH', translation: 'Non', example: 'No, gracias = Non, merci', emoji: '❌'),
        LessonItem(term: 'Adiós', pronunciation: 'a-DYOSS', translation: 'Au revoir', example: 'Adiós ! Hasta luego = Au revoir ! À bientôt', emoji: '👋'),
        LessonItem(term: '¿Cómo estás?', pronunciation: 'KO-mo es-TASS', translation: 'Comment vas-tu ?', example: '¿Cómo estás hoy? = Comment vas-tu aujourd\'hui ?', emoji: '🤔'),
        LessonItem(term: 'Estoy bien', pronunciation: 'es-TOY BYEN', translation: 'Je vais bien', example: 'Estoy bien, gracias = Je vais bien, merci', emoji: '😊'),
        LessonItem(term: '¿Cómo te llamas?', pronunciation: 'ko-mo teh YA-mass', translation: 'Comment tu t\'appelles ?', example: 'Me llamo Ana = Je m\'appelle Ana', emoji: '👤'),
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
        LessonItem(term: 'Sto bene', pronunciation: 'STO BEH-neh', translation: 'Je vais bien', example: 'Sto bene, grâce! = Je vais bien, merci !', emoji: '😊'),
        LessonItem(term: 'Come ti chiami?', pronunciation: 'KO-meh tee KYAH-mee', translation: 'Comment tu t\'appelles ?', example: 'Come ti chiami? Mi chiamo Marco = Je m\'appelle Marco', emoji: '👤'),
      ],
    },
    // ───────── FRANÇAIS ─────────
    'fr': {
      'cat_salutations_fr': [
        LessonItem(term: 'Bonjour', pronunciation: 'bon-zhoor', translation: 'Bonjour / Good morning', example: 'Bonjour ! Comment ça va ?', emoji: '👋'),
        LessonItem(term: 'Salut', pronunciation: 'sa-lu', translation: 'Salut / Hi', example: 'Salut tout le monde !', emoji: '👋'),
        LessonItem(term: 'Merci', pronunciation: 'mer-see', translation: 'Merci / Thank you', example: 'Merci beaucoup !', emoji: '🙏'),
        LessonItem(term: 'S\'il vous plaît', pronunciation: 'seel voo pleh', translation: 'S\'il vous plaît / Please', example: 'S\'il vous plaît, aidez-moi.', emoji: '🙏'),
        LessonItem(term: 'Oui', pronunciation: 'wee', translation: 'Oui / Yes', example: 'Oui, je suis d\'accord.', emoji: '✅'),
        LessonItem(term: 'Non', pronunciation: 'non', translation: 'Non / No', example: 'Non, merci.', emoji: '❌'),
        LessonItem(term: 'Au revoir', pronunciation: 'oh re-vwar', translation: 'Au revoir / Goodbye', example: 'Au revoir, à demain !', emoji: '👋'),
        LessonItem(term: 'Comment allez-vous ?', pronunciation: 'ko-man ta-leh voo', translation: 'How are you?', example: 'Comment allez-vous aujourd\'hui ?', emoji: '🤔'),
        LessonItem(term: 'Je vais bien', pronunciation: 'zhe veh byen', translation: 'I am fine', example: 'Je vais bien, merci.', emoji: '😊'),
        LessonItem(term: 'Comment vous appelez-vous ?', pronunciation: 'ko-man voo za-pleh voo', translation: 'What is your name?', example: 'Comment vous appelez-vous ? Je m\'appelle Jean.', emoji: '👤'),
      ],
      'cat_nombres_fr': [
        LessonItem(term: 'Zéro', pronunciation: 'ze-ro', translation: '0 — Zero', example: 'Zéro faute !', emoji: '0️⃣'),
        LessonItem(term: 'Un', pronunciation: 'un', translation: '1 — One', example: 'Un pour tous, tous pour un.', emoji: '1️⃣'),
        LessonItem(term: 'Deux', pronunciation: 'deu', translation: '2 — Two', example: 'Deux têtes valent mieux qu\'une.', emoji: '2️⃣'),
        LessonItem(term: 'Trois', pronunciation: 'trwa', translation: '3 — Three', example: 'Les trois mousquetaires.', emoji: '3️⃣'),
        LessonItem(term: 'Quatre', pronunciation: 'ka-tr', translation: '4 — Four', example: 'Quatre saisons.', emoji: '4️⃣'),
        LessonItem(term: 'Cinq', pronunciation: 'sank', translation: '5 — Five', example: 'Cinq doigts de la main.', emoji: '5️⃣'),
        LessonItem(term: 'Six', pronunciation: 'seess', translation: '6 — Six', example: 'Six mois de vacances.', emoji: '6️⃣'),
        LessonItem(term: 'Sept', pronunciation: 'set', translation: '7 — Seven', example: 'Sept jours dans la semaine.', emoji: '7️⃣'),
        LessonItem(term: 'Huit', pronunciation: 'weet', translation: '8 — Eight', example: 'Huit heures de sommeil.', emoji: '8️⃣'),
        LessonItem(term: 'Neuf', pronunciation: 'neuf', translation: '9 — Nine', example: 'Neuf vies de chat.', emoji: '9️⃣'),
      ],
    },
    // ───────── TURC ─────────
    'tr': {
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
      'cat_nombres_tr': [
        LessonItem(term: 'Sıfır', pronunciation: 'sı-fır', translation: '0 — Zéro', example: 'Sıfır hata.', emoji: '0️⃣'),
        LessonItem(term: 'Bir', pronunciation: 'bir', translation: '1 — Un', example: 'Bir elma yedim.', emoji: '1️⃣'),
        LessonItem(term: 'İki', pronunciation: 'i-ki', translation: '2 — Deux', example: 'İki kitap okudum.', emoji: '2️⃣'),
        LessonItem(term: 'Üç', pronunciation: 'üç', translation: '3 — Trois', example: 'Üç kardeşiz.', emoji: '3️⃣'),
        LessonItem(term: 'Dört', pronunciation: 'dört', translation: '4 — Quatre', example: 'Dört mevsim var.', emoji: '4️⃣'),
        LessonItem(term: 'Beş', pronunciation: 'beş', translation: '5 — Cinq', example: 'Beş parmağım var.', emoji: '5️⃣'),
      ],
    },
    // ───────── ANGLAIS ─────────
    'en': {
      'cat_salutations_en': [
        LessonItem(term: 'Hello', pronunciation: 'hel-oh', translation: 'Bonjour / Hello', example: 'Hello! How are you?', emoji: '👋'),
        LessonItem(term: 'Hi', pronunciation: 'hi', translation: 'Salut / Hi', example: 'Hi there!', emoji: '👋'),
        LessonItem(term: 'Good morning', pronunciation: 'good mor-ning', translation: 'Bonjour (matin)', example: 'Good morning, everyone!', emoji: '🌅'),
        LessonItem(term: 'Thank you', pronunciation: 'thank yoo', translation: 'Merci', example: 'Thank you very much!', emoji: '🙏'),
        LessonItem(term: 'Please', pronunciation: 'pleez', translation: 'S\'il vous plaît', example: 'Please help me.', emoji: '🙏'),
        LessonItem(term: 'Yes', pronunciation: 'yes', translation: 'Oui', example: 'Yes, I can.', emoji: '✅'),
        LessonItem(term: 'No', pronunciation: 'noh', translation: 'Non', example: 'No, thanks.', emoji: '❌'),
        LessonItem(term: 'Goodbye', pronunciation: 'good-bye', translation: 'Au revoir', example: 'Goodbye! See you later.', emoji: '👋'),
        LessonItem(term: 'How are you?', pronunciation: 'how ar yoo', translation: 'Comment vas-tu ?', example: 'How are you today?', emoji: '🤔'),
        LessonItem(term: 'I am fine', pronunciation: 'i am fyn', translation: 'Je vais bien', example: 'I am fine, thank you.', emoji: '😊'),
      ],
    },
  };

  /// Retourne la liste des items de contenu pour une langue et une catégorie données.
  static List<LessonItem> getItems(String languageId, String categoryId) {
    final langContent = content[languageId];
    if (langContent == null) return _defaultItems(categoryId);

    if (langContent.containsKey(categoryId)) return langContent[categoryId]!;

    // Flou matching pour supporter les variations d'ID entre branches
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
    // Fournit au moins 5 items pour que le générateur de quiz fonctionne toujours
    return [
      const LessonItem(term: 'Bonjour', pronunciation: '...', translation: 'Hello', example: 'Bonjour !', emoji: '👋'),
      const LessonItem(term: 'Merci', pronunciation: '...', translation: 'Thank you', example: 'Merci beaucoup !', emoji: '🙏'),
      const LessonItem(term: 'Oui', pronunciation: '...', translation: 'Yes', example: 'Oui, s\'il vous plaît.', emoji: '✅'),
      const LessonItem(term: 'Non', pronunciation: '...', translation: 'No', example: 'Non, merci.', emoji: '❌'),
      const LessonItem(term: 'Chat', pronunciation: '...', translation: 'Cat', example: 'Le chat dort.', emoji: '🐱'),
    ];
  }
}
