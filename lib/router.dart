import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/presentation/pages/home_page.dart';
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
    // Add real paths here as implemented:
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
    GoRoute(
      path: AppRoutes.lessons,
      name: 'lessons',
      builder: (context, state) => const _PlaceholderPage(title: 'Leçons'),
    ),
    GoRoute(
      path: AppRoutes.quiz,
      name: 'quiz',
      builder: (context, state) => const _PlaceholderPage(title: 'Quiz'),
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
