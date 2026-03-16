import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linguaverse/router.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';
import 'package:linguaverse/shared/utils/constants.dart';

// ─────────────────────────────────────────────
// 1. STATE
// ─────────────────────────────────────────────

class LeaderboardEntry {
  final String name;
  final int xp;
  final String avatarLetter;
  final Color color;

  const LeaderboardEntry({
    required this.name,
    required this.xp,
    required this.avatarLetter,
    required this.color,
  });
}

class HomeState {
  final int streakDays;
  final double xpProgress; // 0.0 → 1.0
  final int xpCurrent;
  final int xpTarget;
  final String currentLesson;
  final double lessonProgress; // 0.0 → 1.0
  final List<LeaderboardEntry> leaderboard;
  final String dailyChallengeTitle;
  final bool isLoading;

  const HomeState({
    this.streakDays = 0,
    this.xpProgress = 0.0,
    this.xpCurrent = 0,
    this.xpTarget = 500,
    this.currentLesson = '',
    this.lessonProgress = 0.0,
    this.leaderboard = const [],
    this.dailyChallengeTitle = '',
    this.isLoading = true,
  });

  HomeState copyWith({
    int? streakDays,
    double? xpProgress,
    int? xpCurrent,
    int? xpTarget,
    String? currentLesson,
    double? lessonProgress,
    List<LeaderboardEntry>? leaderboard,
    String? dailyChallengeTitle,
    bool? isLoading,
  }) {
    return HomeState(
      streakDays: streakDays ?? this.streakDays,
      xpProgress: xpProgress ?? this.xpProgress,
      xpCurrent: xpCurrent ?? this.xpCurrent,
      xpTarget: xpTarget ?? this.xpTarget,
      currentLesson: currentLesson ?? this.currentLesson,
      lessonProgress: lessonProgress ?? this.lessonProgress,
      leaderboard: leaderboard ?? this.leaderboard,
      dailyChallengeTitle: dailyChallengeTitle ?? this.dailyChallengeTitle,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ─────────────────────────────────────────────
// 2. NOTIFIER
// ─────────────────────────────────────────────

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 600));

    state = state.copyWith(
      streakDays: 12,
      xpProgress: 0.72,
      xpCurrent: 360,
      xpTarget: 500,
      currentLesson: 'Les salutations en Arabe',
      lessonProgress: 0.45,
      leaderboard: const [
        LeaderboardEntry(
            name: 'Amina',
            xp: 1240,
            avatarLetter: 'A',
            color: Color(0xFF6366F1)),
        LeaderboardEntry(
            name: 'Youssef',
            xp: 1180,
            avatarLetter: 'Y',
            color: Color(0xFF0EA5E9)),
        LeaderboardEntry(
            name: 'Fatima',
            xp: 1050,
            avatarLetter: 'F',
            color: Color(0xFFF43F5E)),
        LeaderboardEntry(
            name: 'Omar', xp: 980, avatarLetter: 'O', color: Color(0xFF10B981)),
        LeaderboardEntry(
            name: 'Leila',
            xp: 920,
            avatarLetter: 'L',
            color: Color(0xFFF59E0B)),
      ],
      dailyChallengeTitle: 'Traduire 10 mots en 60 secondes',
      isLoading: false,
    );
  }

  Future<void> refreshStreak() async {
    state = state.copyWith(streakDays: state.streakDays + 1);
  }
}

// ─────────────────────────────────────────────
// 3. PROVIDER
// ─────────────────────────────────────────────

final homeProvider =
    StateNotifierProvider<HomeNotifier, HomeState>((ref) => HomeNotifier());

// ─────────────────────────────────────────────
// 4. HOME PAGE
// ─────────────────────────────────────────────

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  // ── Animation controllers ──
  late final AnimationController _fadeSlideController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  late final AnimationController _staggerController;

  late final AnimationController _shimmerController;
  late final Animation<Color?> _shimmerColorAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Fade + Slide entrance
    _fadeSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeSlideController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeSlideController,
      curve: Curves.easeOutCubic,
    ));

    // 4. Stagger for module cards
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 5. Shimmer pulse for daily challenge
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shimmerColorAnimation = ColorTween(
      begin: AppColors.primary,
      end: AppColors.xpGold,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
    _shimmerController.repeat(reverse: true);

    // Start entrance animations
    _fadeSlideController.forward();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _fadeSlideController.dispose();
    _staggerController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  bool _routeAvailable(String route) {
    return AppRoutes.availableRoutes.contains(route);
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: homeState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => ref.read(homeProvider.notifier).loadData(),
                  color: AppColors.primary,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      // Section 1 — Hero Header
                      _HeroHeader(state: homeState),

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: 24),

                            // Section 2 — Continue Learning
                            _ContinueLearningCard(
                              state: homeState,
                              isAvailable: _routeAvailable(AppRoutes.lessons),
                            ),

                            const SizedBox(height: 28),

                            // Section 3 — Module Grid
                            _buildSectionTitle(context, 'Explorer'),
                            const SizedBox(height: 14),
                            _ModuleGrid(
                              staggerController: _staggerController,
                              routeChecker: _routeAvailable,
                            ),

                            const SizedBox(height: 28),

                            // Section 4 — Leaderboard
                            _buildSectionTitle(context, 'Classement'),
                            const SizedBox(height: 14),
                            _LeaderboardRow(
                              leaderboard: homeState.leaderboard,
                            ),

                            const SizedBox(height: 28),

                            // Section 5 — Daily Challenge
                            _buildSectionTitle(context, 'Défi du jour'),
                            const SizedBox(height: 14),
                            _DailyChallenge(
                              title: homeState.dailyChallengeTitle,
                              shimmerColor: _shimmerColorAnimation,
                              shimmerController: _shimmerController,
                            ),

                            const SizedBox(height: 40),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

// ─────────────────────────────────────────────
// 5. PRIVATE WIDGETS
// ─────────────────────────────────────────────

// ── HERO HEADER ──────────────────────────────

class _HeroHeader extends StatelessWidget {
  final HomeState state;
  const _HeroHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              AppColors.secondary,
            ],
          ),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: greeting + avatar ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonjour ! 👋',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'LinguaVerse',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                      ),
                    ],
                  ),
                  // Avatar placeholder
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white38, width: 2),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Streak counter ──
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.streakOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.streakOrange.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        TweenAnimationBuilder<int>(
                          tween: IntTween(begin: 0, end: state.streakDays),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) => Text(
                            '$value jours',
                            style: const TextStyle(
                              color: AppColors.streakOrange,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // XP badge
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: state.xpCurrent),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => Text(
                      '$value / ${state.xpTarget} XP',
                      style: const TextStyle(
                        color: AppColors.xpGold,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── XP progress bar ──
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutExpo,
                      height: 10,
                      width: MediaQuery.of(context).size.width *
                          0.87 *
                          state.xpProgress,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [AppColors.xpGold, Color(0xFFFFD700)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── CONTINUE LEARNING CARD ───────────────────

class _ContinueLearningCard extends StatefulWidget {
  final HomeState state;
  final bool isAvailable;
  const _ContinueLearningCard({
    required this.state,
    required this.isAvailable,
  });

  @override
  State<_ContinueLearningCard> createState() => _ContinueLearningCardState();
}

class _ContinueLearningCardState extends State<_ContinueLearningCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideCtrl;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(-0.15, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAvailable) {
      return _ComingSoonCard(
        title: 'Continuer l\'apprentissage',
        subtitle: 'Module Leçons bientôt disponible',
        icon: Icons.auto_stories_rounded,
      );
    }

    return SlideTransition(
      position: _slideAnim,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Continuer',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.state.currentLesson,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    height: 8,
                    width: MediaQuery.of(context).size.width *
                        0.78 *
                        widget.state.lessonProgress,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(widget.state.lessonProgress * 100).toInt()}% complété',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// ── MODULE GRID ──────────────────────────────

class _ModuleGrid extends StatelessWidget {
  final AnimationController staggerController;
  final bool Function(String) routeChecker;

  const _ModuleGrid({
    required this.staggerController,
    required this.routeChecker,
  });

  static const List<_ModuleData> _modules = [
    _ModuleData(
      title: 'Leçons',
      subtitle: 'Cours structurés',
      icon: Icons.auto_stories_rounded,
      color: AppColors.primary,
      route: AppRoutes.lessons,
    ),
    _ModuleData(
      title: 'Quiz',
      subtitle: 'Testez vos acquis',
      icon: Icons.bolt_rounded,
      color: AppColors.secondary,
      route: AppRoutes.quiz,
    ),
    _ModuleData(
      title: 'Duel',
      subtitle: 'Défiez vos amis',
      icon: Icons.sports_kabaddi_rounded,
      color: AppColors.tertiary,
      route: AppRoutes.duel,
    ),
    _ModuleData(
      title: 'Prononciation',
      subtitle: 'Parlez couramment',
      icon: Icons.mic_rounded,
      color: AppColors.streakOrange,
      route: AppRoutes.pronunciation,
    ),
    _ModuleData(
      title: 'AR Scanner',
      subtitle: 'Apprenez en RA',
      icon: Icons.camera_rounded,
      color: AppColors.correctGreen,
      route: AppRoutes.ar,
    ),
    _ModuleData(
      title: 'IA Quiz',
      subtitle: 'Quiz adaptatif',
      icon: Icons.psychology_rounded,
      color: AppColors.xpGold,
      route: AppRoutes.aiQuiz,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.15,
      ),
      itemCount: _modules.length,
      itemBuilder: (context, index) {
        final module = _modules[index];
        final available = routeChecker(module.route);

        // Stagger delay: 80ms per card
        final begin = (index * 80) / 1200;
        final end = min(begin + 0.4, 1.0);
        final curvedAnimation = CurvedAnimation(
          parent: staggerController,
          curve: Interval(begin, end, curve: Curves.easeOutCubic),
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: available
                ? _ModuleCard(data: module)
                : _ComingSoonCard(
                    title: module.title,
                    subtitle: module.subtitle,
                    icon: module.icon,
                    color: module.color,
                  ),
          ),
        );
      },
    );
  }
}

class _ModuleData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const _ModuleData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}

// ── MODULE CARD (active) ─────────────────────

class _ModuleCard extends StatelessWidget {
  final _ModuleData data;
  const _ModuleCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Navigate via GoRouter
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: data.color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: data.color.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(data.icon, color: data.color, size: 26),
              ),
              const Spacer(),
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: data.color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: data.color.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── COMING SOON CARD ─────────────────────────

class _ComingSoonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? color;

  const _ComingSoonCard({
    required this.title,
    this.subtitle = 'Bientôt disponible',
    this.icon = Icons.lock_clock_rounded,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.textSecondary;

    return Opacity(
      opacity: 0.55,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.outline.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Icon(icon, color: cardColor.withOpacity(0.6), size: 26),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.streakOrange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'BIENTÔT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.streakOrange,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cardColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: cardColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── LEADERBOARD ROW ──────────────────────────

class _LeaderboardRow extends StatelessWidget {
  final List<LeaderboardEntry> leaderboard;
  const _LeaderboardRow({required this.leaderboard});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          final entry = leaderboard[index];

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (index * 100)),
            curve: Curves.easeOut,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            ),
            child: Container(
              width: 85,
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 10,
                right: index == leaderboard.length - 1 ? 0 : 0,
              ),
              decoration: BoxDecoration(
                color: entry.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: entry.color.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Rank badge
                  if (index < 3)
                    Text(
                      ['🥇', '🥈', '🥉'][index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 4),
                  // Avatar circle
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: entry.color,
                    child: Text(
                      entry.avatarLetter,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${entry.xp} XP',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: entry.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── DAILY CHALLENGE ──────────────────────────

class _DailyChallenge extends StatelessWidget {
  final String title;
  final Animation<Color?> shimmerColor;
  final AnimationController shimmerController;

  const _DailyChallenge({
    required this.title,
    required this.shimmerColor,
    required this.shimmerController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmerController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDark.withOpacity(0.05),
                (shimmerColor.value ?? AppColors.primary).withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (shimmerColor.value ?? AppColors.primary).withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.tertiary],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flash_on_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Défi du jour',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Timer hint
          Row(
            children: [
              Icon(Icons.timer_rounded,
                  size: 16, color: AppColors.primary.withOpacity(0.7)),
              const SizedBox(width: 4),
              Text(
                '${AppConstants.quizTimerSecs}s par question',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // CTA button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.tertiary],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    // Challenge navigation — to be wired
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rocket_launch_rounded,
                            color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Relever le défi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
