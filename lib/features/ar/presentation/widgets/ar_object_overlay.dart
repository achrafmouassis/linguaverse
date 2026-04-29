import 'package:flutter/material.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';
import '../../data/models/ar_translation_model.dart';

/// Étiquette flottante au-dessus d'un objet détecté.
///
/// Règle d'affichage :
///   Ligne 1 (grande, blanche) : mot en ANGLAIS toujours
///   Ligne 2 (petite, colorée) : traduction dans la langue cible
class ArObjectOverlay extends StatefulWidget {
  final ArTranslationModel translation;

  const ArObjectOverlay({super.key, required this.translation});

  @override
  State<ArObjectOverlay> createState() => _ArObjectOverlayState();
}

class _ArObjectOverlayState extends State<ArObjectOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 160, minWidth: 80),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 0.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── LIGNE 1 : Mot anglais (TOUJOURS, grand, blanc) ──
              Text(
                widget.translation.englishWord,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),

              // ── LIGNE 2 : Traduction langue cible ──
              if (widget.translation.showTranslation) ...[
                const SizedBox(height: 2),
                Text(
                  widget.translation.translationLine,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _languageColor(widget.translation.targetLanguage),
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _languageColor(String language) {
    return switch (language) {
      'Arabe' => AppColors.xpGold,
      'Japonais' => AppColors.correctGreen,
      'Espagnol' => AppColors.streakOrange,
      'Français' => AppColors.secondary,
      'Allemand' => AppColors.tertiary,
      _ => Colors.white70,
    };
  }
}

/// Indicateur de chargement pendant la traduction
class ArObjectOverlayLoading extends StatelessWidget {
  const ArObjectOverlayLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white70,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Traduction en cours...',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
