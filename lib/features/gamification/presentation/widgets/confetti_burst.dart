import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiBurst extends StatefulWidget {
  final Widget child;
  final bool active;

  const ConfettiBurst({super.key, required this.child, this.active = false});

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    if (widget.active) {
      _generateParticles();
      _controller.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(covariant ConfettiBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _generateParticles();
      _controller.forward(from: 0.0);
    }
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        color: _rndColor(),
        angle: -pi / 2 + (_rnd.nextDouble() * pi / 1.5 - pi / 3),
        speed: 100.0 + _rnd.nextDouble() * 200.0,
        size: 4.0 + _rnd.nextDouble() * 6.0,
      ));
    }
  }

  Color _rndColor() {
    final colors = [
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF10B981),
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
    ];
    return colors[_rnd.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (widget.active)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _ConfettiPainter(_particles, _controller.value),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _Particle {
  final Color color;
  final double angle;
  final double speed;
  final double size;

  _Particle({
    required this.color,
    required this.angle,
    required this.speed,
    required this.size,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0.0 || progress == 1.0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final gravity = 400.0 * progress * progress;

    for (var p in particles) {
      final t = progress * 2.0;
      final dx = center.dx + cos(p.angle) * p.speed * t;
      final dy = center.dy + sin(p.angle) * p.speed * t + gravity;

      var paint = Paint()
        ..color = p.color.withValues(alpha: (1.0 - progress).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dx, dy), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
