import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/models/leaderboard_entry_model.dart';

class LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final String currentUserId;
  final int topPlayerXP;
  final int previousRank;

  const LeaderboardRow({
    super.key,
    required this.entry,
    required this.currentUserId,
    required this.topPlayerXP,
    this.previousRank = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrent = entry.isCurrentUser(currentUserId);
    final rank = entry.rankPosition ?? 999;

    Color rankColor;
    if (rank == 1) {
      rankColor = AppColors.xpGold;
    } else if (rank == 2) {
      rankColor = AppColors.silver;
    } else if (rank == 3) {
      rankColor = AppColors.bronze;
    } else {
      rankColor = AppColors.textSecondary.withValues(alpha: 0.5);
    }

    double fillPercentage = topPlayerXP > 0 ? (entry.xpEarned / topPlayerXP).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primary.withValues(alpha: 0.1) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: rankColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: entry.avatarGradient),
            ),
            alignment: Alignment.center,
            child: Text(
              entry.userInitials,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCurrent ? 'Vous' : entry.userName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                    color: isCurrent ? AppColors.primary : null,
                  ),
                ),
                const SizedBox(height: 6),
                LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.outline.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: fillPercentage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? AppColors.primary
                              : AppColors.outline.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${entry.xpEarned} XP',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w600,
              color: isCurrent ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
