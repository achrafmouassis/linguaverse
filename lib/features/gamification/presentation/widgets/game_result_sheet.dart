import 'package:flutter/material.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';

class GameResultSheet extends StatelessWidget {
  final bool won;
  final int xpEarned;
  final String gameName;
  final Map<String, String> stats;
  final VoidCallback onReplay;
  final VoidCallback onHub;

  const GameResultSheet({
    super.key,
    required this.won,
    required this.xpEarned,
    required this.gameName,
    required this.stats,
    required this.onReplay,
    required this.onHub,
  });

  static void show(
    BuildContext context, {
    required bool won,
    required int xpEarned,
    required String gameName,
    required Map<String, String> stats,
    required VoidCallback onReplay,
    required VoidCallback onHub,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => GameResultSheet(
        won: won,
        xpEarned: xpEarned,
        gameName: gameName,
        stats: stats,
        onReplay: onReplay,
        onHub: onHub,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgLevel1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            won ? '🎉 VICTOIRE !' : '😞 Perdu...',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: won ? AppColors.correctGreen : AppColors.wrongRed,
            ),
          ),
          const SizedBox(height: 16),

          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, val, child) {
              return Transform.scale(
                scale: val,
                child: child,
              );
            },
            child: Icon(
              won ? Icons.emoji_events_rounded : Icons.sentiment_very_dissatisfied_rounded,
              size: 80,
              color: won ? AppColors.xpGold : Colors.white38,
            ),
          ),
          const SizedBox(height: 24),

          if (xpEarned > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.xpGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.xpGold.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '+$xpEarned XP gagné',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.xpGold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('⭐', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Statistiques
          if (stats.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: stats.entries.map((e) => _StatItem(e.key, e.value)).toList(),
            ),

          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onHub();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Retour au Hub'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onReplay();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Rejouer'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}
