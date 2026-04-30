import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linguaverse/features/quiz/viewmodels/quiz_viewmodel.dart';
import 'package:linguaverse/features/quiz/viewmodels/quiz_state.dart';
import 'package:linguaverse/features/quiz/models/question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Quiz Flow - State changes correctly', () async {
    final container = ProviderContainer();
    final notifier = container.read(quizViewModelProvider.notifier);

    // Initial state
    expect(container.read(quizViewModelProvider).phase, QuizPhase.idle);

    // Start quiz with 2 questions
    await notifier.startQuiz(
      lessonId: 'lesson_1',
      categoryId: 'cat_salutations_fr',
      languageId: 'fr',
      levelIndex: 0,
      lessonIndex: 0,
      isUnitFinal: false,
      questionCount: 2,
    );

    var state = container.read(quizViewModelProvider);
    expect(state.phase, QuizPhase.answering);
    expect(state.totalQuestions, 2);
    expect(state.currentIndex, 0);

    // Get correct answer for question 1 dynamically
    final q1 = state.currentQuestion!;
    final ans1 = _getCorrectAnswer(q1);
    
    // Submit correct answer 1
    notifier.submitAnswer(ans1);
    
    // State immediately becomes feedback
    state = container.read(quizViewModelProvider);
    expect(state.phase, QuizPhase.feedback);
    expect(state.isCurrentCorrect, isTrue);
    expect(state.correctCount, 1);
  });
}

String _getCorrectAnswer(Question q) {
  if (q is MultipleChoiceQuestion) return q.correctAnswer;
  if (q is TrueFalseQuestion) return q.correctAnswer.toString();
  if (q is ListenAndChooseQuestion) return q.correctAnswer;
  if (q is FillInBlankQuestion) return q.correctAnswer;
  return '';
}
