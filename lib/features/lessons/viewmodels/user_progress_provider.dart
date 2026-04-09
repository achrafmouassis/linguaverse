import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_level.dart';

class UserProgressNotifier extends Notifier<Set<String>> {
  static const _key = 'completed_lessons';

  @override
  Set<String> build() {
    _loadProgress();
    return {};
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getStringList(_key) ?? [];
    state = Set.from(completed);
  }

  Future<void> markLessonAsCompleted(String lessonId) async {
    if (state.contains(lessonId)) return;
    
    final newState = {...state, lessonId};
    state = newState;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, newState.toList());
  }

  Future<void> markLevelAsCompleted(CategoryLevel level) async {
    final lessonIds = level.lessons.map((l) => l.id).toList();
    final newState = {...state, ...lessonIds};
    state = newState;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, newState.toList());
  }

  bool isLessonCompleted(String lessonId) => state.contains(lessonId);
}

final userProgressProvider = NotifierProvider<UserProgressNotifier, Set<String>>(
  () => UserProgressNotifier(),
);
