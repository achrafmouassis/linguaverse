import 'package:flutter/material.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';
import '../../data/models/ar_translation_model.dart';

/// Overlay pleine largeur affiché après la capture d'un texte.
class ArTextOverlay extends StatefulWidget {
  final ArTranslationModel translation;

  const ArTextOverlay({super.key, required this.translation});

  @override
  State<ArTextOverlay> createState() => _ArTextOverlayState();
}

class _ArTextOverlayState extends State<ArTextOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnim = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
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
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnim.value),
          child: Opacity(
            opacity: _ctrl.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge source
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.translation.isFromAPI
                    ? 'Claude AI ${widget.translation.fromCache ? "(cache)" : ""}'
                    : 'Dictionnaire local',
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Texte anglais (toujours en premier)
            Text(
              widget.translation.englishWord,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),

            // Traduction si langue ≠ anglais
            if (widget.translation.showTranslation) ...[
              const SizedBox(height: 6),
              Container(height: 0.5, color: Colors.white.withValues(alpha: 0.15)),
              const SizedBox(height: 6),
              Text(
                widget.translation.targetWord,
                style: const TextStyle(
                  color: AppColors.xpGold,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
