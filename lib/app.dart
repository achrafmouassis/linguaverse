import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'router.dart';
import 'shared/theme/app_theme.dart';
import 'shared/utils/dev_theme_provider.dart';
import 'features/auth/viewmodels/auth_provider.dart';

class LinguaVerseApp extends ConsumerStatefulWidget {
  const LinguaVerseApp({super.key});

  @override
  ConsumerState<LinguaVerseApp> createState() => _LinguaVerseAppState();
}

class _LinguaVerseAppState extends ConsumerState<LinguaVerseApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // IMPORTANT : On NE PEUT PAS appeler initialize() ici directement car
    // initialize() fait state = state.copyWith(isLoading: true) de manière
    // synchrone, ce qui déclenche une notification Riverpod pendant le montage
    // du widget tree → crash "!_dirty is not true".
    //
    // Solution : différer l'appel APRÈS le premier frame complet.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        _initialized = true;
        ref.read(authNotifierProvider.notifier).initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Écoute les changements d'état d'authentification pour mettre à jour le router.
    // ref.listen() est appelé dans build() (requis par Riverpod) mais les
    // mutations du router sont différées via addPostFrameCallback pour garantir
    // qu'aucun setState ne se produit pendant la phase de construction.
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (previous == null ||
          previous.isAuthenticated != next.isAuthenticated ||
          previous.isOnboardingRequired != next.isOnboardingRequired ||
          previous.isLoading != next.isLoading) {
        authRouterNotifier.updateAuthState(
          isAuthenticated: next.isAuthenticated,
          isOnboardingRequired: next.isOnboardingRequired,
          isLoading: next.isLoading,
        );
      }
    });

    // En debug : le thème est contrôlé par devThemeProvider
    // En release : toujours ThemeMode.system
    final themeMode = kDebugMode ? ref.watch(devThemeProvider) : ThemeMode.system;

    // On utilise l'état auth directement pour décider quoi afficher.
    // Plus de FutureBuilder ni de double MaterialApp — un seul MaterialApp.router
    // qui reste stable pendant toute la vie de l'app.
    final authState = ref.watch(authNotifierProvider);

    // Si l'auth est encore en cours de chargement (ou pas encore initialisé),
    // on affiche le splash par-dessus le router via un Stack.
    return MaterialApp.router(
      title: 'LinguaVerse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode, // ← branché sur le provider
      routerConfig: appRouter,
      builder: (context, child) {
        // Superpose le splash screen si l'initialisation n'est pas terminée.
        // Le router reste monté en dessous, évitant le crash de reconstruction.
        if (authState.isLoading || !_initialized) {
          return const _SplashScreen();
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}

/// Écran de chargement affiché pendant l'initialisation
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo ou icône de l'app
              Icon(
                Icons.language,
                size: 80,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(height: 24),
              // Titre de l'app
              Text(
                'LinguaVerse',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              // Indicateur de chargement
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 16),
              // Texte de chargement
              Text(
                'Initialisation...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withValues(alpha: 0.8),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
