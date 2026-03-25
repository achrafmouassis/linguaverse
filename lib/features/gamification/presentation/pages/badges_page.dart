// ignore_for_file: unused_local_variable, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_colors.dart';
import '../providers/gamification_providers.dart';
import '../widgets/badge_card.dart';
import '../../data/models/badge_model.dart';

class BadgesPage extends ConsumerStatefulWidget {
  const BadgesPage({super.key});

  @override
  ConsumerState<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends ConsumerState<BadgesPage> {
  String _selectedCategory = 'Tous';
  final List<String> _categories = [
    'Tous',
    'streak',
    'xp',
    'learning',
    'quiz',
    'level',
    'special',
    'voice',
    'ar'
  ];

  @override
  Widget build(BuildContext context) {
    final badgesState = ref.watch(badgesProvider);
    final progState = ref.watch(userProgressionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes badges'),
        centerTitle: true,
      ),
      body: badgesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Erreur: $err')),
        data: (allBadges) {
          final earned = allBadges.where((b) => b.isEarned).toList();
          final locked = allBadges.where((b) => !b.isEarned).toList();

          final isDark = Theme.of(context).brightness == Brightness.dark;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, idx) {
                        final cat = _categories[idx];
                        final isSelected = _selectedCategory == cat;
                        String label = cat;
                        if (cat == 'Tous') {
                          label = 'Tous';
                        } else if (cat == 'streak')
                          label = 'Streak';
                        else if (cat == 'learning') label = 'Apprentissage';

                        return ActionChip(
                          label: Text(label),
                          backgroundColor: isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.black.withValues(alpha: 0.05)),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onPressed: () => setState(() => _selectedCategory = cat),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(top: 16)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Débloqués (${earned.length})',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text('${earned.length} / ${allBadges.length}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 90 / 110,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final filtered = _selectedCategory == 'Tous'
                          ? earned
                          : earned.where((e) => e.category == _selectedCategory).toList();
                      if (index >= filtered.length) return null;
                      return BadgeCard(
                        badge: filtered[index],
                        onTap: () => _showBadgeDetails(context, filtered[index]),
                      );
                    },
                    childCount: _selectedCategory == 'Tous'
                        ? earned.length
                        : earned.where((e) => e.category == _selectedCategory).length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16).copyWith(top: 8),
                  child: Text('Verrouillés (${locked.length})',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16).copyWith(top: 0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 90 / 110,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final filtered = _selectedCategory == 'Tous'
                          ? locked
                          : locked.where((e) => e.category == _selectedCategory).toList();
                      if (index >= filtered.length) return null;
                      return BadgeCard(
                        badge: filtered[index],
                        onTap: () => _showBadgeDetails(context, filtered[index]),
                      );
                    },
                    childCount: _selectedCategory == 'Tous'
                        ? locked.length
                        : locked.where((e) => e.category == _selectedCategory).length,
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          );
        },
      ),
    );
  }

  void _showBadgeDetails(BuildContext context, BadgeModel badge) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.outline, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 32),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badge.color.withValues(alpha: 0.1),
                  border: Border.all(color: badge.color.withValues(alpha: 0.5), width: 2),
                ),
                alignment: Alignment.center,
                child: Text(badge.iconEmoji, style: const TextStyle(fontSize: 50)),
              ),
              const SizedBox(height: 24),
              Text(badge.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: badge.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: Text('${badge.category.toUpperCase()} · ${badge.rarityLabel.toUpperCase()}',
                    style:
                        TextStyle(color: badge.color, fontSize: 12, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 24),
              Text(badge.description,
                  style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              if (badge.isEarned)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.correctGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.correctGreen.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.correctGreen),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Débloqué le ${badge.earnedAt!.day}/${badge.earnedAt!.month}/${badge.earnedAt!.year}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, color: AppColors.correctGreen)),
                            if (badge.xpRewarded != null && badge.xpRewarded! > 0)
                              Text('+${badge.xpRewarded} XP obtenus',
                                  style: TextStyle(
                                      color: AppColors.correctGreen.withValues(alpha: 0.8))),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_rounded, color: AppColors.textSecondary),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text("Continuez votre progression pour débloquer ce badge.",
                            style: TextStyle(color: AppColors.textSecondary)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
