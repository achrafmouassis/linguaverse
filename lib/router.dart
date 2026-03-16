import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/presentation/pages/home_page.dart';

/// All declared route paths for the application.
/// Used by HomePage to check which modules are available.
class AppRoutes {
  static const String home = '/';
  static const String lessons = '/lessons';
  static const String quiz = '/quiz';
  static const String duel = '/duel';
  static const String pronunciation = '/pronunciation';
  static const String ar = '/ar';
  static const String aiQuiz = '/ai-quiz';

  /// Routes that have a real destination page implemented.
  static const List<String> availableRoutes = [
    home,
    // Add routes here as feature pages are implemented:
    // lessons,
    // quiz,
    // duel,
    // pronunciation,
    // ar,
    // aiQuiz,
  ];
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    // ── Placeholder routes (replace Scaffold with real pages when ready) ──
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
    GoRoute(
      path: AppRoutes.duel,
      name: 'duel',
      builder: (context, state) => const _PlaceholderPage(title: 'Duel'),
    ),
    GoRoute(
      path: AppRoutes.pronunciation,
      name: 'pronunciation',
      builder: (context, state) =>
          const _PlaceholderPage(title: 'Prononciation'),
    ),
    GoRoute(
      path: AppRoutes.ar,
      name: 'ar',
      builder: (context, state) => const _PlaceholderPage(title: 'AR Scanner'),
    ),
    GoRoute(
      path: AppRoutes.aiQuiz,
      name: 'ai-quiz',
      builder: (context, state) => const _PlaceholderPage(title: 'IA Quiz'),
    ),
  ],
);

/// Temporary placeholder page for modules not yet implemented.
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
            Text('$title — Bientôt disponible',
                style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
