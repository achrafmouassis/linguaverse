import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linguaverse/features/lessons/viewmodels/user_progress_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('UserProgress Flow - Mark lesson as completed', () async {
    final container = ProviderContainer();
    final notifier = container.read(userProgressProvider.notifier);

    // Initial state
    expect(notifier.isLessonCompleted('lesson_1'), isFalse);

    // Mark as completed
    await notifier.markLessonAsCompleted('lesson_1');
    expect(notifier.isLessonCompleted('lesson_1'), isTrue);

    // Still true, verify persistence
    final state = container.read(userProgressProvider);
    expect(state.contains('lesson_done__lesson_1'), isTrue);
  });

  test('UserProgress Flow - Quiz passed unlocks next lesson', () async {
    final container = ProviderContainer();
    final notifier = container.read(userProgressProvider.notifier);

    // Can access level 0, lesson 0 by default
    expect(
      notifier.canAccessLesson(categoryId: 'cat1', levelIndex: 0, lessonIndex: 0),
      isTrue,
    );

    // Cannot access level 0, lesson 1 initially
    expect(
      notifier.canAccessLesson(categoryId: 'cat1', levelIndex: 0, lessonIndex: 1),
      isFalse,
    );

    // Complete quiz for level 0, lesson 0 (cat1_lvl_0_lsn_0)
    await notifier.markLessonQuizPassed('cat1_lvl_0_lsn_0');

    // Now can access lesson 1
    expect(
      notifier.canAccessLesson(categoryId: 'cat1', levelIndex: 0, lessonIndex: 1),
      isTrue,
    );
  });

  test('UserProgress Flow - Unit Quiz Passed', () async {
    final container = ProviderContainer();
    final notifier = container.read(userProgressProvider.notifier);

    expect(
      notifier.isUnitQuizPassed(languageId: 'fr', categoryId: 'cat1'),
      isFalse,
    );

    await notifier.markUnitQuizPassed(languageId: 'fr', categoryId: 'cat1');

    expect(
      notifier.isUnitQuizPassed(languageId: 'fr', categoryId: 'cat1'),
      isTrue,
    );
  });
}
