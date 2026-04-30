// lib/features/quiz/views/widgets/feedback_overlay.dart
import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class FeedbackOverlay extends StatefulWidget {
  final bool isCorrect;
  final String? explanation;
  final bool isTimeout;

  const FeedbackOverlay({
    super.key,
    required this.isCorrect,
    this.explanation,
    this.isTimeout = false,
  });

  @override
  State<FeedbackOverlay> createState() => _FeedbackOverlayState();
}

class _FeedbackOverlayState extends State<FeedbackOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isTimeout
        ? AppColors.streakOrange
        : widget.isCorrect
            ? const Color(0xFF065F46)
            : const Color(0xFF991B1B);
    final bg = widget.isTimeout
        ? const Color(0xFFFFF7ED)
        : widget.isCorrect
            ? const Color(0xFFECFDF5)
            : const Color(0xFFFEF2F2);
    final icon = widget.isTimeout
        ? Icons.timer_off_rounded
        : widget.isCorrect
            ? Icons.check_circle_rounded
            : Icons.cancel_rounded;
    final label = widget.isTimeout
        ? 'Temps écoulé !'
        : widget.isCorrect
            ? 'Correct !'
            : 'Incorrect';

    return ScaleTransition(
      scale: _scale,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            if (widget.explanation != null && widget.explanation!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                widget.explanation!,
                style: TextStyle(color: color.withValues(alpha: 0.85), fontSize: 13, height: 1.5),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
