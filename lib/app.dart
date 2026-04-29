import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'router.dart';
import 'shared/theme/app_theme.dart';
import 'shared/utils/dev_theme_provider.dart';

class LinguaVerseApp extends ConsumerWidget {
  const LinguaVerseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // En debug : le thème est contrôlé par devThemeProvider
    // En release : toujours ThemeMode.system
    final themeMode = kDebugMode
        ? ref.watch(devThemeProvider)
        : ThemeMode.system;

    return MaterialApp.router(
      title: 'LinguaVerse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,               // ← branché sur le provider
      routerConfig: appRouter,
    );
  }
}
