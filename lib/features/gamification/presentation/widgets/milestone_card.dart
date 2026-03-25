import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/models/milestone_model.dart';
import 'package:flutter/services.dart';

class MilestoneCard extends StatefulWidget {
  final MilestoneModel milestone;

  const MilestoneCard({super.key, required this.milestone});

  @override
  State<MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends State<MilestoneCard> with SingleTickerProviderStateMixin {
  bool _isJustCompleted = false;

  @override
  void didUpdateWidget(covariant MilestoneCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.milestone.isCompleted && !oldWidget.milestone.isCompleted) {
      _triggerCompletion();
    }
  }

  void _triggerCompletion() async {
    setState(() => _isJustCompleted = true);
    HapticFeedback.heavyImpact();

    // In a real app, you might trigger confetti or other effects
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() => _isJustCompleted = false);
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.milestone;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color typeColor = AppColors.primary;
    IconData typeIcon = Icons.stars_rounded;

    if (m.milestoneType.contains('streak')) {
      typeColor = AppColors.streakOrange;
      typeIcon = Icons.local_fire_department_rounded;
    } else if (m.milestoneType.contains('xp')) {
      typeColor = AppColors.xpGold;
      typeIcon = Icons.military_tech_rounded;
    } else if (m.milestoneType.contains('lesson')) {
      typeColor = AppColors.secondary;
      typeIcon = Icons.menu_book_rounded;
    }

    final isCompleted = m.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _isJustCompleted
            ? AppColors.correctGreen.withValues(alpha: 0.15)
            : (isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.02)),
        border: Border.all(
          color: _isJustCompleted
              ? AppColors.correctGreen.withValues(alpha: 0.5)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.05)),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(typeIcon, color: typeColor, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  m.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (!isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.xpGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${m.xpReward} XP',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.xpGold),
                  ),
                ),
              if (isCompleted)
                const Icon(Icons.check_circle_rounded, color: AppColors.correctGreen, size: 24),
            ],
          ),
          if (!isCompleted) ...[
            const SizedBox(height: 16),
            LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutExpo,
                    height: 6,
                    width: constraints.maxWidth * m.progress,
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${m.currentValue} / ${m.targetValue}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  '${(m.progress * 100).toInt()}%',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'Objectif atteint ! +${m.xpReward} XP gagnés.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.correctGreen),
            ),
          ]
        ],
      ),
    );
  }
}
