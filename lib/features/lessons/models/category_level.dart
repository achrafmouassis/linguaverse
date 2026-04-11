import 'lesson.dart';

class CategoryLevel {
  final String id;
  final int levelIndex;
  final String title;
  final List<Lesson> lessons;

  const CategoryLevel({
    required this.id,
    required this.levelIndex,
    required this.title,
    required this.lessons,
  });

  bool get isCompleted {
    if (lessons.isEmpty) return false;
    return lessons.every((l) => l.isCompleted);
  }

  int get completedLessons => lessons.where((l) => l.isCompleted).length;
  double get progress => lessons.isEmpty ? 0 : completedLessons / lessons.length;
}
