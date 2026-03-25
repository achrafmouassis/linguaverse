import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class XPGainOverlay extends StatefulWidget {
  final int xpAmount;
  final Offset position;

  const XPGainOverlay({
    super.key,
    required this.xpAmount,
    this.position = const Offset(0, 0),
  });

  static void show(BuildContext context, int xp) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    // Default position at bottom center
    final size = MediaQuery.of(context).size;
    final position = Offset(size.width / 2 - 50, size.height - 150);

    entry = OverlayEntry(
      builder: (_) => XPGainOverlay(
        xpAmount: xp,
        position: position,
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 1500), entry.remove);
  }

  @override
  State<XPGainOverlay> createState() => _XPGainOverlayState();
}

class _XPGainOverlayState extends State<XPGainOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fade = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_controller);

    _slide = Tween<double>(begin: 0.0, end: -80.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slide.value),
            child: Opacity(
              opacity: _fade.value,
              child: child,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.xpGold.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '+${widget.xpAmount} XP',
                style: const TextStyle(
                  color: AppColors.xpGold,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
              const SizedBox(width: 8),
              const Text('⭐', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
