import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/models/leaderboard_entry_model.dart';
import 'confetti_burst.dart';

class PodiumSection extends StatefulWidget {
  final List<LeaderboardEntry> topThree;
  final String currentUserId;

  const PodiumSection({super.key, required this.topThree, required this.currentUserId});

  @override
  State<PodiumSection> createState() => _PodiumSectionState();
}

class _PodiumSectionState extends State<PodiumSection> with TickerProviderStateMixin {
  late final AnimationController _ctrl1;
  late final AnimationController _ctrl2;
  late final AnimationController _ctrl3;
  late final AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _ctrl2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _ctrl3 = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _ctrl3.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl2.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _ctrl1.forward();
    });
  }

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    _ctrl3.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  Widget _buildPodiumPlace(LeaderboardEntry? entry, int rank, double avatarSize,
      double pedestalHeight, AnimationController ctrl) {
    if (entry == null) return SizedBox(width: avatarSize);

    final isCurrentUser = entry.isCurrentUser(widget.currentUserId);
    final isFirst = rank == 1;

    final colorMap = {
      1: AppColors.xpGold,
      2: AppColors.silver, // Silver
      3: AppColors.bronze, // Bronze
    };
    final color = colorMap[rank] ?? Colors.transparent;
    final emoji = rank == 1
        ? '🥇'
        : rank == 2
            ? '🥈'
            : '🥉';

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
          .animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOutBack)),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: ctrl, curve: Curves.easeIn),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (isFirst)
                  RotationTransition(
                    turns: _glowCtrl,
                    child: Container(
                      width: avatarSize + 8,
                      height: avatarSize + 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            color.withValues(alpha: 0.0),
                            color.withValues(alpha: 0.8),
                            color.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  margin: isFirst ? const EdgeInsets.all(4) : EdgeInsets.zero,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: entry.avatarGradient),
                    border: Border.all(
                      color: isCurrentUser ? AppColors.primary : color,
                      width: isFirst ? 3.0 : 2.0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    entry.userInitials,
                    style: TextStyle(
                      fontSize: avatarSize * 0.4,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color, width: 1),
                      ),
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              entry.userName.split(' ').first,
              style: TextStyle(
                  fontSize: 12, fontWeight: isFirst ? FontWeight.bold : FontWeight.normal),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${entry.xpEarned} XP',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isFirst ? AppColors.xpGold : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: avatarSize + 20,
              height: pedestalHeight,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isFirst ? 0.3 : 0.15),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                border: Border(top: BorderSide(color: color, width: 2)),
              ),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 8),
              child: isFirst && isCurrentUser
                  ? const ConfettiBurst(active: true, child: SizedBox.shrink())
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.topThree.isEmpty) return const SizedBox(height: 200);

    final first = widget.topThree.isNotEmpty ? widget.topThree[0] : null;
    final second = widget.topThree.length > 1 ? widget.topThree[1] : null;
    final third = widget.topThree.length > 2 ? widget.topThree[2] : null;

    return Container(
      height: 220,
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodiumPlace(second, 2, 50, 70, _ctrl2),
          const SizedBox(width: 8),
          _buildPodiumPlace(first, 1, 64, 100, _ctrl1),
          const SizedBox(width: 8),
          _buildPodiumPlace(third, 3, 44, 50, _ctrl3),
        ],
      ),
    );
  }
}
