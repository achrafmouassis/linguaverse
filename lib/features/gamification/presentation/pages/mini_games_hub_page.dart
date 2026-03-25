// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';

class MiniGamesHubPage extends ConsumerStatefulWidget {
  const MiniGamesHubPage({super.key});

  @override
  ConsumerState<MiniGamesHubPage> createState() => _MiniGamesHubPageState();
}

class _MiniGamesHubPageState extends ConsumerState<MiniGamesHubPage> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _cardsController;

  // TODO(API) : Remplacer par les stats réelles depuis la base de données
  final Map<String, dynamic> _gameStats = {
    'totalGames': 47,
    'totalWins': 34,
    'totalXPGames': 1840,
    'bestStreak': 8,
  };

  // TODO(API) : Remplacer par les records réels par jeu
  final Map<String, dynamic> _gameRecords = {
    'wordle': {'bestTries': 2, 'wins': 18, 'winRate': 85},
    'hangman': {'noMistakes': 5, 'wins': 11, 'bestScore': 120},
    'synonym': {'bestStreak': 8, 'correct': 67, 'accuracy': 91},
    'emoji': {'simple': 31, 'combo': 12, 'speed': 4.2},
  };

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _DailyChallengeGameCard(animController: _entryController),
                const SizedBox(height: 20),
                _buildGameGrid(),
                const SizedBox(height: 24),
                _buildGameStats(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.bgLevel1,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: const Text(
          'Mini-Jeux',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.4),
                    AppColors.bgLevel1,
                  ],
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Text('Arabe ', style: TextStyle(color: Colors.white, fontSize: 12)),
                    Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameGrid() {
    // TODO(API) : Remplacer les stats par des données réelles du service
    final games = [
      _GameCardData(
        id: 'wordle',
        title: 'Wordle',
        subtitle: 'Trouve le mot caché',
        icon: '🔤',
        color: AppColors.primary,
        stat: 'Meilleur: ${_gameRecords["wordle"]["bestTries"]} essais',
        route: '/gamification/games/wordle',
      ),
      _GameCardData(
        id: 'hangman',
        title: 'Pendu',
        subtitle: 'Devine lettre par lettre',
        icon: '🎭',
        color: AppColors.secondary,
        stat: '${_gameRecords["hangman"]["noMistakes"]} victoires parfaites',
        route: '/gamification/games/hangman',
      ),
      _GameCardData(
        id: 'synonym',
        title: 'Synonymes',
        subtitle: 'Similaire ou opposé ?',
        icon: '📖',
        color: AppColors.tertiary,
        stat: 'Série: ${_gameRecords["synonym"]["bestStreak"]}',
        route: '/gamification/games/synonym',
      ),
      _GameCardData(
        id: 'emoji',
        title: 'Émojis',
        subtitle: 'Décode les emojis',
        icon: '🌍',
        color: AppColors.xpGold,
        stat: '${_gameRecords["emoji"]["simple"]} devinettes',
        route: '/gamification/games/emoji',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.82,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final animation = CurvedAnimation(
            parent: _cardsController,
            curve: Interval(
              index * 0.15,
              (index * 0.15 + 0.5).clamp(0.0, 1.0),
              curve: Curves.easeOutBack,
            ),
          );
          return AnimatedBuilder(
            animation: animation,
            builder: (_, child) => Transform.translate(
              offset: Offset(0, 20 * (1 - animation.value)),
              child: Opacity(opacity: animation.value.clamp(0.0, 1.0), child: child),
            ),
            child: _GameCard(data: games[index]),
          );
        },
      ),
    );
  }

  Widget _buildGameStats() {
    // TODO(API) : Ces stats viennent de ProgressionService / GameStatsService
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tes statistiques de jeux',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgLevel2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth - 16) / 2;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                        width: width,
                        child: _StatItem(
                            'Parties', '${_gameStats["totalGames"]}', Icons.sports_esports)),
                    SizedBox(
                        width: width,
                        child: _StatItem(
                            'Victoires', '${_gameStats["totalWins"]}', Icons.emoji_events)),
                    SizedBox(
                        width: width,
                        child: _StatItem('XP gagné', '${_gameStats["totalXPGames"]}', Icons.star)),
                    SizedBox(
                        width: width,
                        child: _StatItem('Série', '${_gameStats["bestStreak"]} 🔥',
                            Icons.local_fire_department)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.white70),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.white54)),
            ],
          ),
        ),
      ],
    );
  }
}

class _DailyChallengeGameCard extends StatelessWidget {
  final AnimationController animController;
  const _DailyChallengeGameCard({required this.animController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.8),
              AppColors.tertiary.withValues(alpha: 0.9)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: AppColors.xpGold),
                const SizedBox(width: 8),
                const Text('DÉFI QUOTIDIEN',
                    style: TextStyle(
                        color: AppColors.xpGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.2)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration:
                      BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
                  child: const Text('23:14:08',
                      style: TextStyle(
                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Wordle',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            const Text('Trouve le mot en 6 essais ou moins',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/gamification/games/wordle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('JOUER - 60 XP ⭐', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameCardData {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final String stat;
  final String route;

  const _GameCardData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.stat,
    required this.route,
  });
}

class _GameCard extends StatelessWidget {
  final _GameCardData data;
  const _GameCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(data.route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgLevel2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: data.color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
                color: data.color.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: data.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(data.icon, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(height: 8),
                Text(data.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(data.subtitle,
                    style: const TextStyle(fontSize: 9, color: Colors.white54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6)),
                  child:
                      Text(data.stat, style: const TextStyle(fontSize: 9, color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
