import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

/// Un AppBar personnalisé pour LinguaVerse qui inclut systématiquement
/// un bouton "Home" pour revenir au tableau de bord.
class LinguaVerseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const LinguaVerseAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title ?? (titleText != null ? Text(titleText!) : null),
      leading: leading,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? Colors.transparent,
      scrolledUnderElevation: 0,
      bottom: bottom,
      actions: [
        if (actions != null) ...actions!,
        // Bouton Home systématique
        IconButton(
          icon: const Icon(Icons.home_rounded),
          tooltip: 'Retour à l\'accueil',
          onPressed: () {
            // Retour au home propre via GoRouter
            context.go('/home');
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
