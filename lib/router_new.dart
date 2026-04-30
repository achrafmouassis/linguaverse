import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/views/login_screen.dart';
import 'features/auth/views/signup_screen.dart';
import 'features/auth/views/onboarding_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String lessons = '/lessons';
  static const String quiz = '/quiz';
  static const String duel = '/duel';
  static const String pronunciation = '/pronunciation';
  static const String ar = '/ar';
  static const String aiQuiz = '/ai-quiz';

  static const List<String> authRoutes = [login, signup, onboarding];
  static const List<String> availableRoutes = [
    home,
    lessons,
    quiz,
    duel,
    pronunciation,
    ar,
    aiQuiz,
  ];
}

/// Notifier pour déclencher la redirection du router
class _AuthRouterNotifier extends ChangeNotifier {
  bool? _isAuthenticated;
  bool? _isOnboardingRequired;
  bool? _isLoading;

  void updateAuthState({
    required bool isAuthenticated,
    required bool isOnboardingRequired,
    required bool isLoading,
  }) {
    if (_isAuthenticated != isAuthenticated ||
        _isOnboardingRequired != isOnboardingRequired ||
        _isLoading != isLoading) {
      _isAuthenticated = isAuthenticated;
      _isOnboardingRequired = isOnboardingRequired;
      _isLoading = isLoading;
      notifyListeners();
    }
  }

  bool get isAuthenticated => _isAuthenticated ?? false;
  bool get isOnboardingRequired => _isOnboardingRequired ?? false;
  bool get isLoading => _isLoading ?? false;
}

final _authRouterNotifier = _AuthRouterNotifier();

/// GoRouter statique que l'on réutilise
final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  refreshListenable: _authRouterNotifier,
  redirect: (context, state) {
    final isAuthenticated = _authRouterNotifier.isAuthenticated;
    final isLoading = _authRouterNotifier.isLoading;
    final isOnboardingRequired = _authRouterNotifier.isOnboardingRequired;
    final currentLocation = state.matchedLocation;

    // Si l'authentification est en cours de chargement, ne pas rediriger
    if (isLoading) {
      return null;
    }

    // Si l'utilisateur est authentifié
    if (isAuthenticated) {
      // Si l'utilisateur est sur une page d'auth, le rediriger vers home ou onboarding
      if (AppRoutes.authRoutes.contains(currentLocation)) {
        return isOnboardingRequired ? AppRoutes.onboarding : AppRoutes.home;
      }
      // Sinon, laisser passer
      return null;
    }

    // Si l'utilisateur n'est pas authentifié
    else {
      // Si l'utilisateur essaie d'accéder à une page protégée, le rediriger vers login
      if (AppRoutes.availableRoutes.contains(currentLocation)) {
        return AppRoutes.login;
      }
      // Sinon, laisser passer (pages d'auth)
      return null;
    }
  },
  routes: [
    // ============== Auth Routes ==============
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const SignupScreen(),
        transitionsBuilder: (context, animation, _, child) => SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1, 0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const OnboardingScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),

    // ============== Main Routes ==============
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
