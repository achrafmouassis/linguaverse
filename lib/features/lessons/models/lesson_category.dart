import 'package:flutter/material.dart';
import 'category_level.dart';

class LessonCategory {
  final String id;
  final String title;
  final IconData icon;
  final String languageId;
  final String learningMethod;
  final List<CategoryLevel> levels;
  final bool isUnlocked;

  const LessonCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.languageId,
    required this.learningMethod,
    this.levels = const [],
    this.isUnlocked = false,
  });

  bool get isCompleted {
    if (levels.isEmpty) return false;
    return levels.every((lvl) => lvl.isCompleted);
  }

  int get completedLevels => levels.where((lvl) => lvl.isCompleted).length;
  double get progress => levels.isEmpty ? 0 : completedLevels / levels.length;
}
