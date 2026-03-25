import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/models/badge_model.dart';

class BadgeAwardOverlay extends StatefulWidget {
  final BadgeModel badge;
  final VoidCallback onDismiss;

  const BadgeAwardOverlay({
    super.key,
    required this.badge,
    required this.onDismiss,
  });

  @override
  State<BadgeAwardOverlay> createState() => _BadgeAwardOverlayState();

  static void show(BuildContext context, BadgeModel badge) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => BadgeAwardOverlay(
        badge: badge,
        onDismiss: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _BadgeAwardOverlayState extends State<BadgeAwardOverlay> with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _badgeScaleCtrl;
  late AnimationController _particleCtrl;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _badgeScaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    _startSequence();
  }

  Future<void> _startSequence() async {
    _fadeCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _badgeScaleCtrl.forward();
    _particleCtrl.forward();

    await Future.delayed(const Duration(seconds: 3));
    if (mounted) _dismiss();
  }

  void _dismiss() {
    _fadeCtrl.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _badgeScaleCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeCtrl,
      child: GestureDetector(
        onTap: _dismiss,
        child: Container(
          color: Colors.black.withValues(alpha: 0.85),
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: const TextStyle(fontFamily: 'Roboto'),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Particles
                AnimatedBuilder(
                  animation: _particleCtrl,
                  builder: (context, child) {
                    final progress = Curves.easeOutCubic.transform(_particleCtrl.value);
                    return Stack(
                      children: List.generate(15, (index) {
                        final angle = (index * 2 * pi) / 15;
                        final distance = 80.0 + progress * 80.0;
                        final x = cos(angle) * distance;
                        final y = sin(angle) * distance;
                        final opacity = 1.0 - progress;

                        return Transform.translate(
                          offset: Offset(x, y),
                          child: Icon(
                            Icons.star_rounded,
                            color: widget.badge.color.withValues(alpha: opacity),
                            size: 16.0 + (index % 3) * 6,
                          ),
                        );
                      }),
                    );
                  },
                ),

                // Content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
                          .animate(
                              CurvedAnimation(parent: _badgeScaleCtrl, curve: Curves.easeOutBack)),
                      child: const Text(
                        'NOUVEAU BADGE !',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.xpGold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(parent: _badgeScaleCtrl, curve: Curves.elasticOut)),
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.badge.color.withValues(alpha: 0.2),
                          border: Border.all(
                              color: widget.badge.color.withValues(alpha: 0.5), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: widget.badge.color.withValues(alpha: 0.4),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.badge.iconEmoji,
                          style: const TextStyle(fontSize: 70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FadeTransition(
                      opacity:
                          CurvedAnimation(parent: _particleCtrl, curve: const Interval(0.5, 1.0)),
                      child: Column(
                        children: [
                          Text(
                            widget.badge.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (widget.badge.xpRewarded != null && widget.badge.xpRewarded! > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.xpGold.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '+${widget.badge.xpRewarded} XP',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.xpGold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
