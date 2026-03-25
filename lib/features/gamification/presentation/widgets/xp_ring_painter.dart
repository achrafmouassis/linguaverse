import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class XpRingPainter extends CustomPainter {
  final double progress;
  final Color baseColor;
  final double strokeWidth;

  XpRingPainter({
    required this.progress,
    required this.baseColor,
    this.strokeWidth = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    // Foreground arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    const gradient = SweepGradient(
      colors: [AppColors.tertiary, AppColors.secondary, AppColors.tertiary],
      stops: [0.0, 0.5, 1.0],
      startAngle: -3.14159 / 2,
      endAngle: 3.14159 * 1.5,
    );

    final fgPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(rect, -3.14159 / 2, sweepAngle, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant XpRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
