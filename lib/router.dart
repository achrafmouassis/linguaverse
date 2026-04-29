import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/presentation/pages/home_page.dart';
<<<<<<< HEAD
import 'features/gamification/presentation/pages/progression_dashboard_page.dart';
import 'features/gamification/presentation/pages/badges_page.dart';
import 'features/gamification/presentation/pages/leaderboard_page.dart';
import 'features/gamification/presentation/pages/milestones_page.dart';
import 'features/gamification/presentation/pages/m7_test_panel_page.dart';
import 'features/gamification/presentation/pages/mini_games_hub_page.dart';
import 'features/gamification/presentation/mini_games/wordle_game_page.dart';
import 'features/gamification/presentation/mini_games/hangman_game_page.dart';
import 'features/gamification/presentation/mini_games/synonym_game_page.dart';
import 'features/gamification/presentation/mini_games/emoji_game_page.dart';
import 'features/duel/duel_exports.dart';
import 'features/ar/presentation/pages/ar_scanner_page.dart';
import 'package:flutter/foundation.dart';
=======
import 'features/quiz/views/quiz_entry_page.dart';
import 'features/quiz/views/quiz_page.dart';
import 'features/quiz/views/quiz_result_page.dart';
import 'features/lessons/views/language_catalog_page.dart';
import 'features/lessons/views/lesson_categories_page.dart';
import 'features/lessons/views/category_levels_page.dart';
import 'features/lessons/views/lesson_content_page.dart';
import 'features/quiz/models/quiz_result_model.dart';
>>>>>>> integration/quiz-lessons

class AppRoutes {
  static const String home = '/';
  static const String lessons = '/lessons';
  static const String quiz = '/quiz';
  static const String duel = '/duel';
  static const String pronunciation = '/pronunciation';
  static const String ar = '/ar';
  static const String aiQuiz = '/ai-quiz';

  static const List<String> availableRoutes = [
    home,
    lessons,
    quiz,
  ];
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const HomePage(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    ),
<<<<<<< HEAD
    GoRoute(
      path: '/gamification',
      name: 'gamification',
      pageBuilder: (context, state) => const CustomTransitionPage(
        child: ProgressionDashboardPage(),
        transitionsBuilder: _fadeSlideTransition,
        transitionDuration: Duration(milliseconds: 350),
      ),
    ),
    GoRoute(
      path: '/gamification/badges',
      name: 'badges',
      pageBuilder: (context, state) => const CustomTransitionPage(
        child: BadgesPage(),
        transitionsBuilder: _fadeSlideTransition,
        transitionDuration: Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/gamification/leaderboard',
      name: 'leaderboard',
      pageBuilder: (context, state) => const CustomTransitionPage(
        child: LeaderboardPage(),
        transitionsBuilder: _fadeSlideTransition,
        transitionDuration: Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/gamification/milestones',
      name: 'milestones',
      pageBuilder: (context, state) => const CustomTransitionPage(
        child: MilestonesPage(),
        transitionsBuilder: _fadeSlideTransition,
        transitionDuration: Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/gamification/games',
      name: 'miniGamesHub',
      pageBuilder: (context, state) => const CustomTransitionPage(
        child: MiniGamesHubPage(),
        transitionsBuilder: _fadeSlideTransition,
        transitionDuration: Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: '/gamification/games/wordle',
      name: 'wordleGame',
      builder: (context, state) => const WordleGamePage(),
    ),
    GoRoute(
      path: '/gamification/games/hangman',
      name: 'hangmanGame',
      builder: (context, state) => const HangmanGamePage(),
    ),
    GoRoute(
      path: '/gamification/games/synonym',
      name: 'synonymGame',
      builder: (context, state) => const SynonymGamePage(),
    ),
    GoRoute(
      path: '/gamification/games/emoji',
      name: 'emojiGame',
      builder: (context, state) => const EmojiGamePage(),
    ),
    // Placeholder routes
=======
>>>>>>> integration/quiz-lessons
    GoRoute(
      path: AppRoutes.lessons,
      name: 'lessons',
      builder: (context, state) => const LanguageCatalogPage(),
      routes: [
        GoRoute(
          path: ':languageId',
          name: 'lesson_categories',
          builder: (context, state) {
            final languageId = state.pathParameters['languageId']!;
            return LessonCategoriesPage(languageId: languageId);
          },
          routes: [
            GoRoute(
              path: ':categoryId',
              name: 'category_levels',
              builder: (context, state) {
                final languageId = state.pathParameters['languageId']!;
                final categoryId = state.pathParameters['categoryId']!;
                return CategoryLevelsPage(
                  languageId: languageId,
                  categoryId: categoryId,
                );
              },
              routes: [
                GoRoute(
                  path: 'content/:levelIndex/:lessonIndex',
                  name: 'lesson_content',
                  builder: (context, state) {
                    final languageId = state.pathParameters['languageId']!;
                    final categoryId = state.pathParameters['categoryId']!;
                    final levelIndex = int.parse(state.pathParameters['levelIndex']!);
                    final lessonIndex = int.parse(state.pathParameters['lessonIndex']!);
                    return LessonContentPage(
                      languageId: languageId,
                      categoryId: categoryId,
                      levelIndex: levelIndex,
                      lessonIndex: lessonIndex,
                      color: Colors.blue, // Fallback color
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.quiz,
      name: 'quiz',
      builder: (context, state) {
        final qp = state.uri.queryParameters;
        final languageId  = qp['languageId'];
        final categoryId  = qp['categoryId'];
        final lessonId    = qp['lessonId'];
        final levelIndex  = qp['levelIndex'] != null ? int.tryParse(qp['levelIndex']!) : null;
        final lessonIndex = qp['lessonIndex'] != null ? int.tryParse(qp['lessonIndex']!) : null;
        final isUnitFinal = qp['isUnitFinal'] == 'true';

        return QuizEntryPage(
          languageId:  languageId,
          categoryId:  categoryId,
          lessonId:    lessonId,
          levelIndex:  levelIndex,
          lessonIndex: lessonIndex,
          isUnitFinal: isUnitFinal,
        );
      },
      routes: [
        GoRoute(
          path: 'start',
          name: 'quiz_page',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return QuizPage(
              lessonId:    extra['lessonId']    ?? 'quiz_fallback',
              lessonTitle: extra['lessonTitle'] ?? 'Quiz',
              languageId:  extra['languageId'],
              categoryId:  extra['categoryId'],
              levelIndex:  extra['levelIndex'],
              lessonIndex: extra['lessonIndex'],
              isUnitFinal: extra['isUnitFinal'] ?? false,
            );
          },
        ),
        GoRoute(
          path: 'result',
          name: 'quiz_result',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final languageId = extra['languageId'] as String?;
            final categoryId = extra['categoryId'] as String?;

            return QuizResultPage(
              result: extra['result'] as QuizResult,
              gamificationResult: extra['gamificationResult'],
              lessonTitle: extra['lessonTitle'] ?? 'Quiz',
              onRetry: extra['onRetry'] ?? () {},
              onContinue: () {
                if (languageId != null && categoryId != null) {
                  context.goNamed('category_levels', pathParameters: {
                    'languageId': languageId,
                    'categoryId': categoryId,
                  });
                } else {
                  context.goNamed('home');
                }
              },
            );
          },
        ),
      ],
    ),
    // ── Module M6 (Duel) ──────────────────────────────────────────
    GoRoute(
      path: AppRoutes.duel,
      name: 'duelLobby',
      pageBuilder: (context, state) => const CustomTransitionPage(
        child: DuelLobbyPage(),
        transitionsBuilder: _fadeSlideTransition,
        transitionDuration: Duration(milliseconds: 300),
      ),
      routes: [
        GoRoute(
          path: 'arena',
          name: 'duelArena',
          pageBuilder: (context, state) => const CustomTransitionPage(
            child: DuelArenaPage(),
            transitionsBuilder: _fadeSlideTransition,
            transitionDuration: Duration(milliseconds: 300),
          ),
        ),
        GoRoute(
          path: 'result',
          name: 'duelResult',
          pageBuilder: (context, state) => const CustomTransitionPage(
            child: DuelResultPage(),
            transitionsBuilder: _fadeSlideTransition,
            transitionDuration: Duration(milliseconds: 300),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.pronunciation,
      name: 'pronunciation',
      builder: (context, state) => const _PlaceholderPage(title: 'Prononciation'),
    ),
    GoRoute(
      path: AppRoutes.ar,
      name: 'arScanner',
      pageBuilder: (context, state) => const MaterialPage(
        fullscreenDialog: true,
        child: ArScannerPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.aiQuiz,
      name: 'ai-quiz',
      builder: (context, state) => const _PlaceholderPage(title: 'IA Quiz'),
    ),
    if (kDebugMode)
      GoRoute(
        path: '/dev/m7-test',
        name: 'devM7Test',
        pageBuilder: (context, state) => const CustomTransitionPage(
          child: M7TestPanelPage(),
          transitionsBuilder: _fadeSlideTransition,
          transitionDuration: Duration(milliseconds: 250),
        ),
      ),
  ],
);

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction_rounded,
                size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('$title — Bientôt disponible', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

Widget _fadeSlideTransition(
    BuildContext context, Animation<double> animation, Animation<double> secondary, Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
    child: SlideTransition(
      position: Tween(begin: const Offset(0, 0.03), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: child,
    ),
  );
}
