// ════════════════════════════════════════════════════════════════
// FICHIER DE DONNÉES PROVISOIRES — MODULE M7
// ════════════════════════════════════════════════════════════════
// TOUTES les constantes de ce fichier sont temporaires.
// Pour connecter à un backend réel :
//   1. Remplacer chaque Map/List par un appel à l'API correspondante
//   2. Garder les mêmes clés pour ne pas modifier les widgets
//   3. Utiliser les services sqflite déjà en place pour la persistence
// ════════════════════════════════════════════════════════════════

class M7MockData {
  // ── PROFIL UTILISATEUR ───────────────────────────────────────
  // TODO(API) : Remplacer par userProgressionProvider.value
  static const Map<String, dynamic> userProfile = {
    'name': 'Hiba EL OUAFI',
    'initials': 'HE',
    'level': 7,
    'levelTitle': 'Étudiant',
    'currentXP': 3400,
    'nextLevelXP': 5000,
    'totalXP': 3400,
    'streakDays': 14,
    'streakBest': 21,
    'wordsLearned': 248,
    'lessonsCompleted': 42,
    'perfectScores': 11,
  };

  // ── NIVEAUX ET SEUILS XP ─────────────────────────────────────
  // TODO(API) : Remplacer par ProgressionService.xpForLevel(n)
  static const List<Map<String, dynamic>> levels = [
    {'level': 1, 'title': 'Novice', 'minXP': 0, 'color': 0xFF888780},
    {'level': 2, 'title': 'Novice', 'minXP': 500, 'color': 0xFF888780},
    {'level': 3, 'title': 'Apprenti', 'minXP': 1075, 'color': 0xFF1D9E75},
    {'level': 4, 'title': 'Apprenti', 'minXP': 1734, 'color': 0xFF1D9E75},
    {'level': 5, 'title': 'Apprenti', 'minXP': 2484, 'color': 0xFF1D9E75},
    {'level': 6, 'title': 'Étudiant', 'minXP': 3334, 'color': 0xFF378ADD},
    {'level': 7, 'title': 'Étudiant', 'minXP': 4284, 'color': 0xFF378ADD},
    {'level': 8, 'title': 'Étudiant', 'minXP': 5334, 'color': 0xFF378ADD},
    {'level': 9, 'title': 'Intermédiaire', 'minXP': 6500, 'color': 0xFF7F77DD},
    {'level': 10, 'title': 'Intermédiaire', 'minXP': 8250, 'color': 0xFF7F77DD},
    {'level': 12, 'title': 'Intermédiaire', 'minXP': 12000, 'color': 0xFF7F77DD},
    {'level': 15, 'title': 'Avancé', 'minXP': 18500, 'color': 0xFFEF9F27},
    {'level': 18, 'title': 'Avancé', 'minXP': 27000, 'color': 0xFFEF9F27},
    {'level': 20, 'title': 'Expert', 'minXP': 35000, 'color': 0xFFD85A30},
    {'level': 25, 'title': 'Expert', 'minXP': 55000, 'color': 0xFFD85A30},
    {'level': 30, 'title': 'Maître', 'minXP': 80000, 'color': 0xFFE24B4A},
  ];

  // ── XP PAR ACTION ────────────────────────────────────────────
  // TODO(API) : Remplacer par ProgressionService._baseXP
  static const Map<String, int> xpRewards = {
    'lesson_complete': 50,
    'quiz_perfect': 100,
    'quiz_pass': 40,
    'daily_challenge': 80,
    'minigame_win': 60,
    'minigame_perfect': 90,
    'wordle_win_1': 150,
    'wordle_win_2': 120,
    'wordle_win_3': 100,
    'wordle_win_4': 80,
    'wordle_win_5': 60,
    'wordle_win_6': 40,
    'hangman_win_0err': 120,
    'hangman_win': 60,
    'synonym_correct': 30,
    'synonym_streak_5': 100,
    'emoji_simple_fast': 80,
    'emoji_simple': 40,
    'emoji_combo': 70,
    'streak_bonus_7': 50,
    'streak_bonus_14': 100,
    'streak_bonus_30': 300,
    'badge_earned': 20,
    // ── XP Duel M6 ───────────────────────────────────────────────────
    // SOURCE RÉELLE : DuelSessionModel.calculateXP() → affiché sur DuelResultPage
    // POUR REMPLACER : DuelConfigService.getXPForResult(mode, result, isPerfect)
    'duel_win': 120, // Victoire standard
    'duel_loss': 25, // Défaite (encouragement)
    'duel_perfect': 150, // Victoire avec 100% bonnes réponses
    'duel_streak_3': 60, // Bonus 3 victoires consécutives
  };

  // ── MESSAGES MOTIVANTS ───────────────────────────────────────
  // TODO(API) : Remplacer par des messages personnalisés depuis l'API
  static const List<String> motivationMessages = [
    'Incroyable ! Tu progresses à vitesse grand V ! 🚀',
    'Encore un effort, tu y es presque ! 💪',
    'Bravo ! Chaque mot appris est une victoire ! 🎯',
    'Tu es en feu aujourd\'hui ! 🔥',
    'Parfait ! Continue comme ça, tu es imbattable ! ⭐',
    'Excellent travail ! Le vocabulaire n\'a plus de secrets ! 🧠',
    'Fantastique ! Tu mérites un badge ! 🏆',
    'Tu apprends comme un champion ! 🥇',
    'Ta régularité est inspirante ! 📈',
    'Le savoir est ton super-pouvoir ! ✨',
    'Chaque jour compte. Continue ! 🌟',
    'Tu construis ton avenir, mot par mot ! 📚',
  ];

  // ══════════════════════════════════════════════════════════════
  // ── MOTS POUR LES MINI-JEUX ──────────────────────────────────
  // TODO(API) : Remplacer par wordsProvider filtré par langue/niveau
  // ══════════════════════════════════════════════════════════════

  // ── Wordle (5 lettres) ────────────────────────────────────────
  static const Map<String, List<Map<String, dynamic>>> wordleWords = {
    'Arabe': [
      {'word': 'KITAB', 'hint': 'Objet pour lire', 'translation': 'Livre'},
      {'word': 'SHAMS', 'hint': 'Astre du jour', 'translation': 'Soleil'},
      {'word': 'WALAD', 'hint': 'Jeune personne', 'translation': 'Enfant'},
      {'word': 'MADAR', 'hint': 'Lieu d\'étude', 'translation': 'École'},
      {'word': 'QALAM', 'hint': 'Pour écrire', 'translation': 'Stylo'},
      {'word': 'HAFLA', 'hint': 'Fête ou cérémonie', 'translation': 'Fête'},
      {'word': 'SABAH', 'hint': 'Début de journée', 'translation': 'Matin'},
      {'word': 'LAYLA', 'hint': 'Quand les étoiles brillent', 'translation': 'Nuit'},
      {'word': 'QAMAR', 'hint': 'Astre de la nuit', 'translation': 'Lune'},
      {'word': 'JAWAB', 'hint': 'Réponse à une question', 'translation': 'Réponse'},
      {'word': 'KALIM', 'hint': 'Unité de langage', 'translation': 'Mot'},
      {'word': 'SAHRA', 'hint': 'Immensité de sable', 'translation': 'Désert'},
      {'word': 'JABAL', 'hint': 'Formation rocheuse haute', 'translation': 'Montagne'},
      {'word': 'NAHR', 'hint': 'Cours d\'eau', 'translation': 'Rivière'},
      {'word': 'BAHR', 'hint': 'Grande étendue d\'eau', 'translation': 'Mer'},
      {'word': 'WARD', 'hint': 'Belle plante parfumée', 'translation': 'Rose'},
      {'word': 'SIHAM', 'hint': 'Projectiles', 'translation': 'Flèches'},
      {'word': 'TILMZ', 'hint': 'Personne qui apprend', 'translation': 'Élève'},
      {'word': 'FASIL', 'hint': 'Partie de l\'année', 'translation': 'Saison'},
      {'word': 'TARIQ', 'hint': 'Voie de passage', 'translation': 'Chemin'},
    ],
    'Anglais': [
      {'word': 'CHAIR', 'hint': 'You sit on it', 'translation': 'Chaise'},
      {'word': 'LIGHT', 'hint': 'Not heavy', 'translation': 'Léger'},
      {'word': 'WATER', 'hint': 'You drink it', 'translation': 'Eau'},
      {'word': 'HOUSE', 'hint': 'A building to live in', 'translation': 'Maison'},
      {'word': 'BREAD', 'hint': 'Baked food', 'translation': 'Pain'},
      {'word': 'SMILE', 'hint': 'Happy face expression', 'translation': 'Sourire'},
      {'word': 'PLANT', 'hint': 'Green living thing', 'translation': 'Plante'},
      {'word': 'CLOUD', 'hint': 'White in the sky', 'translation': 'Nuage'},
      {'word': 'DANCE', 'hint': 'Move to music', 'translation': 'Danse'},
      {'word': 'BRAVE', 'hint': 'Not afraid', 'translation': 'Brave'},
      {'word': 'DREAM', 'hint': 'While you sleep', 'translation': 'Rêve'},
      {'word': 'EARTH', 'hint': 'Our planet', 'translation': 'Terre'},
      {'word': 'FLAME', 'hint': 'Part of a fire', 'translation': 'Flamme'},
      {'word': 'GRAIN', 'hint': 'Tiny piece of wheat', 'translation': 'Grain'},
      {'word': 'HEART', 'hint': 'Pumps blood', 'translation': 'Cœur'},
      {'word': 'JUICE', 'hint': 'Fruit drink', 'translation': 'Jus'},
      {'word': 'QUICK', 'hint': 'Very fast', 'translation': 'Rapide'},
      {'word': 'WORLD', 'hint': 'The whole planet', 'translation': 'Monde'},
      {'word': 'STONE', 'hint': 'Hard natural material', 'translation': 'Pierre'},
      {'word': 'TOWER', 'hint': 'Tall structure', 'translation': 'Tour'},
    ],
    'Français': [
      {'word': 'TABLE', 'hint': 'Meuble plat', 'translation': 'Table'},
      {'word': 'ROUGE', 'hint': 'Couleur chaude', 'translation': 'Rouge'},
      {'word': 'POMME', 'hint': 'Fruit rond', 'translation': 'Apple'},
      {'word': 'LIVRE', 'hint': 'On y lit', 'translation': 'Book'},
      {'word': 'ECOLE', 'hint': 'Lieu d\'étude', 'translation': 'School'},
      {'word': 'NUAGE', 'hint': 'Blanc dans le ciel', 'translation': 'Cloud'},
      {'word': 'TERRE', 'hint': 'Notre planète', 'translation': 'Earth'},
      {'word': 'PLAGE', 'hint': 'Sable au bord de mer', 'translation': 'Beach'},
      {'word': 'DOUCE', 'hint': 'Contraire de dur', 'translation': 'Soft'},
      {'word': 'JARDN', 'hint': 'Espace vert', 'translation': 'Garden'},
      {'word': 'FLEUR', 'hint': 'Belle plante colorée', 'translation': 'Flower'},
      {'word': 'VERRE', 'hint': 'Pour boire', 'translation': 'Glass'},
      {'word': 'REINE', 'hint': 'Femme du roi', 'translation': 'Queen'},
      {'word': 'PLUIE', 'hint': 'Eau qui tombe du ciel', 'translation': 'Rain'},
      {'word': 'FORET', 'hint': 'Beaucoup d\'arbres', 'translation': 'Forest'},
      {'word': 'CHAUD', 'hint': 'Haute température', 'translation': 'Hot'},
      {'word': 'BOIRE', 'hint': 'Action avec de l\'eau', 'translation': 'Drink'},
      {'word': 'FROID', 'hint': 'Basse température', 'translation': 'Cold'},
      {'word': 'MUSIQ', 'hint': 'Art des sons', 'translation': 'Music'},
      {'word': 'NEIGE', 'hint': 'Blanche et froide', 'translation': 'Snow'},
    ],
  };

  // ── Pendu (6-8 lettres) ──────────────────────────────────────
  static const Map<String, List<Map<String, dynamic>>> hangmanWords = {
    'Arabe': [
      {'word': 'MAKTABA', 'category': 'Lieux', 'translation': 'Bibliothèque'},
      {'word': 'SAYYARA', 'category': 'Transport', 'translation': 'Voiture'},
      {'word': 'MADINA', 'category': 'Lieux', 'translation': 'Ville'},
      {'word': 'TAWILA', 'category': 'Maison', 'translation': 'Table'},
      {'word': 'QAMIS', 'category': 'Vêtements', 'translation': 'Chemise'},
      {'word': 'USTADH', 'category': 'Personnes', 'translation': 'Professeur'},
      {'word': 'HOSPITAL', 'category': 'Lieux', 'translation': 'Hôpital'},
      {'word': 'MAKTUB', 'category': 'Concepts', 'translation': 'Destinée'},
      {'word': 'SHAJAR', 'category': 'Nature', 'translation': 'Arbres'},
      {'word': 'TUFFAH', 'category': 'Nourriture', 'translation': 'Pomme'},
      {'word': 'JUMLA', 'category': 'Grammaire', 'translation': 'Phrase'},
      {'word': 'SAFAR', 'category': 'Voyage', 'translation': 'Voyage'},
      {'word': 'JARIIDA', 'category': 'Médias', 'translation': 'Journal'},
      {'word': 'MIFTAH', 'category': 'Objets', 'translation': 'Clé'},
      {'word': 'SUNDUZ', 'category': 'Objets', 'translation': 'Boîte'},
      {'word': 'KURSI', 'category': 'Maison', 'translation': 'Chaise'},
      {'word': 'MUSKI', 'category': 'Arts', 'translation': 'Musique'},
      {'word': 'DARAJA', 'category': 'Concepts', 'translation': 'Degré'},
      {'word': 'FALAK', 'category': 'Science', 'translation': 'Astronomie'},
      {'word': 'HAYAWAN', 'category': 'Nature', 'translation': 'Animal'},
    ],
    'Anglais': [
      {'word': 'ELEPHANT', 'category': 'Animals', 'translation': 'Éléphant'},
      {'word': 'COMPUTER', 'category': 'Tech', 'translation': 'Ordinateur'},
      {'word': 'MOUNTAIN', 'category': 'Nature', 'translation': 'Montagne'},
      {'word': 'RAINBOW', 'category': 'Nature', 'translation': 'Arc-en-ciel'},
      {'word': 'LANGUAGE', 'category': 'Study', 'translation': 'Langue'},
      {'word': 'TEACHER', 'category': 'People', 'translation': 'Professeur'},
      {'word': 'LIBRARY', 'category': 'Places', 'translation': 'Bibliothèque'},
      {'word': 'KITCHEN', 'category': 'Home', 'translation': 'Cuisine'},
      {'word': 'CHICKEN', 'category': 'Animals', 'translation': 'Poulet'},
      {'word': 'WEATHER', 'category': 'Nature', 'translation': 'Météo'},
      {'word': 'HARMONY', 'category': 'Music', 'translation': 'Harmonie'},
      {'word': 'FREEDOM', 'category': 'Concepts', 'translation': 'Liberté'},
      {'word': 'JOURNEY', 'category': 'Travel', 'translation': 'Voyage'},
      {'word': 'PICTURE', 'category': 'Art', 'translation': 'Image'},
      {'word': 'CAPTAIN', 'category': 'People', 'translation': 'Capitaine'},
      {'word': 'SHELTER', 'category': 'Places', 'translation': 'Abri'},
      {'word': 'GRAVITY', 'category': 'Science', 'translation': 'Gravité'},
      {'word': 'SILENCE', 'category': 'Concepts', 'translation': 'Silence'},
      {'word': 'DIAMOND', 'category': 'Objects', 'translation': 'Diamant'},
      {'word': 'DOLPHIN', 'category': 'Animals', 'translation': 'Dauphin'},
    ],
  };

  // ── Paires synonymes / antonymes ─────────────────────────────
  // TODO(API) : Charger depuis la table vocabulary de sqflite
  static const List<Map<String, dynamic>> synonymPairs = [
    {
      'word': 'Rapide',
      'synonyms': ['VITE', 'PROMPT', 'AGILE', 'VÉLOCE'],
      'antonyms': ['LENT', 'CALME', 'PARESSEUX']
    },
    {
      'word': 'Heureux',
      'synonyms': ['JOYEUX', 'CONTENT', 'GAI', 'RADIEUX'],
      'antonyms': ['TRISTE', 'MALHEUREUX', 'ABATTU']
    },
    {
      'word': 'Grand',
      'synonyms': ['ÉLEVÉ', 'IMPOSANT', 'VASTE', 'IMMENSE'],
      'antonyms': ['PETIT', 'MINUSCULE', 'ÉTROIT']
    },
    {
      'word': 'Brillant',
      'synonyms': ['INTELLIGENT', 'VIF', 'DOUÉ', 'ÉCLAIRÉ'],
      'antonyms': ['STUPIDE', 'LENT', 'TERNE']
    },
    {
      'word': 'Ancien',
      'synonyms': ['VIEUX', 'ANTIQUE', 'VÉTUSTE', 'USAGÉ'],
      'antonyms': ['NOUVEAU', 'RÉCENT', 'MODERNE']
    },
    {
      'word': 'Courageux',
      'synonyms': ['BRAVE', 'INTRÉPIDE', 'AUDACIEUX', 'VAILLANT'],
      'antonyms': ['PEUREUX', 'LÂCHE', 'TIMIDE']
    },
    {
      'word': 'Chaud',
      'synonyms': ['TIÈDE', 'BRÛLANT', 'TORRIDE', 'ARDENT'],
      'antonyms': ['FROID', 'GLACIAL', 'FRAIS']
    },
    {
      'word': 'Facile',
      'synonyms': ['SIMPLE', 'AISÉ', 'ACCESSIBLE', 'ENFANTIN'],
      'antonyms': ['DIFFICILE', 'COMPLEXE', 'DUR']
    },
    {
      'word': 'Beau',
      'synonyms': ['JOLI', 'MAGNIFIQUE', 'SUPERBE', 'SPLENDIDE'],
      'antonyms': ['LAID', 'AFFREUX', 'MOCHE']
    },
    {
      'word': 'Fort',
      'synonyms': ['ROBUSTE', 'PUISSANT', 'VIGOUREUX', 'SOLIDE'],
      'antonyms': ['FAIBLE', 'FRAGILE', 'CHÉTIF']
    },
    {
      'word': 'Riche',
      'synonyms': ['AISÉ', 'FORTUNÉ', 'PROSPÈRE', 'OPULENT'],
      'antonyms': ['PAUVRE', 'DÉMUNI', 'MISÉRABLE']
    },
    {
      'word': 'Calme',
      'synonyms': ['SEREIN', 'PAISIBLE', 'TRANQUILLE', 'POSÉ'],
      'antonyms': ['AGITÉ', 'NERVEUX', 'TURBULENT']
    },
    {
      'word': 'Sombre',
      'synonyms': ['OBSCUR', 'TÉNÉBREUX', 'NOIR', 'OPAQUE'],
      'antonyms': ['CLAIR', 'LUMINEUX', 'BRILLANT']
    },
    {
      'word': 'Rapide',
      'synonyms': ['FULGURANT', 'PRESTE', 'ALERTE', 'LESTE'],
      'antonyms': ['TRAÎNANT', 'POUSSIF', 'MOLLASSON']
    },
    {
      'word': 'Gentil',
      'synonyms': ['AIMABLE', 'BIENVEILLANT', 'DOUX', 'ATTENTIONNÉ'],
      'antonyms': ['MÉCHANT', 'CRUEL', 'DUR']
    },
    {
      'word': 'Triste',
      'synonyms': ['MÉLANCOLIQUE', 'MOROSE', 'SOMBRE', 'CHAGRINÉ'],
      'antonyms': ['JOYEUX', 'GAI', 'RADIEUX']
    },
    {
      'word': 'Propre',
      'synonyms': ['NET', 'IMMACULÉ', 'SOIGNÉ', 'IMPECCABLE'],
      'antonyms': ['SALE', 'CRASSEUX', 'SOUILLÉ']
    },
    {
      'word': 'Sage',
      'synonyms': ['PRUDENT', 'AVISÉ', 'SENSÉ', 'RÉFLÉCHI'],
      'antonyms': ['FOU', 'IMPRUDENT', 'INSENSÉ']
    },
    {
      'word': 'Vrai',
      'synonyms': ['EXACT', 'AUTHENTIQUE', 'RÉEL', 'JUSTE'],
      'antonyms': ['FAUX', 'FICTIF', 'ERRONÉ']
    },
    {
      'word': 'Dur',
      'synonyms': ['RIGIDE', 'FERME', 'INFLEXIBLE', 'RÉSISTANT'],
      'antonyms': ['MOU', 'SOUPLE', 'TENDRE']
    },
    {
      'word': 'Loin',
      'synonyms': ['ÉLOIGNÉ', 'DISTANT', 'RECULÉ', 'ISOLÉ'],
      'antonyms': ['PROCHE', 'PRÈS', 'ADJACENT']
    },
    {
      'word': 'Profond',
      'synonyms': ['ABYSSAL', 'INTENSE', 'GRAVE', 'INSONDABLE'],
      'antonyms': ['SUPERFICIEL', 'LÉGER', 'CREUX']
    },
    {
      'word': 'Lourd',
      'synonyms': ['PESANT', 'MASSIF', 'PONDÉREUX', 'ÉPAIS'],
      'antonyms': ['LÉGER', 'AÉRIEN', 'DÉLICAT']
    },
    {
      'word': 'Doux',
      'synonyms': ['TENDRE', 'SUAVE', 'MOELLEUX', 'SOYEUX'],
      'antonyms': ['RUDE', 'RUGUEUX', 'ÂPRE']
    },
    {
      'word': 'Étroit',
      'synonyms': ['SERRÉ', 'EXIGU', 'RESTREINT', 'MINCE'],
      'antonyms': ['LARGE', 'SPACIEUX', 'VASTE']
    },
    {
      'word': 'Jeune',
      'synonyms': ['ADOLESCENT', 'JUVÉNILE', 'FRAIS', 'NOVICE'],
      'antonyms': ['VIEUX', 'ÂGÉ', 'ANCIEN']
    },
    {
      'word': 'Plein',
      'synonyms': ['COMBLE', 'REMPLI', 'BONDÉ', 'SATURÉ'],
      'antonyms': ['VIDE', 'CREUX', 'VACANT']
    },
    {
      'word': 'Long',
      'synonyms': ['ÉTENDU', 'PROLONGÉ', 'INTERMINABLE', 'ALLONGÉ'],
      'antonyms': ['COURT', 'BREF', 'CONCIS']
    },
    {
      'word': 'Sec',
      'synonyms': ['ARIDE', 'DÉSHYDRATÉ', 'DESSÉCHÉ', 'STÉRILE'],
      'antonyms': ['HUMIDE', 'MOUILLÉ', 'TREMPÉ']
    },
    {
      'word': 'Lent',
      'synonyms': ['TRAÎNANT', 'POUSSIF', 'APATHIQUE', 'NONCHALANT'],
      'antonyms': ['RAPIDE', 'VIF', 'ALERTE']
    },
  ];

  // ── Données pour le jeu Emoji ─────────────────────────────────
  // TODO(API) : Charger depuis la table vocabulary avec colonnes emoji
  static const List<Map<String, dynamic>> emojiSimple = [
    {'emoji': '🍎', 'answer': 'APPLE', 'hint': 'Un fruit rouge', 'language': 'Anglais'},
    {'emoji': '🌊', 'answer': 'WAVE', 'hint': 'Mouvement de l\'eau', 'language': 'Anglais'},
    {'emoji': '🌙', 'answer': 'MOON', 'hint': 'La nuit', 'language': 'Anglais'},
    {'emoji': '🔥', 'answer': 'FIRE', 'hint': 'Chaud !', 'language': 'Anglais'},
    {'emoji': '🌸', 'answer': 'FLOWER', 'hint': 'Belle nature', 'language': 'Anglais'},
    {'emoji': '⛰️', 'answer': 'MOUNTAIN', 'hint': 'Très haut', 'language': 'Anglais'},
    {'emoji': '🐬', 'answer': 'DOLPHIN', 'hint': 'Mammifère marin', 'language': 'Anglais'},
    {'emoji': '🎸', 'answer': 'GUITAR', 'hint': 'Instrument à cordes', 'language': 'Anglais'},
    {'emoji': '📚', 'answer': 'BOOK', 'hint': 'On y lit', 'language': 'Anglais'},
    {'emoji': '✈️', 'answer': 'PLANE', 'hint': 'Voyage dans le ciel', 'language': 'Anglais'},
    {'emoji': '🐢', 'answer': 'TURTLE', 'hint': 'Lent avec une carapace', 'language': 'Anglais'},
    {'emoji': '🎂', 'answer': 'CAKE', 'hint': 'Dessert sucré', 'language': 'Anglais'},
    {'emoji': '🌈', 'answer': 'RAINBOW', 'hint': 'Après la pluie', 'language': 'Anglais'},
    {'emoji': '🦁', 'answer': 'LION', 'hint': 'Roi des animaux', 'language': 'Anglais'},
    {'emoji': '🎹', 'answer': 'PIANO', 'hint': 'Touches noires et blanches', 'language': 'Anglais'},
    {'emoji': '🍕', 'answer': 'PIZZA', 'hint': 'Plat italien', 'language': 'Anglais'},
    {
      'emoji': '🐘',
      'answer': 'ELEPHANT',
      'hint': 'Plus grand mammifère terrestre',
      'language': 'Anglais'
    },
    {'emoji': '⭐', 'answer': 'STAR', 'hint': 'Brille la nuit', 'language': 'Anglais'},
    {'emoji': '🌻', 'answer': 'SUNFLOWER', 'hint': 'Fleur jaune géante', 'language': 'Anglais'},
    {'emoji': '🔔', 'answer': 'BELL', 'hint': 'Fait du bruit', 'language': 'Anglais'},
    {'emoji': '🐝', 'answer': 'BEE', 'hint': 'Fait du miel', 'language': 'Anglais'},
    {'emoji': '🍋', 'answer': 'LEMON', 'hint': 'Fruit acide jaune', 'language': 'Anglais'},
    {'emoji': '🐍', 'answer': 'SNAKE', 'hint': 'Reptile sans pattes', 'language': 'Anglais'},
    {'emoji': '🎵', 'answer': 'MUSIC', 'hint': 'Art des sons', 'language': 'Anglais'},
    {'emoji': '🌍', 'answer': 'EARTH', 'hint': 'Notre planète', 'language': 'Anglais'},
    {'emoji': '🍌', 'answer': 'BANANA', 'hint': 'Fruit jaune courbé', 'language': 'Anglais'},
    {'emoji': '🦋', 'answer': 'BUTTERFLY', 'hint': 'Insecte coloré volant', 'language': 'Anglais'},
    {'emoji': '🐸', 'answer': 'FROG', 'hint': 'Saute et croasse', 'language': 'Anglais'},
    {'emoji': '⚡', 'answer': 'LIGHTNING', 'hint': 'Flash pendant l\'orage', 'language': 'Anglais'},
    {'emoji': '🎯', 'answer': 'TARGET', 'hint': 'Objectif à atteindre', 'language': 'Anglais'},
  ];

  static const List<Map<String, dynamic>> emojiCombo = [
    // TODO(API) : Table dédiée emoji_combos avec relation many-to-one
    {
      'emojis': ['🌧️', '☂️'],
      'answer': 'RAINY',
      'hint': 'Temps pluvieux'
    },
    {
      'emojis': ['🏃', '💨'],
      'answer': 'RUN',
      'hint': 'Courir vite'
    },
    {
      'emojis': ['🌍', '📚'],
      'answer': 'GEOGRAPHY',
      'hint': 'Science de la Terre'
    },
    {
      'emojis': ['🎵', '❤️'],
      'answer': 'LOVE SONG',
      'hint': 'Chanson romantique'
    },
    {
      'emojis': ['🔑', '🚪'],
      'answer': 'UNLOCK',
      'hint': 'Ouvrir une porte'
    },
    {
      'emojis': ['⚡', '💡'],
      'answer': 'POWER',
      'hint': 'Énergie et lumière'
    },
    {
      'emojis': ['🌺', '🌿'],
      'answer': 'GARDEN',
      'hint': 'Espace vert'
    },
    {
      'emojis': ['🏠', '❤️'],
      'answer': 'HOME',
      'hint': 'Là où est le cœur'
    },
    {
      'emojis': ['🌊', '🏄'],
      'answer': 'SURFING',
      'hint': 'Sport nautique'
    },
    {
      'emojis': ['🎓', '📖'],
      'answer': 'STUDY',
      'hint': 'Apprendre'
    },
    {
      'emojis': ['🌙', '⭐'],
      'answer': 'NIGHT',
      'hint': 'Quand il fait noir'
    },
    {
      'emojis': ['🍳', '☕'],
      'answer': 'BREAKFAST',
      'hint': 'Premier repas du jour'
    },
    {
      'emojis': ['🎄', '🎁'],
      'answer': 'CHRISTMAS',
      'hint': 'Fête de décembre'
    },
    {
      'emojis': ['📱', '💬'],
      'answer': 'MESSAGE',
      'hint': 'Communication textuelle'
    },
    {
      'emojis': ['🔬', '🧪'],
      'answer': 'SCIENCE',
      'hint': 'Étude du monde'
    },
    {
      'emojis': ['🎨', '🖌️'],
      'answer': 'PAINTING',
      'hint': 'Art visuel'
    },
    {
      'emojis': ['🐟', '🌊'],
      'answer': 'OCEAN',
      'hint': 'Immensité bleue'
    },
    {
      'emojis': ['✈️', '🌴'],
      'answer': 'VACATION',
      'hint': 'Partir en vacances'
    },
    {
      'emojis': ['🏆', '🥇'],
      'answer': 'CHAMPION',
      'hint': 'Le meilleur !'
    },
    {
      'emojis': ['❄️', '⛷️'],
      'answer': 'SKIING',
      'hint': 'Sport d\'hiver'
    },
    {
      'emojis': ['🎃', '👻'],
      'answer': 'HALLOWEEN',
      'hint': 'Fête effrayante'
    },
    {
      'emojis': ['📐', '📏'],
      'answer': 'GEOMETRY',
      'hint': 'Formes et mesures'
    },
    {
      'emojis': ['🧠', '💡'],
      'answer': 'IDEA',
      'hint': 'Eureka !'
    },
    {
      'emojis': ['🌅', '🏖️'],
      'answer': 'SUNSET',
      'hint': 'Fin de journée au bord de mer'
    },
    {
      'emojis': ['🎭', '🎬'],
      'answer': 'THEATER',
      'hint': 'Arts du spectacle'
    },
    {
      'emojis': ['🍞', '🧀'],
      'answer': 'SANDWICH',
      'hint': 'Repas rapide'
    },
    {
      'emojis': ['🏥', '💊'],
      'answer': 'MEDICINE',
      'hint': 'Soins de santé'
    },
    {
      'emojis': ['🔭', '🌌'],
      'answer': 'ASTRONOMY',
      'hint': 'Étude des étoiles'
    },
    {
      'emojis': ['🎼', '🎻'],
      'answer': 'ORCHESTRA',
      'hint': 'Ensemble musical'
    },
    {
      'emojis': ['🏰', '👑'],
      'answer': 'KINGDOM',
      'hint': 'Terre du roi'
    },
  ];

  // ── BADGES ──────────────────────────────────────────────────
  // TODO(API) : Remplacer par BadgeService.getAllBadges(userId)
  static const List<Map<String, dynamic>> allBadges = [
    // Mini-jeux spécifiques
    {
      'key': 'wordle_first',
      'name': 'Premier Mot',
      'icon': '🔤',
      'color': 0xFF6359FF,
      'rarity': 'common',
      'earned': true,
      'desc': 'Résoudre ton premier Wordle'
    },
    {
      'key': 'wordle_genius',
      'name': 'Génie des Mots',
      'icon': '🧠',
      'color': 0xFF534AB7,
      'rarity': 'epic',
      'earned': false,
      'desc': 'Trouver le mot en 1 seul essai'
    },
    {
      'key': 'hangman_perfect',
      'name': 'Zéro Faute',
      'icon': '✨',
      'color': 0xFF1D9E75,
      'rarity': 'rare',
      'earned': true,
      'desc': 'Gagner le Pendu sans erreur'
    },
    {
      'key': 'synonym_master',
      'name': 'Maître des Mots',
      'icon': '📖',
      'color': 0xFF0F6E56,
      'rarity': 'rare',
      'earned': false,
      'desc': '5 synonymes corrects de suite'
    },
    {
      'key': 'emoji_detective',
      'name': 'Détective Emoji',
      'icon': '🔍',
      'color': 0xFFEA580C,
      'rarity': 'common',
      'earned': true,
      'desc': 'Résoudre 10 énigmes emoji'
    },
    {
      'key': 'emoji_speed',
      'name': 'Speed Emoji',
      'icon': '⚡',
      'color': 0xFFD97706,
      'rarity': 'epic',
      'earned': false,
      'desc': 'Trouver un emoji en moins de 5 secondes'
    },
    // Streak et progression
    {
      'key': 'streak_7',
      'name': 'Semaine de Feu',
      'icon': '🔥',
      'color': 0xFFEA580C,
      'rarity': 'common',
      'earned': true,
      'desc': '7 jours consécutifs'
    },
    {
      'key': 'streak_14',
      'name': 'Deux Semaines',
      'icon': '🔥',
      'color': 0xFFDC2626,
      'rarity': 'rare',
      'earned': true,
      'desc': '14 jours consécutifs'
    },
    {
      'key': 'streak_30',
      'name': 'Un Mois Solide',
      'icon': '💎',
      'color': 0xFF7C3AED,
      'rarity': 'epic',
      'earned': false,
      'desc': '30 jours consécutifs'
    },
    {
      'key': 'xp_1000',
      'name': '1 000 XP',
      'icon': '⭐',
      'color': 0xFFEF9F27,
      'rarity': 'common',
      'earned': true,
      'desc': 'Accumuler 1 000 XP'
    },
    {
      'key': 'xp_5000',
      'name': '5 000 XP',
      'icon': '🌟',
      'color': 0xFFF59E0B,
      'rarity': 'rare',
      'earned': false,
      'desc': 'Accumuler 5 000 XP'
    },
    {
      'key': 'level_5',
      'name': 'Niveau 5',
      'icon': '🚀',
      'color': 0xFF6359FF,
      'rarity': 'common',
      'earned': true,
      'desc': 'Atteindre le niveau 5'
    },
    {
      'key': 'top_1_week',
      'name': 'N°1 du Classement',
      'icon': '👑',
      'color': 0xFFEF9F27,
      'rarity': 'legendary',
      'earned': false,
      'desc': 'Être premier du classement'
    },
    // Badges supplémentaires (enrich)
    {
      'key': 'wordle_10',
      'name': '10 Wordles',
      'icon': '🔥',
      'color': 0xFF6359FF,
      'rarity': 'rare',
      'earned': false,
      'desc': 'Résoudre 10 Wordles'
    },
    {
      'key': 'hangman_10',
      'name': '10 Pendus',
      'icon': '🎯',
      'color': 0xFF1D9E75,
      'rarity': 'rare',
      'earned': false,
      'desc': 'Gagner 10 parties de Pendu'
    },
    {
      'key': 'emoji_30',
      'name': '30 Émojis',
      'icon': '🏅',
      'color': 0xFFEA580C,
      'rarity': 'epic',
      'earned': false,
      'desc': 'Résoudre 30 énigmes emoji'
    },
    {
      'key': 'polyglot',
      'name': 'Polyglotte',
      'icon': '🌍',
      'color': 0xFF7C3AED,
      'rarity': 'legendary',
      'earned': false,
      'desc': 'Jouer dans 3 langues différentes'
    },
    {
      'key': 'night_owl',
      'name': 'Oiseau de Nuit',
      'icon': '🦉',
      'color': 0xFF534AB7,
      'rarity': 'rare',
      'earned': false,
      'desc': 'Étudier après 23h'
    },
    {
      'key': 'early_bird',
      'name': 'Lève-tôt',
      'icon': '🐦',
      'color': 0xFFF59E0B,
      'rarity': 'rare',
      'earned': false,
      'desc': 'Étudier avant 7h du matin'
    },
  ];

  // ── LEADERBOARD ──────────────────────────────────────────────
  // TODO(API) : Remplacer par LeaderboardService.getTopPlayers()
  static const List<Map<String, dynamic>> leaderboard = [
    {
      'name': 'Zineb B.',
      'initials': 'ZB',
      'xp': 4820,
      'streak': 21,
      'gradientStart': 0xFF6359FF,
      'gradientEnd': 0xFFAFA9EC
    },
    {
      'name': 'Hiba E.',
      'initials': 'HE',
      'xp': 4230,
      'streak': 14,
      'gradientStart': 0xFF1D9E75,
      'gradientEnd': 0xFF9FE1CB
    },
    {
      'name': 'Abdelmoughit',
      'initials': 'AM',
      'xp': 3910,
      'streak': 8,
      'gradientStart': 0xFFD85A30,
      'gradientEnd': 0xFFFAC775
    },
    {
      'name': 'Achraf M.',
      'initials': 'AC',
      'xp': 3560,
      'streak': 5,
      'gradientStart': 0xFF185FA5,
      'gradientEnd': 0xFF85B7EB
    },
    {
      'name': 'Yousra O.',
      'initials': 'YO',
      'xp': 2880,
      'streak': 3,
      'gradientStart': 0xFF993556,
      'gradientEnd': 0xFFED93B1
    },
    {
      'name': 'Khalid R.',
      'initials': 'KR',
      'xp': 2640,
      'streak': 7,
      'gradientStart': 0xFF1D9E75,
      'gradientEnd': 0xFF8FD8B5
    },
    {
      'name': 'Fatima Z.',
      'initials': 'FZ',
      'xp': 2410,
      'streak': 4,
      'gradientStart': 0xFF7C3AED,
      'gradientEnd': 0xFFC4B5FD
    },
    {
      'name': 'Omar S.',
      'initials': 'OS',
      'xp': 2180,
      'streak': 2,
      'gradientStart': 0xFFEA580C,
      'gradientEnd': 0xFFFCBB80
    },
    {
      'name': 'Salma B.',
      'initials': 'SB',
      'xp': 1950,
      'streak': 10,
      'gradientStart': 0xFF6359FF,
      'gradientEnd': 0xFFB0ABFF
    },
    {
      'name': 'Amine T.',
      'initials': 'AT',
      'xp': 1720,
      'streak': 1,
      'gradientStart': 0xFFD85A30,
      'gradientEnd': 0xFFFFB380
    },
  ];

  // ── XP PAR JOUR (7 derniers jours) ───────────────────────────
  // TODO(API) : Remplacer par ProgressionService.getXPByDayThisWeek()
  static const List<Map<String, dynamic>> weeklyXP = [
    {'day': 'L', 'xp': 180},
    {'day': 'M', 'xp': 320},
    {'day': 'M', 'xp': 95},
    {'day': 'J', 'xp': 450},
    {'day': 'V', 'xp': 280},
    {'day': 'S', 'xp': 520},
    {'day': 'D', 'xp': 140},
  ];

  // ── JALONS ────────────────────────────────────────────────────
  // TODO(API) : Remplacer par MilestoneService.getActiveMilestones()
  static const List<Map<String, dynamic>> milestones = [
    {
      'type': 'streak_goal',
      'label': 'Streak 21 jours',
      'current': 14,
      'target': 21,
      'reward': 300,
      'icon': '🔥'
    },
    {
      'type': 'xp_goal',
      'label': 'Atteindre 5 000 XP',
      'current': 3400,
      'target': 5000,
      'reward': 200,
      'icon': '⭐'
    },
    {
      'type': 'wordle_goal',
      'label': '10 Wordles gagnés',
      'current': 6,
      'target': 10,
      'reward': 150,
      'icon': '🔤'
    },
    {
      'type': 'hangman_goal',
      'label': '5 Pendus sans erreur',
      'current': 2,
      'target': 5,
      'reward': 100,
      'icon': '✨'
    },
    {
      'type': 'lessons_goal',
      'label': '50 leçons complètes',
      'current': 42,
      'target': 50,
      'reward': 250,
      'icon': '📖'
    },
    {
      'type': 'emoji_goal',
      'label': '20 énigmes emoji résolues',
      'current': 12,
      'target': 20,
      'reward': 180,
      'icon': '🎯'
    },
    {
      'type': 'synonym_goal',
      'label': '50 synonymes corrects',
      'current': 28,
      'target': 50,
      'reward': 200,
      'icon': '📚'
    },
    {
      'type': 'level_goal',
      'label': 'Atteindre le niveau 10',
      'current': 7,
      'target': 10,
      'reward': 500,
      'icon': '🚀'
    },
  ];
}
