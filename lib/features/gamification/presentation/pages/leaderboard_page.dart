import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_colors.dart';
import '../providers/gamification_providers.dart';
import '../widgets/podium_section.dart';
import '../widgets/leaderboard_row.dart';

class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  String _selectedLanguage = 'Tous';
  final List<String> _languages = ['Tous', 'Arabe', 'Anglais', 'Français', 'Espagnol'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaderboardProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final leaderState = ref.watch(leaderboardProvider);
    final currentUserId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classement'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: () => context.go('/home'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTab('Cette semaine', 0),
                    const SizedBox(width: 8),
                    _buildTab('Ce mois', 1),
                    const SizedBox(width: 8),
                    _buildTab('Global', 2),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    final isSelected = _selectedLanguage == lang;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(lang),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedLanguage = lang);
                            // In real app, trigger provider refresh with language filter
                          }
                        },
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        checkmarkColor: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: leaderState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Erreur: $err')),
        data: (data) {
          final topPlayers = data.topPlayers;
          final topThree = topPlayers.take(3).toList();
          final others = topPlayers.skip(3).toList();

          final int maxXP = topPlayers.isNotEmpty ? topPlayers.first.xpEarned : 0;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: PodiumSection(topThree: topThree, currentUserId: currentUserId),
              ),
              const SliverPadding(padding: EdgeInsets.only(top: 24)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = others[index];
                    return LeaderboardRow(
                      entry: entry,
                      currentUserId: currentUserId,
                      topPlayerXP: maxXP,
                    );
                  },
                  childCount: others.length,
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = _tabIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          setState(() => _tabIndex = index);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Le classement ${text.toLowerCase()} arrive bientôt !')));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
