class UserProgressionModel {
  final String userId;
  final int currentLevel;
  final int currentXP;
  final int totalXpEver;
  final int streakDays;
  final int streakBest;
  final String? lastActivityDate;
  final int lessonsCompleted;
  final int quizzesCompleted;
  final int wordsMastered;
  final int perfectScores;
  final int totalStudyMinutes;
  // ── Statistiques duel (colonnes ajoutées en migration v3) ────────
  // SOURCE RÉELLE : user_progression table, colonnes mises à jour par DuelService
  // POUR REMPLACER : Ces champs sont incrémentés par DuelService.finalizeSession()
  final int duelsPlayed;
  final int duelWins;
  final int duelLosses;
  final int duelWinStreak;
  final int duelBestStreak;
  final int duelPerfects;

  UserProgressionModel({
    required this.userId,
    this.currentLevel = 1,
    this.currentXP = 0,
    this.totalXpEver = 0,
    this.streakDays = 0,
    this.streakBest = 0,
    this.lastActivityDate,
    this.lessonsCompleted = 0,
    this.quizzesCompleted = 0,
    this.wordsMastered = 0,
    this.perfectScores = 0,
    this.totalStudyMinutes = 0,
    this.duelsPlayed = 0,
    this.duelWins = 0,
    this.duelLosses = 0,
    this.duelWinStreak = 0,
    this.duelBestStreak = 0,
    this.duelPerfects = 0,
  });

  int get xpForCurrentLevel => _xpForLevel(currentLevel);
  int get xpForNextLevel => _xpForLevel(currentLevel + 1);

  double get xpProgress {
    final currentLevelBaseXP = _cumulativeXpForLevel(currentLevel);
    double progress = (currentXP - currentLevelBaseXP) / xpForCurrentLevel;
    return progress.clamp(0.0, 1.0);
  }

  static int _xpForLevel(int n) => (500 * n * (1 + 0.15 * (n - 1))).round();

  static int _cumulativeXpForLevel(int n) {
    int total = 0;
    for (int i = 1; i < n; i++) {
      total += _xpForLevel(i);
    }
    return total;
  }

  static int levelFromXP(int totalXp) {
    int level = 1;
    int cumulative = 0;
    while (cumulative + _xpForLevel(level) <= totalXp) {
      cumulative += _xpForLevel(level);
      level++;
    }
    return level;
  }

  String get levelTitle {
    if (currentLevel < 3) return 'Novice';
    if (currentLevel < 6) return 'Apprenti';
    if (currentLevel < 10) return 'Étudiant';
    if (currentLevel < 15) return 'Intermédiaire';
    if (currentLevel < 20) return 'Avancé';
    if (currentLevel < 30) return 'Expert';
    return 'Maître';
  }

  bool get isStreakAlive {
    if (lastActivityDate == null) return false;
    final last = DateTime.parse(lastActivityDate!);
    final today = DateTime.now();
    final diff = DateTime(today.year, today.month, today.day)
        .difference(DateTime(last.year, last.month, last.day))
        .inDays;
    return diff <= 1;
  }

  // Taux de victoire en duel (calculé)
  double get duelWinRate {
    if (duelsPlayed == 0) return 0.0;
    return (duelWins / duelsPlayed * 100).clamp(0.0, 100.0);
  }

  factory UserProgressionModel.fromMap(Map<String, dynamic> map) {
    return UserProgressionModel(
      userId: map['user_id'] as String,
      currentLevel: map['current_level'] as int,
      currentXP: map['current_xp'] as int,
      totalXpEver: map['total_xp_ever'] as int,
      streakDays: map['streak_days'] as int,
      streakBest: map['streak_best'] as int,
      lastActivityDate: map['last_activity_date'] as String?,
      lessonsCompleted: map['lessons_completed'] as int,
      quizzesCompleted: map['quizzes_completed'] as int,
      wordsMastered: map['words_mastered'] as int,
      perfectScores: map['perfect_scores'] as int,
      totalStudyMinutes: map['total_study_minutes'] as int,
      duelsPlayed: (map['duels_played'] as int?) ?? 0,
      duelWins: (map['duel_wins'] as int?) ?? 0,
      duelLosses: (map['duel_losses'] as int?) ?? 0,
      duelWinStreak: (map['duel_win_streak'] as int?) ?? 0,
      duelBestStreak: (map['duel_best_streak'] as int?) ?? 0,
      duelPerfects: (map['duel_perfects'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'current_level': currentLevel,
      'current_xp': currentXP,
      'total_xp_ever': totalXpEver,
      'streak_days': streakDays,
      'streak_best': streakBest,
      'last_activity_date': lastActivityDate,
      'lessons_completed': lessonsCompleted,
      'quizzes_completed': quizzesCompleted,
      'words_mastered': wordsMastered,
      'perfect_scores': perfectScores,
      'total_study_minutes': totalStudyMinutes,
      'duels_played': duelsPlayed,
      'duel_wins': duelWins,
      'duel_losses': duelLosses,
      'duel_win_streak': duelWinStreak,
      'duel_best_streak': duelBestStreak,
      'duel_perfects': duelPerfects,
    };
  }

  UserProgressionModel copyWith({
    String? userId,
    int? currentLevel,
    int? currentXP,
    int? totalXpEver,
    int? streakDays,
    int? streakBest,
    String? lastActivityDate,
    int? lessonsCompleted,
    int? quizzesCompleted,
    int? wordsMastered,
    int? perfectScores,
    int? totalStudyMinutes,
    int? duelsPlayed,
    int? duelWins,
    int? duelLosses,
    int? duelWinStreak,
    int? duelBestStreak,
    int? duelPerfects,
  }) {
    return UserProgressionModel(
      userId: userId ?? this.userId,
      currentLevel: currentLevel ?? this.currentLevel,
      currentXP: currentXP ?? this.currentXP,
      totalXpEver: totalXpEver ?? this.totalXpEver,
      streakDays: streakDays ?? this.streakDays,
      streakBest: streakBest ?? this.streakBest,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      wordsMastered: wordsMastered ?? this.wordsMastered,
      perfectScores: perfectScores ?? this.perfectScores,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      duelsPlayed: duelsPlayed ?? this.duelsPlayed,
      duelWins: duelWins ?? this.duelWins,
      duelLosses: duelLosses ?? this.duelLosses,
      duelWinStreak: duelWinStreak ?? this.duelWinStreak,
      duelBestStreak: duelBestStreak ?? this.duelBestStreak,
      duelPerfects: duelPerfects ?? this.duelPerfects,
    );
  }
}
