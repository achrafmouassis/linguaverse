import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/constants.dart';
import '../../data/models/badge_model.dart';
import 'package:flutter/services.dart';

class BadgeCard extends StatefulWidget {
  final BadgeModel badge;
  final VoidCallback onTap;

  const BadgeCard({super.key, required this.badge, required this.onTap});

  @override
  State<BadgeCard> createState() => _BadgeCardState();
}

class _BadgeCardState extends State<BadgeCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.badge;
    final isEarned = b.isEarned;

    Widget content = Container(
      width: 90,
      height: 110,
      decoration: BoxDecoration(
        color: isEarned ? b.color.withValues(alpha: 0.18) : Colors.transparent,
        border: Border.all(
          color:
              isEarned ? b.color.withValues(alpha: 0.40) : AppColors.outline.withValues(alpha: 0.2),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        gradient: isEarned
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  b.color.withValues(alpha: 0.25),
                  b.color.withValues(alpha: 0.05),
                ],
              )
            : null,
      ),
      child: Stack(
        children: [
          // Rotating legend glow
          if (isEarned && b.rarity == 'legendary')
            Positioned.fill(
              child: RotationTransition(
                turns: _controller,
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: b.color.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    b.iconEmoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      b.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isEarned ? b.color : AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isEarned)
            Positioned(
              bottom: 6,
              right: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.correctGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );

    if (!isEarned) {
      content = Opacity(
        opacity: 0.35,
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: content,
        ),
      );
    } else {
      content = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, val, child) {
          return Transform.scale(scale: val, child: child);
        },
        child: content,
      );
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      child: content,
    );
  }
}
