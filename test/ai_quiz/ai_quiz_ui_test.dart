import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguaverse/features/ai_quiz/repositories/ai_quiz_service.dart';
import 'package:linguaverse/features/ai_quiz/viewmodels/ai_quiz_viewmodel.dart';
import 'package:linguaverse/features/ai_quiz/views/ai_quiz_entry_page.dart';
import 'package:linguaverse/features/ai_quiz/views/ai_quiz_page.dart';
import 'package:linguaverse/features/gamification/data/models/user_progression_model.dart';
import 'package:linguaverse/features/gamification/presentation/providers/gamification_providers.dart';

class MockAIQuizService extends AIQuizService {
  @override
  Future<List<Map<String, dynamic>>> generateQuestions({
    required String language,
    required int userLevel,
    required List<String> recentTopics,
    int questionCount = 5,
  }) async {
    // Artificial delay to let loading state show
    await Future.delayed(const Duration(milliseconds: 50));
    return [
      {
        'question': 'Test AI Question UI',
        'type': 'qcm',
        'correct': 'Correct Answer',
        'choices': ['A', 'Correct Answer', 'C', 'D'],
        'explanation': 'Because test'
      }
    ];
  }
}

class MockUserProgressionNotifier extends StateNotifier<AsyncValue<UserProgressionModel?>> implements UserProgressionNotifier {
  MockUserProgressionNotifier() : super(AsyncValue.data(
    UserProgressionModel(userId: 'test')
  ));

  @override
  Future<void> refresh() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('AI Quiz UI Integration Test: Entry to Quiz to Answer', (WidgetTester tester) async {
    final mockService = MockAIQuizService();

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'aiQuizEntry',
          builder: (context, state) => const AIQuizEntryPage(),
        ),
        GoRoute(
          path: '/quiz',
          name: 'aiQuiz',
          builder: (context, state) => const AIQuizPage(),
        ),
      ],
    );

    // Set higher screen size to avoid off-screen issues
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          aiQuizServiceProvider.overrideWithValue(mockService),
          userProgressionProvider.overrideWith((ref) => MockUserProgressionNotifier()),
        ],
        child: MaterialApp.router(
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
        ),
      ),
    );

    // Initial page should be Entry Page with "Générer mon Quiz IA" button
    final button = find.text('Générer mon Quiz IA');
    expect(button, findsOneWidget);

    // Ensure visible and tap generate button
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    // Wait for the mock API response and navigation
    await tester.pumpAndSettle();

    // Should navigate to AIQuizPage and display question
    expect(find.text('Test AI Question UI'), findsOneWidget);
    expect(find.text('Correct Answer'), findsOneWidget);

    // Answer the question
    await tester.tap(find.text('Correct Answer'));
    await tester.pump();

    // Check if the feedback logic rendered (explanation shown)
    expect(find.text('Because test'), findsOneWidget);

    // Ensure the Next button appeared
    expect(find.text('Voir les résultats'), findsOneWidget);
  });
}
