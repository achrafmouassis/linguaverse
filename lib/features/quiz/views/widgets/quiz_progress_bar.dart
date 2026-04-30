// lib/features/quiz/views/widgets/quiz_progress_bar.dart
import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class QuizProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final double timerProgress; // 1.0 → 0.0

  const QuizProgressBar({
    super.key,
    required this.current,
    required this.total,
    required this.timerProgress,
  });

  Color get _timerColor {
    if (timerProgress > 0.5) return AppColors.correctGreen;
    if (timerProgress > 0.25) return AppColors.streakOrange;
    return AppColors.wrongRed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Question counter + timer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question $current / $total',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              _TimerBadge(progress: timerProgress, color: _timerColor),
            ],
          ),
        ),
        // Progress bar
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: current / total),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          builder: (_, value, __) => LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: AppColors.outline,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        // Timer bar
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: timerProgress),
          duration: const Duration(milliseconds: 300),
          builder: (_, value, __) => LinearProgressIndicator(
            value: value,
            minHeight: 4,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(_timerColor),
          ),
        ),
      ],
    );
  }
}

class _TimerBadge extends StatelessWidget {
  final double progress;
  final Color color;
  const _TimerBadge({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    final secs = (progress * 30).ceil();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '${secs}s',
            style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
