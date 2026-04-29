// lib/features/lessons/models/lesson_course.dart

class VocabItem {
  final String word;
  final String pronunciation;
  final String definition;
  final String example;
  final String? imageUrl;

  const VocabItem({
    required this.word,
    required this.pronunciation,
    required this.definition,
    required this.example,
    this.imageUrl,
  });
}

class LessonCourse {
  final String id;
  final String title;
  final String language;
  final String category;
  final int levelIndex;
  final int courseIndex;

  // Sections
  final String introduction;
  final List<String> objectives;
  final List<VocabItem> vocabulary;
  final String phoneticsExplanation;
  final List<String> usageExamples;
  final List<String> summaryPoints;

  // Méta-informations
  final String learningMethod;
  final String estimatedDuration;
  final String prerequisites;

  const LessonCourse({
    required this.id,
    required this.title,
    required this.language,
    required this.category,
    required this.levelIndex,
    required this.courseIndex,
    required this.introduction,
    required this.objectives,
    required this.vocabulary,
    required this.phoneticsExplanation,
    required this.usageExamples,
    required this.summaryPoints,
    required this.learningMethod,
    required this.estimatedDuration,
    required this.prerequisites,
  });
}
