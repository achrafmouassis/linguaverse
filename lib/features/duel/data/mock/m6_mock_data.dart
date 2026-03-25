// ════════════════════════════════════════════════════════════════
// FICHIER DE DONNÉES PROVISOIRES — MODULE M6 DUEL
// ════════════════════════════════════════════════════════════════
// TOUTES les données de ce fichier sont temporaires.
// Pour connecter à un backend :
//   1. Remplacer chaque Map/List par un appel API correspondant
//   2. Utiliser Firebase Realtime Database pour le multijoueur réel
//   3. Les questions seront tirées de la table vocabulary (M2 Leçons)
// ════════════════════════════════════════════════════════════════

class M6MockData {
  // ── MODES DE JEU ─────────────────────────────────────────────
  // SOURCE RÉELLE : Table duel_game_modes (à créer) ou config Firebase
  // POUR REMPLACER : DuelConfigService.getAvailableModes()
  static const List<Map<String, dynamic>> gameModes = [
    {
      'id': 'qcm',
      'title': 'QCM Rapide',
      'subtitle': '10 questions · 30s chacune',
      'icon': '⚡',
      'colorHex': '#534AB7',
      'xpWin': 120,
      'xpLoss': 25,
      'questionCount': 10,
      'timePerQ': 30,
      'description': 'Choix multiples sur le vocabulaire et la grammaire',
    },
    {
      'id': 'vocabulary',
      'title': 'Vocabulaire',
      'subtitle': 'Traduction directe · 15 mots',
      'icon': '🔤',
      'colorHex': '#1D9E75',
      'xpWin': 100,
      'xpLoss': 20,
      'questionCount': 15,
      'timePerQ': 20,
      'description': 'Traduire des mots de ta langue vers la langue cible',
    },
    {
      'id': 'emoji_battle',
      'title': 'Emoji Battle',
      'subtitle': 'Décode les emojis plus vite',
      'icon': '🌍',
      'colorHex': '#EF9F27',
      'xpWin': 80,
      'xpLoss': 15,
      'questionCount': 12,
      'timePerQ': 15,
      'description': 'Trouver le mot correspondant aux emojis affichés',
    },
    {
      'id': 'speed_round',
      'title': 'Speed Round',
      'subtitle': '20 questions · 10s chacune',
      'icon': '🚀',
      'colorHex': '#E24B4A',
      'xpWin': 150,
      'xpLoss': 30,
      'questionCount': 20,
      'timePerQ': 10,
      'description': 'Le plus rapide gagne — réflexes et mémoire',
    },
  ];

  // ── QUESTIONS QCM — PAR LANGUE ─────────────────────────────────
  // SOURCE RÉELLE :
  //   → Table sqflite vocabulary (M2 Leçons) WHERE language = ?
  //      AND question_type = 'qcm' ORDER BY RANDOM() LIMIT N
  //   → Ou API : GET /api/duel/questions?lang={lang}&mode=qcm&count=10
  // POUR REMPLACER : DuelQuestionService.generateQuestions(mode, lang, count)
  static const Map<String, List<Map<String, dynamic>>> qcmQuestions = {
    'Arabe': [
      {
        'text': 'Comment dit-on "bibliothèque" en arabe ?',
        'correct': 'مكتبة — Maktaba',
        'choices': ['مكتبة — Maktaba', 'مدرسة — Madrasa', 'كتاب — Kitab', 'جامعة — Jami\'a'],
        'difficulty': 2,
      },
      {
        'text': 'Que signifie "شمس" en français ?',
        'correct': 'Soleil',
        'choices': ['Soleil', 'Lune', 'Étoile', 'Ciel'],
        'difficulty': 1,
      },
      {
        'text': 'Comment dit-on "Je m\'appelle" en arabe ?',
        'correct': 'اسمي — Ismi',
        'choices': ['اسمي — Ismi', 'أنا — Ana', 'مرحبا — Marhaba', 'شكرا — Shukran'],
        'difficulty': 1,
      },
      {
        'text': 'Quelle est la traduction de "maison" ?',
        'correct': 'بيت — Bayt',
        'choices': ['بيت — Bayt', 'شارع — Shara\'', 'مدينة — Madina', 'قرية — Qarya'],
        'difficulty': 1,
      },
      {
        'text': 'Comment dit-on "médecin" en arabe ?',
        'correct': 'طبيب — Tabib',
        'choices': ['طبيب — Tabib', 'مهندس — Mohandis', 'معلم — Mo\'allim', 'محامي — Mohami'],
        'difficulty': 2,
      },
      {
        'text': 'Que signifie "كبير" ?',
        'correct': 'Grand / Gros',
        'choices': ['Grand / Gros', 'Petit', 'Beau', 'Vieux'],
        'difficulty': 1,
      },
      {
        'text': 'Comment dit-on "eau" en arabe ?',
        'correct': 'ماء — Ma\' ',
        'choices': ['ماء — Ma\' ', 'حليب — Halib', 'عصير — Asir', 'شاي — Shay'],
        'difficulty': 1,
      },
      {
        'text': 'Que signifie "سريع" ?',
        'correct': 'Rapide',
        'choices': ['Rapide', 'Lent', 'Fort', 'Doux'],
        'difficulty': 2,
      },
      {
        'text': 'Comment écrit-on le chiffre "5" en arabe ?',
        'correct': 'خمسة — Khamsa',
        'choices': ['خمسة — Khamsa', 'أربعة — Arba\'a', 'ستة — Sitta', 'سبعة — Sab\'a'],
        'difficulty': 1,
      },
      {
        'text': 'Que signifie "صديق" ?',
        'correct': 'Ami',
        'choices': ['Ami', 'Famille', 'Voisin', 'Collègue'],
        'difficulty': 1,
      },
      {
        'text': 'Comment dit-on "merci beaucoup" en arabe ?',
        'correct': 'شكراً جزيلاً',
        'choices': ['شكراً جزيلاً', 'من فضلك', 'آسف', 'مرحبا'],
        'difficulty': 1,
      },
      {
        'text': 'Que signifie "سفر" ?',
        'correct': 'Voyage',
        'choices': ['Voyage', 'Travail', 'Repos', 'Repas'],
        'difficulty': 2,
      },
      {
        'text': 'Comment dit-on "école" en arabe ?',
        'correct': 'مدرسة — Madrasa',
        'choices': ['مدرسة — Madrasa', 'جامعة — Jami\'a', 'مكتبة — Maktaba', 'مصنع — Masna\''],
        'difficulty': 1,
      },
      {
        'text': 'Que signifie "قمر" ?',
        'correct': 'Lune',
        'choices': ['Lune', 'Soleil', 'Étoile', 'Nuage'],
        'difficulty': 1,
      },
      {
        'text': 'Comment dit-on "chat" en arabe ?',
        'correct': 'قطة — Qitta',
        'choices': ['قطة — Qitta', 'كلب — Kalb', 'طائر — Ta\'ir', 'سمكة — Samaka'],
        'difficulty': 1,
      },
      {
        'text': 'Que signifie "نعم" ?',
        'correct': 'Oui',
        'choices': ['Oui', 'Non', 'Peut-être', 'Jamais'],
        'difficulty': 1,
      },
      {
        'text': 'Comment dit-on "ville" en arabe ?',
        'correct': 'مدينة — Madina',
        'choices': ['مدينة — Madina', 'قرية — Qarya', 'بلدة — Balda', 'دولة — Dawla'],
        'difficulty': 1,
      },
      {
        'text': 'Que signifie "أسرة" ?',
        'correct': 'Famille',
        'choices': ['Famille', 'Maison', 'Chambre', 'Cuisine'],
        'difficulty': 2,
      },
      {
        'text': 'Comment dit-on "rouge" en arabe ?',
        'correct': 'أحمر — Ahmar',
        'choices': ['أحمر — Ahmar', 'أزرق — Azraq', 'أخضر — Akhdar', 'أصفر — Asfar'],
        'difficulty': 2,
      },
      {
        'text': 'Que signifie "كتب" (verbe) ?',
        'correct': 'Écrire',
        'choices': ['Écrire', 'Lire', 'Parler', 'Écouter'],
        'difficulty': 2,
      },
    ],
    'Anglais': [
      {
        'text': 'What does "ephemeral" mean?',
        'correct': 'Short-lived / temporary',
        'choices': ['Short-lived / temporary', 'Eternal', 'Beautiful', 'Mysterious'],
        'difficulty': 3,
      },
      {
        'text': 'Which word means "to improve"?',
        'correct': 'Enhance',
        'choices': ['Enhance', 'Reduce', 'Ignore', 'Break'],
        'difficulty': 2,
      },
      {
        'text': 'What is the plural of "mouse"?',
        'correct': 'Mice',
        'choices': ['Mice', 'Mouses', 'Mouse', 'Meece'],
        'difficulty': 2,
      },
      {
        'text': 'What does "ubiquitous" mean?',
        'correct': 'Present everywhere',
        'choices': ['Present everywhere', 'Very rare', 'Extremely fast', 'Very old'],
        'difficulty': 3,
      },
      {
        'text': 'What is a "sibling"?',
        'correct': 'Brother or sister',
        'choices': ['Brother or sister', 'Parent', 'Cousin', 'Friend'],
        'difficulty': 1,
      },
      {
        'text': 'What does "persevere" mean?',
        'correct': 'To continue despite difficulties',
        'choices': [
          'To continue despite difficulties',
          'To stop trying',
          'To give up quickly',
          'To rest'
        ],
        'difficulty': 2,
      },
      {
        'text': 'What is the opposite of "ancient"?',
        'correct': 'Modern',
        'choices': ['Modern', 'Old', 'Historical', 'Classic'],
        'difficulty': 2,
      },
      {
        'text': 'Which word means "very cold"?',
        'correct': 'Frigid',
        'choices': ['Frigid', 'Tepid', 'Warm', 'Scorching'],
        'difficulty': 2,
      },
      {
        'text': 'What does "eloquent" mean?',
        'correct': 'Fluent and persuasive in speaking',
        'choices': [
          'Fluent and persuasive in speaking',
          'Shy and withdrawn',
          'Loud and angry',
          'Bored'
        ],
        'difficulty': 3,
      },
      {
        'text': 'What is a "peninsula"?',
        'correct': 'Land almost surrounded by water',
        'choices': [
          'Land almost surrounded by water',
          'A large island',
          'A mountain range',
          'A desert'
        ],
        'difficulty': 2,
      },
    ],
  };

  // ── QUESTIONS VOCABULAIRE (traduction directe) ─────────────────
  // SOURCE RÉELLE : vocabulary table WHERE has_translation = 1
  // POUR REMPLACER : DuelQuestionService.getVocabQuestions(lang, count)
  static const List<Map<String, dynamic>> vocabQuestions = [
    // TODO(DB) : Lier à la table vocabulary de M2 (Leçons)
    {'word': 'Voiture', 'answer': 'سيارة', 'transliteration': 'Sayyara', 'language': 'Arabe'},
    {'word': 'Professeur', 'answer': 'أستاذ', 'transliteration': 'Ustaz', 'language': 'Arabe'},
    {'word': 'Hôpital', 'answer': 'مستشفى', 'transliteration': 'Mustashfa', 'language': 'Arabe'},
    {'word': 'Ordinateur', 'answer': 'حاسوب', 'transliteration': 'Hasub', 'language': 'Arabe'},
    {'word': 'Famille', 'answer': 'عائلة', 'transliteration': 'A\'ila', 'language': 'Arabe'},
    {'word': 'Amour', 'answer': 'حب', 'transliteration': 'Hubb', 'language': 'Arabe'},
    {'word': 'Travail', 'answer': 'عمل', 'transliteration': '\'Amal', 'language': 'Arabe'},
    {'word': 'Voyage', 'answer': 'رحلة', 'transliteration': 'Rihla', 'language': 'Arabe'},
    {'word': 'Nourriture', 'answer': 'طعام', 'transliteration': 'Ta\'am', 'language': 'Arabe'},
    {'word': 'Nuit', 'answer': 'ليل', 'transliteration': 'Layl', 'language': 'Arabe'},
    {'word': 'Soleil', 'answer': 'شمس', 'transliteration': 'Shams', 'language': 'Arabe'},
    {'word': 'Eau', 'answer': 'ماء', 'transliteration': 'Ma\'', 'language': 'Arabe'},
    {'word': 'Pain', 'answer': 'خبز', 'transliteration': 'Khubz', 'language': 'Arabe'},
    {'word': 'Livre', 'answer': 'كتاب', 'transliteration': 'Kitab', 'language': 'Arabe'},
    {'word': 'Porte', 'answer': 'باب', 'transliteration': 'Bab', 'language': 'Arabe'},
  ];

  // ── QUESTIONS EMOJI BATTLE ─────────────────────────────────────
  // SOURCE RÉELLE : M7MockData.emojiSimple réutilisé pour cohérence M6↔M7
  // POUR REMPLACER : DuelQuestionService.getEmojiQuestions(lang, count)
  static const List<Map<String, dynamic>> emojiBattleQuestions = [
    {'emoji': '🌙', 'answer': 'Lune / قمر', 'difficulty': 1},
    {'emoji': '🌊', 'answer': 'Vague / موجة', 'difficulty': 1},
    {'emoji': '🏠', 'answer': 'Maison / بيت', 'difficulty': 1},
    {'emoji': '🚗', 'answer': 'Voiture / سيارة', 'difficulty': 1},
    {'emoji': '📚', 'answer': 'Livres / كتب', 'difficulty': 1},
    {'emoji': '💻', 'answer': 'Ordinateur / حاسوب', 'difficulty': 2},
    {'emoji': '🎓', 'answer': 'Diplôme / شهادة', 'difficulty': 2},
    {'emoji': '🌿', 'answer': 'Plante / نبات', 'difficulty': 2},
    {'emoji': '⭐', 'answer': 'Étoile / نجمة', 'difficulty': 1},
    {'emoji': '🌍', 'answer': 'Monde / عالم', 'difficulty': 1},
    {'emoji': '🔑', 'answer': 'Clé / مفتاح', 'difficulty': 2},
    {'emoji': '🎵', 'answer': 'Musique / موسيقى', 'difficulty': 2},
  ];

  // ── HISTORIQUE DES DUELS (données mock réalistes) ─────────────
  // SOURCE RÉELLE : SELECT * FROM duel_sessions WHERE player1_id = ?
  //   ORDER BY created_at DESC LIMIT 10
  // POUR REMPLACER : DuelService.getRecentDuels(userId)
  static const List<Map<String, dynamic>> recentDuels = [
    {
      'opponentName': 'Zineb B.',
      'opponentInitials': 'ZB',
      'result': 'win',
      'myScore': 7,
      'oppScore': 5,
      'mode': 'qcm',
      'xpEarned': 120,
      'isPerfect': false,
      'dateLabel': "Aujourd'hui",
      'gradientStart': 0xFF6359FF,
      'gradientEnd': 0xFFAFA9EC,
    },
    {
      'opponentName': 'MasterBot',
      'opponentInitials': 'MB',
      'result': 'loss',
      'myScore': 4,
      'oppScore': 8,
      'mode': 'speed_round',
      'xpEarned': 25,
      'isPerfect': false,
      'dateLabel': 'Hier',
      'gradientStart': 0xFFD97706,
      'gradientEnd': 0xFFFAC775,
    },
    {
      'opponentName': 'Abdelmoughit',
      'opponentInitials': 'AM',
      'result': 'win',
      'myScore': 10,
      'oppScore': 10,
      'mode': 'vocabulary',
      'xpEarned': 100,
      'isPerfect': true,
      'dateLabel': 'Il y a 2 jours',
      'gradientStart': 0xFFD85A30,
      'gradientEnd': 0xFFFAC775,
    },
    {
      'opponentName': 'SaraBot',
      'opponentInitials': 'SB',
      'result': 'win',
      'myScore': 9,
      'oppScore': 6,
      'mode': 'emoji_battle',
      'xpEarned': 80,
      'isPerfect': false,
      'dateLabel': 'Il y a 3 jours',
      'gradientStart': 0xFF1D9E75,
      'gradientEnd': 0xFF9FE1CB,
    },
  ];

  // ── STATISTIQUES DUEL DE L'UTILISATEUR ────────────────────────
  // SOURCE RÉELLE : SELECT COUNT(*), SUM, AVG FROM duel_sessions
  //   WHERE player1_id = ? GROUP BY result
  // POUR REMPLACER : DuelService.getUserStats(userId)
  static const Map<String, dynamic> userDuelStats = {
    'totalDuels': 23, // TODO(DB) : COUNT(*) FROM duel_sessions
    'wins': 16, // TODO(DB) : COUNT(*) WHERE winner_id = userId
    'losses': 7, // TODO(DB) : totalDuels - wins
    'winRate': 70, // TODO(DB) : ROUND(wins * 100.0 / total)
    'currentStreak': 3, // TODO(DB) : Calculé depuis les résultats récents
    'bestStreak': 5, // TODO(DB) : MAX streak historique
    'perfects': 2, // TODO(DB) : COUNT(*) WHERE is_perfect = 1
    'avgScore': 7.2, // TODO(DB) : AVG(player1_score)
    'favMode': 'QCM Rapide', // TODO(DB) : MODE(game_mode)
    'totalXPFromDuels': 1840, // TODO(DB) : SUM(xp_earned)
  };

  // ── MESSAGES DE VICTOIRE/DÉFAITE ──────────────────────────────
  // SOURCE RÉELLE : assets/data/duel_messages.json (à créer)
  // POUR REMPLACER : DuelMessageService.getMessage(result, score)
  static const Map<String, List<String>> resultMessages = {
    'win': [
      '🏆 Imbattable ! Tu domines le duel !',
      '⚡ Éclair de vitesse ! Victoire écrasante !',
      '🔥 En feu ! Personne ne peut t\'arrêter !',
      '⭐ Magistral ! Tu mérites le titre de champion !',
      '💪 Force et précision — le combo parfait !',
    ],
    'loss': [
      '📖 Chaque défaite est une leçon précieuse !',
      '💪 Revanche ? La prochaine victoire est proche !',
      '🎯 Analyse tes erreurs et reviens plus fort !',
      '🌟 Tu progresses à chaque duel !',
      '🔄 Un pas en arrière, deux en avant !',
    ],
    'perfect': [
      '💎 PARFAIT ! 100% de bonnes réponses !',
      '🌟 Flawless Victory ! Aucune erreur !',
      '👑 Le maître absolu du vocabulaire !',
    ],
    'draw': [
      '🤝 Égalité ! Vous êtes faits du même bois !',
      '⚖️ Match nul — la prochaine fois c\'est toi !',
    ],
  };
}
