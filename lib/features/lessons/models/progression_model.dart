// lib/features/lessons/models/progression_model.dart

enum LevelStatus {
  locked,
  inProgress,
  quizUnlocked,
  completed,
  unitFinalUnlocked,
  unitCompleted,
}

class LevelProgression {
  final String categoryId;
  final String languageId;
  final int levelIndex;
  final LevelStatus status;
  final List<String> completedLessonIds;

  LevelProgression({
    required this.categoryId,
    required this.languageId,
    required this.levelIndex,
    required this.status,
    required this.completedLessonIds,
  });

  LevelProgression copyWith({
    LevelStatus? status,
    List<String>? completedLessonIds,
  }) {
    return LevelProgression(
      categoryId: categoryId,
      languageId: languageId,
      levelIndex: levelIndex,
      status: status ?? this.status,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
    );
  }

  String get id => '${languageId}_${categoryId}_level_$levelIndex';
}
