import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linguaverse/features/ai_quiz/viewmodels/ai_quiz_viewmodel.dart';
import 'package:linguaverse/features/ai_quiz/repositories/ai_quiz_service.dart';

// Mock service qui retourne des questions fixes
class MockAIQuizService extends AIQuizService {
  @override
  Future<List<Map<String, dynamic>>> generateQuestions({
    required String language,
    required int userLevel,
    required List<String> recentTopics,
    int questionCount = 5,
  }) async {
    return [
      {
        'question': 'Test Q1',
        'type': 'qcm',
        'correct': 'A',
        'choices': ['A', 'B', 'C', 'D'],
        'explanation': 'Exp 1'
      },
      {
        'question': 'Test Q2',
        'type': 'qcm',
        'correct': 'B',
        'choices': ['A', 'B', 'C', 'D'],
        'explanation': 'Exp 2'
      }
    ];
  }
}

void main() {
  test('AI Quiz Flow Test - Default initialization', () {
    final container = ProviderContainer();
    final state = container.read(aiQuizProvider);
    expect(state.questions, isEmpty);
    expect(state.isLoading, isFalse);
    expect(state.score, 0);
  });

  test('AI Quiz Flow Test - Loading and Answer Flow', () async {
    final container = ProviderContainer(
      overrides: [
        aiQuizServiceProvider.overrideWithValue(MockAIQuizService()),
      ],
    );

    final notifier = container.read(aiQuizProvider.notifier);
    
    // Load quiz
    await notifier.loadQuiz(language: 'Arabe', userLevel: 1);
    var state = container.read(aiQuizProvider);
    
    expect(state.questions.length, 2);
    expect(state.currentIndex, 0);

    // Answer correct
    notifier.answerQuestion('A');
    state = container.read(aiQuizProvider);
    expect(state.isAnswered, isTrue);
    expect(state.score, 1); // 1 correct

    // Next question
    await notifier.nextQuestion();
    state = container.read(aiQuizProvider);
    expect(state.currentIndex, 1);
    expect(state.isAnswered, isFalse);

    // Answer incorrect
    notifier.answerQuestion('A'); // Correct is B
    state = container.read(aiQuizProvider);
    expect(state.score, 1); // Score stays 1

    // Finish
    await notifier.nextQuestion();
    state = container.read(aiQuizProvider);
    expect(state.isCompleted, isTrue);
    
    // Percentage 1/2 = 50%
    expect(state.percentage, 0.5);
    expect(state.isPassed, isFalse);
    expect(state.grade, 'F');
  });
}
