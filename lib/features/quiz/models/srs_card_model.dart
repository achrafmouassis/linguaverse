// lib/features/quiz/models/srs_card_model.dart

/// Carte SRS (Spaced Repetition System) liée à un mot d'une leçon.
/// Algorithme simplifié (SM-2 like) :
///   interval augmente si réponse correcte, reset si incorrecte.
class SrsCard {
  final String wordTerm; // Clé : term de LessonItem
  final String categoryId;
  final String languageId;

  final int repetitions; // Nombre de succès consécutifs
  final double easeFactor; // Facteur de facilité (1.3 – 2.5)
  final int intervalDays; // Prochain intervalle de révision (jours)
  final DateTime nextReview; // Date de la prochaine révision
  final DateTime lastReview;
  final int totalAttempts;
  final int correctAttempts;

  const SrsCard({
    required this.wordTerm,
    required this.categoryId,
    required this.languageId,
    this.repetitions = 0,
    this.easeFactor = 2.5,
    this.intervalDays = 1,
    required this.nextReview,
    required this.lastReview,
    this.totalAttempts = 0,
    this.correctAttempts = 0,
  });

  /// Calcule le prochain intervalle selon SM-2
  SrsCard update({required bool wasCorrect}) {
    if (!wasCorrect) {
      return SrsCard(
        wordTerm: wordTerm,
        categoryId: categoryId,
        languageId: languageId,
        repetitions: 0,
        easeFactor: (easeFactor - 0.2).clamp(1.3, 2.5),
        intervalDays: 1,
        nextReview: DateTime.now().add(const Duration(days: 1)),
        lastReview: DateTime.now(),
        totalAttempts: totalAttempts + 1,
        correctAttempts: correctAttempts,
      );
    }

    final int newRep = repetitions + 1;
    final double newEF = (easeFactor + (0.1 - (5 - 4) * (0.08 + (5 - 4) * 0.02))).clamp(1.3, 2.5);
    final int newInterval = newRep == 1
        ? 1
        : newRep == 2
            ? 6
            : (intervalDays * newEF).round();

    return SrsCard(
      wordTerm: wordTerm,
      categoryId: categoryId,
      languageId: languageId,
      repetitions: newRep,
      easeFactor: newEF,
      intervalDays: newInterval,
      nextReview: DateTime.now().add(Duration(days: newInterval)),
      lastReview: DateTime.now(),
      totalAttempts: totalAttempts + 1,
      correctAttempts: correctAttempts + 1,
    );
  }

  bool get isDueForReview => DateTime.now().isAfter(nextReview);

  double get accuracy => totalAttempts == 0 ? 0.0 : correctAttempts / totalAttempts;

  Map<String, dynamic> toMap() => {
        'wordTerm': wordTerm,
        'categoryId': categoryId,
        'languageId': languageId,
        'repetitions': repetitions,
        'easeFactor': easeFactor,
        'intervalDays': intervalDays,
        'nextReview': nextReview.millisecondsSinceEpoch,
        'lastReview': lastReview.millisecondsSinceEpoch,
        'totalAttempts': totalAttempts,
        'correctAttempts': correctAttempts,
      };

  factory SrsCard.fromMap(Map<String, dynamic> m) => SrsCard(
        wordTerm: m['wordTerm'] as String,
        categoryId: m['categoryId'] as String,
        languageId: m['languageId'] as String,
        repetitions: m['repetitions'] as int,
        easeFactor: (m['easeFactor'] as num).toDouble(),
        intervalDays: m['intervalDays'] as int,
        nextReview: DateTime.fromMillisecondsSinceEpoch(m['nextReview'] as int),
        lastReview: DateTime.fromMillisecondsSinceEpoch(m['lastReview'] as int),
        totalAttempts: m['totalAttempts'] as int,
        correctAttempts: m['correctAttempts'] as int,
      );

  factory SrsCard.initial({
    required String wordTerm,
    required String categoryId,
    required String languageId,
  }) =>
      SrsCard(
        wordTerm: wordTerm,
        categoryId: categoryId,
        languageId: languageId,
        nextReview: DateTime.now(),
        lastReview: DateTime.now(),
      );
}
