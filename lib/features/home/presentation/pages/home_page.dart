import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';
import 'package:linguaverse/shared/utils/constants.dart';
import 'package:linguaverse/shared/utils/dev_theme_provider.dart';
import 'package:linguaverse/features/gamification/gamification_exports.dart';

// ════════════════════════════════════════════════════════════════════
// 1. MODÈLES DE DONNÉES
// ════════════════════════════════════════════════════════════════════
class LeaderboardEntry {
  final String name;
  final String initials;
  final int xp;
  final Color baseColor;

  const LeaderboardEntry({
    required this.name,
    required this.initials,
    required this.xp,
    required this.baseColor,
  });
}

class ModuleInfo {
  final String id;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color color;
  final String? route;
  final IconData icon;

  const ModuleInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.color,
    this.route,
    required this.icon,
  });
}

// ════════════════════════════════════════════════════════════════════
// 2. STATE
// ════════════════════════════════════════════════════════════════════
class HomeState {
  final String userName;
  final String userInitials;
  final int userLevel;
  final int currentXP;
  final int nextLevelXP;
  final double xpProgress;
  final int streakDays;
  final String currentLanguage;
  final String lastLessonTitle;
  final double lastLessonProgress;
  final int lastLessonModuleIndex;
  final List<LeaderboardEntry> topPlayers;
  final String dailyChallengeTitle;
  final int dailyChallengeTimerSeconds;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    required this.userName,
    required this.userInitials,
    required this.userLevel,
    required this.currentXP,
    required this.nextLevelXP,
    required this.xpProgress,
    required this.streakDays,
    required this.currentLanguage,
    required this.lastLessonTitle,
    required this.lastLessonProgress,
    required this.lastLessonModuleIndex,
    required this.topPlayers,
    required this.dailyChallengeTitle,
    required this.dailyChallengeTimerSeconds,
    this.isLoading = false,
    this.errorMessage,
  });

  HomeState copyWith({
    String? userName,
    String? userInitials,
    int? userLevel,
    int? currentXP,
    int? nextLevelXP,
    double? xpProgress,
    int? streakDays,
    String? currentLanguage,
    String? lastLessonTitle,
    double? lastLessonProgress,
    int? lastLessonModuleIndex,
    List<LeaderboardEntry>? topPlayers,
    String? dailyChallengeTitle,
    int? dailyChallengeTimerSeconds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      userInitials: userInitials ?? this.userInitials,
      userLevel: userLevel ?? this.userLevel,
      currentXP: currentXP ?? this.currentXP,
      nextLevelXP: nextLevelXP ?? this.nextLevelXP,
      xpProgress: xpProgress ?? this.xpProgress,
      streakDays: streakDays ?? this.streakDays,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      lastLessonTitle: lastLessonTitle ?? this.lastLessonTitle,
      lastLessonProgress: lastLessonProgress ?? this.lastLessonProgress,
      lastLessonModuleIndex: lastLessonModuleIndex ?? this.lastLessonModuleIndex,
      topPlayers: topPlayers ?? this.topPlayers,
      dailyChallengeTitle: dailyChallengeTitle ?? this.dailyChallengeTitle,
      dailyChallengeTimerSeconds: dailyChallengeTimerSeconds ?? this.dailyChallengeTimerSeconds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// 3. NOTIFIER
// ════════════════════════════════════════════════════════════════════
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(_initialMockState) {
    _init();
  }

  Timer? _challengeTimer;

  static const HomeState _initialMockState = HomeState(
    userName: 'Hiba EL OUAFI',
    userInitials: 'HE',
    userLevel: 7,
    currentXP: 3400,
    nextLevelXP: 5000,
    xpProgress: 0.68,
    streakDays: 14,
    currentLanguage: 'Arabe',
    lastLessonTitle: 'Les salutations en arabe',
    lastLessonProgress: 0.42,
    lastLessonModuleIndex: 0,
    topPlayers: [
      LeaderboardEntry(name: 'Amina', initials: 'A', xp: 4230, baseColor: AppColors.tertiary),
      LeaderboardEntry(name: 'Hassan', initials: 'H', xp: 3890, baseColor: AppColors.secondary),
      LeaderboardEntry(name: 'Youssef', initials: 'Y', xp: 3510, baseColor: AppColors.primary),
      LeaderboardEntry(name: 'Hiba', initials: 'HE', xp: 3400, baseColor: AppColors.streakOrange),
      LeaderboardEntry(name: 'Karim', initials: 'K', xp: 3120, baseColor: AppColors.correctGreen),
    ],
    dailyChallengeTitle: 'Maîtriser 10 mots arabes essentiels',
    dailyChallengeTimerSeconds: 287,
    isLoading: false,
  );

  Future<void> _init() async {
    _startChallengeTimer();
  }

  void setLanguage(String lang) {
    state = state.copyWith(currentLanguage: lang);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    // Simulation d'un appel réseau
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    state = state.copyWith(
      isLoading: false,
      currentXP: state.currentXP + 10, // Example of update
    );
  }

  void _startChallengeTimer() {
    _challengeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) {
          _challengeTimer?.cancel();
          return;
        }
        if (state.dailyChallengeTimerSeconds <= 0) {
          _challengeTimer?.cancel();
          return;
        }
        state = state.copyWith(
          dailyChallengeTimerSeconds: state.dailyChallengeTimerSeconds - 1,
        );
      },
    );
  }

  @override
  void dispose() {
    _challengeTimer?.cancel();
    super.dispose();
  }
}

final homeProvider = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(),
);

// Helpers Thèmes Constants pour le mode clair et sombre
Color _surfaceColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark ? AppColors.bgLevel2 : Colors.white;
}

Color _textColor(BuildContext context, {double opacity = 1.0}) {
  return (Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimary)
      .withOpacity(opacity);
}

Color _scaffoldBgColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? AppColors.bgScaffold
      : AppColors.background;
}

// ════════════════════════════════════════════════════════════════════
// 4. PAGE PRINCIPALE
// ════════════════════════════════════════════════════════════════════
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _xpBarController;
  late AnimationController _cardsController;
  late AnimationController _streakController;
  late AnimationController _challengeBorderCtrl;
  late AnimationController _shimmerController;
  late AnimationController _bgTintController;
  late AnimationController _continueCardCtrl;

  late Animation<double> _entryFade;
  late Animation<Offset> _entrySlide;
  late Animation<double> _continueCardSlide;
  late Animation<double> _bgTintValue;

  Color _currentBgTint = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _startEntrySequence();
  }

  void _setupControllers() {
    _entryController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _entryFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _entryController, curve: const Interval(0.0, 0.8, curve: Curves.easeOut)));
    _entrySlide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic));

    _xpBarController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _cardsController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _streakController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _challengeBorderCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 4000))..repeat();
    _shimmerController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();

    _bgTintController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _bgTintValue = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _bgTintController, curve: Curves.easeInOut));

    _continueCardCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _continueCardSlide = Tween<double>(begin: 30.0, end: 0.0)
        .animate(CurvedAnimation(parent: _continueCardCtrl, curve: Curves.easeOutCubic));
  }

  void _startEntrySequence() async {
    await Future.delayed(const Duration(milliseconds: 80));
    if (!mounted) return;
    _entryController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _continueCardCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _xpBarController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _cardsController.forward();

    if (!mounted) return;
    final progressionState = ref.read(userProgressionProvider);
    final streak = progressionState.valueOrNull?.streakDays ?? 0;
    if (streak > 7) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) _streakController.repeat(reverse: true);
    }
  }

  void _onModuleTap(Color moduleColor, String? route) {
    HapticFeedback.mediumImpact();
    setState(() => _currentBgTint = moduleColor);

    _bgTintController.forward().then((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            _bgTintController.reverse().then((_) {
              if (mounted) setState(() => _currentBgTint = Colors.transparent);
            });
          }
        });
      }
    });

    if (route != null) {
      context.go(route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ce module arrive bientôt !',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
          margin: const EdgeInsets.all(AppSpacing.xl),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _xpBarController.dispose();
    _cardsController.dispose();
    _streakController.dispose();
    _challengeBorderCtrl.dispose();
    _shimmerController.dispose();
    _bgTintController.dispose();
    _continueCardCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: _scaffoldBgColor(context),
      floatingActionButton: kDebugMode
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: 'devM7',
                  backgroundColor: AppColors.bgLevel3,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    context.push('/dev/m7-test');
                  },
                  tooltip: 'Panel de test M7 (DEV)',
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.science_rounded, size: 18, color: Colors.white70),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                              color: Colors.orangeAccent, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const _DevThemeToggle(),
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _bgTintValue,
              builder: (context, child) {
                return Container(
                  color: _currentBgTint.withOpacity(0.15 * _bgTintValue.value),
                );
              },
            ),
            RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: _surfaceColor(context),
              displacement: 80,
              strokeWidth: 2.0,
              onRefresh: () async {
                HapticFeedback.mediumImpact();
                await ref.read(homeProvider.notifier).refresh();
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 220,
                    toolbarHeight: 72,
                    pinned: true,
                    floating: false,
                    snap: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        final expandRatio =
                            ((constraints.maxHeight - 72) / (220 - 72)).clamp(0.0, 1.0);
                        return FlexibleSpaceBar(
                          collapseMode: CollapseMode.none,
                          background: Stack(
                            children: [
                              _HeroBackground(expandRatio: expandRatio),
                              Opacity(
                                opacity: expandRatio,
                                child: _FullHeroContent(
                                  state: state,
                                  entryFade: _entryFade,
                                  entrySlide: _entrySlide,
                                  xpController: _xpBarController,
                                  shimmerController: _shimmerController,
                                  streakController: _streakController,
                                  ref: ref,
                                  expandRatio: expandRatio,
                                ),
                              ),
                              Opacity(
                                opacity: 1 - expandRatio,
                                child: _CompactHeroContent(
                                  state: state,
                                  streakController: _streakController,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (state.errorMessage != null)
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(
                            AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.wrongRed.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border:
                              Border.all(color: AppColors.wrongRed.withOpacity(0.25), width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                size: 14, color: AppColors.wrongRed),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.errorMessage!,
                                style: const TextStyle(fontSize: 12, color: AppColors.wrongRed),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                ref.read(homeProvider.notifier).clearError();
                              },
                              child: Icon(Icons.close,
                                  size: 14, color: _textColor(context, opacity: 0.5)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        AnimatedBuilder(
                          animation: _continueCardSlide,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _continueCardSlide.value),
                              child: Opacity(
                                opacity: (1 - (_continueCardSlide.value / 30)).clamp(0.0, 1.0),
                                child: child,
                              ),
                            );
                          },
                          child: _ContinueLearningCard(
                              state: state, shimmerController: _shimmerController),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        _SectionHeader(
                            title: 'Vos parcours', linkLabel: 'Explorer', onLinkTap: () {}),
                        const SizedBox(height: AppSpacing.lg),
                        _ModuleMasonryGrid(
                          state: state,
                          cardsController: _cardsController,
                          onModuleTap: _onModuleTap,
                          shimmerController: _shimmerController,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        _SectionHeader(
                            title: 'Classement', linkLabel: 'Voir tout', onLinkTap: () {}),
                        const SizedBox(height: AppSpacing.md),
                        _LeaderboardRow(
                          state: state,
                          streakController: _streakController,
                          cardsController: _cardsController,
                          shimmerController: _shimmerController,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        _DailyChallengeCard(
                          state: state,
                          challengeBorderCtrl: _challengeBorderCtrl,
                          shimmerController: _shimmerController,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// 5. WIDGETS PRIVÉS HERO HEADER
// ════════════════════════════════════════════════════════════════════

class _HeroBackground extends StatelessWidget {
  final double expandRatio;
  const _HeroBackground({required this.expandRatio});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.bgLevel1 // Level 1
                : AppColors.primaryLight,
          ),
        ),
        Positioned(
          top: -20,
          right: -40,
          width: 220,
          height: 220,
          child: Opacity(
            opacity: 0.15 * expandRatio,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.tertiary, Colors.transparent],
                  stops: [0.2, 1.0],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -30,
          left: -30,
          width: 160,
          height: 160,
          child: Opacity(
            opacity: 0.10 * expandRatio,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.correctGreen, Colors.transparent],
                  stops: [0.2, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FullHeroContent extends StatelessWidget {
  final HomeState state;
  final Animation<double> entryFade;
  final Animation<Offset> entrySlide;
  final AnimationController xpController;
  final AnimationController shimmerController;
  final AnimationController streakController;
  final WidgetRef ref;
  final double expandRatio;

  const _FullHeroContent({
    required this.state,
    required this.entryFade,
    required this.entrySlide,
    required this.xpController,
    required this.shimmerController,
    required this.streakController,
    required this.ref,
    required this.expandRatio,
  });

  @override
  Widget build(BuildContext context) {
    if (expandRatio == 0.0) return const SizedBox.shrink();

    return SafeArea(
      bottom: false,
      child: FadeTransition(
        opacity: entryFade,
        child: SlideTransition(
          position: entrySlide,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopBar(
                  state: state,
                  streakController: streakController,
                ),
                SizedBox(height: 16 * expandRatio),
                _XPBarSection(
                  state: state,
                  xpController: xpController,
                  shimmerController: shimmerController,
                ),
                SizedBox(height: 12 * expandRatio),
                _StreakAndLangRow(
                  state: state,
                  streakController: streakController,
                  ref: ref,
                ),
                SizedBox(height: 20 * expandRatio),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactHeroContent extends StatelessWidget {
  final HomeState state;
  final AnimationController streakController;

  const _CompactHeroContent({
    required this.state,
    required this.streakController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _UserAvatar(state: state, size: 32, fontSize: 12, lvlSize: 7),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                state.userName,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: _textColor(context)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _StreakPill(streakController: streakController),
            const SizedBox(width: AppSpacing.md),
            Consumer(builder: (context, ref, _) {
              final prog = ref.watch(userProgressionProvider).valueOrNull;
              final progress = prog?.xpProgress ?? 0.0;
              return Text(
                '${(progress * 100).toInt()}% XP',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _textColor(context, opacity: 0.7)),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final HomeState state;
  final double size;
  final double fontSize;
  final double lvlSize;

  const _UserAvatar({
    required this.state,
    this.size = 40,
    this.fontSize = 14,
    this.lvlSize = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            state.userInitials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.xpGold,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Consumer(builder: (context, ref, _) {
              final val = ref.watch(userProgressionProvider).valueOrNull?.currentLevel ?? 1;
              return Text(
                'LVL $val',
                style: TextStyle(
                  fontSize: lvlSize,
                  fontWeight: FontWeight.w900,
                  color: AppColors.bgScaffold, // Always dark text on gold badge
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  final HomeState state;
  final AnimationController streakController;

  const _TopBar({
    required this.state,
    required this.streakController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bonjour 👋',
                  style: TextStyle(fontSize: 14, color: _textColor(context, opacity: 0.7))),
              Text(
                state.userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _textColor(context),
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        _UserAvatar(state: state),
      ],
    );
  }
}

class _XPBarSection extends StatelessWidget {
  final HomeState state;
  final AnimationController xpController;
  final AnimationController shimmerController;

  const _XPBarSection({
    required this.state,
    required this.xpController,
    required this.shimmerController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer(builder: (context, ref, _) {
              final prog = ref.watch(userProgressionProvider).valueOrNull;
              final level = prog?.currentLevel ?? 1;
              final currentXP = prog?.currentXP ?? 0;
              final nextXP = prog?.xpForNextLevel ?? 500;
              return Text(
                'Niveau $level  ·  $currentXP / $nextXP XP',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: _textColor(context, opacity: 0.6)),
              );
            }),
            Consumer(builder: (context, ref, _) {
              final prog = ref.watch(userProgressionProvider).valueOrNull;
              final progress = prog?.xpProgress ?? 0.0;
              return AnimatedBuilder(
                animation: xpController,
                builder: (context, _) {
                  final val = (xpController.value * progress * 100).toInt();
                  return Text(
                    '$val%',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _textColor(context, opacity: 0.7)),
                  );
                },
              );
            }),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _textColor(context, opacity: 0.08),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Stack(
                children: [
                  Consumer(builder: (context, ref, _) {
                    final prog = ref.watch(userProgressionProvider).valueOrNull;
                    final progress = prog?.xpProgress ?? 0.0;
                    return AnimatedBuilder(
                      animation: xpController,
                      builder: (context, _) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: Curves.easeOutExpo.transform(xpController.value) * progress,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  _ShimmerOverlay(
                    controller: shimmerController,
                    trackWidth: constraints.maxWidth,
                    xpController: xpController,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StreakAndLangRow extends StatelessWidget {
  final HomeState state;
  final AnimationController streakController;
  final WidgetRef ref;

  const _StreakAndLangRow({
    required this.state,
    required this.streakController,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StreakPill(streakController: streakController),
        const Spacer(),
        _LanguageSwitcher(state: state, ref: ref),
      ],
    );
  }
}

class _StreakPill extends ConsumerWidget {
  final AnimationController streakController;

  const _StreakPill({
    required this.streakController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prog = ref.watch(userProgressionProvider).valueOrNull;
    final streakDays = prog?.streakDays ?? 0;
    final bool hot = streakDays > 7;
    Widget pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.streakOrange.withOpacity(0.15),
        border: Border.all(color: AppColors.streakOrange.withOpacity(0.40), width: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: AppSpacing.xs),
          _AnimatedCounter(
            value: streakDays,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
              color: AppColors.streakOrange,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          const Text('jours', style: TextStyle(fontSize: 10, color: AppColors.streakOrange)),
        ],
      ),
    );

    if (hot) {
      return AnimatedBuilder(
        animation: streakController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (streakController.value * 0.05),
            child: child,
          );
        },
        child: pill,
      );
    }
    return pill;
  }
}

class _LanguageSwitcher extends StatelessWidget {
  final HomeState state;
  final WidgetRef ref;

  const _LanguageSwitcher({
    required this.state,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final langs = ['AR', 'EN', 'FR'];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: langs.map((lang) {
        final isActive = state.currentLanguage.startsWith(lang) ||
            (lang == 'AR' && state.currentLanguage == 'Arabe');
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            ref.read(homeProvider.notifier).setLanguage(lang);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 6),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: isActive ? _textColor(context, opacity: 0.15) : Colors.transparent,
              border: Border.all(
                color: isActive
                    ? _textColor(context, opacity: 0.40)
                    : _textColor(context, opacity: 0.12),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              lang,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isActive ? _textColor(context) : _textColor(context, opacity: 0.4),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final AnimationController shimmerController;
  final double height;
  final double? width;

  const _ShimmerCard({
    required this.shimmerController,
    required this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmerController,
      builder: (context, child) {
        return Container(
          height: height,
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2 * shimmerController.value, 0),
              end: Alignment(1.0 + 2 * shimmerController.value, 0),
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [
                      Colors.white.withOpacity(0.04),
                      Colors.white.withOpacity(0.09),
                      Colors.white.withOpacity(0.04),
                    ]
                  : [
                      Colors.black.withOpacity(0.04),
                      Colors.black.withOpacity(0.08),
                      Colors.black.withOpacity(0.04),
                    ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class _ContinueLearningCard extends StatefulWidget {
  final HomeState state;
  final AnimationController shimmerController;

  const _ContinueLearningCard({
    required this.state,
    required this.shimmerController,
  });

  @override
  State<_ContinueLearningCard> createState() => _ContinueLearningCardState();
}

class _ContinueLearningCardState extends State<_ContinueLearningCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.state.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: _ShimmerCard(shimmerController: widget.shimmerController, height: 140),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: 'Reprendre la leçon ${widget.state.lastLessonTitle}',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {
          HapticFeedback.lightImpact();
          context.go('/lessons');
        },
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.bgLevel3 : AppColors.surface,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: const Alignment(0.8, 0.8),
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.primary.withOpacity(0.35), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('● EN COURS',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.primary)),
                    ),
                    const Spacer(),
                    Text('~8 min restantes',
                        style: TextStyle(fontSize: 10, color: _textColor(context, opacity: 0.5))),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  widget.state.lastLessonTitle,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textColor(context),
                      letterSpacing: -0.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.state.currentLanguage} · Module ${widget.state.lastLessonModuleIndex + 1} · Débutant',
                  style: TextStyle(fontSize: 11, color: _textColor(context, opacity: 0.5)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${(widget.state.lastLessonProgress * 100).toInt()}% Complété',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _textColor(context, opacity: 0.7)),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: _textColor(context, opacity: 0.08),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: widget.state.lastLessonProgress,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.xpGold,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? linkLabel;
  final VoidCallback? onLinkTap;

  const _SectionHeader({
    required this.title,
    this.linkLabel,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor(context),
                    letterSpacing: -0.5),
              ),
              if (linkLabel != null)
                Semantics(
                  button: true,
                  label: linkLabel,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onLinkTap?.call();
                    },
                    child: Text(
                      '$linkLabel →',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 0.5,
          color: _textColor(context, opacity: 0.06),
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        ),
      ],
    );
  }
}

class _ModuleMasonryGrid extends StatelessWidget {
  final HomeState state;
  final AnimationController cardsController;
  final Function(Color, String?) onModuleTap;
  final AnimationController shimmerController;

  const _ModuleMasonryGrid({
    required this.state,
    required this.cardsController,
    required this.onModuleTap,
    required this.shimmerController,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 45,
              child: _ShimmerCard(shimmerController: shimmerController, height: 180),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 55,
              child: Column(
                children: [
                  _ShimmerCard(shimmerController: shimmerController, height: 84),
                  const SizedBox(height: AppSpacing.md),
                  _ShimmerCard(shimmerController: shimmerController, height: 84),
                ],
              ),
            ),
          ],
        ),
      );
    }

    const lessonsModule = ModuleInfo(
      id: 'lessons',
      title: 'Leçons',
      subtitle: 'Parcours principal',
      badgeText: 'Étape 4',
      color: AppColors.primary,
      route: '/lessons',
      icon: Icons.school_rounded,
    );
    const srsModule = ModuleInfo(
      id: 'srs',
      title: 'Révisions',
      subtitle: 'Vocabulaire',
      badgeText: '+12',
      color: AppColors.secondary,
      icon: Icons.repeat_rounded,
    );
    const arModule = ModuleInfo(
      id: 'ar',
      title: 'AR Scanner',
      subtitle: 'Scanne le monde',
      badgeText: 'Nouveau',
      color: AppColors.correctGreen,
      route: '/ar',
      icon: Icons.view_in_ar_rounded,
    );
    const quizModule = ModuleInfo(
      id: 'quiz',
      title: 'Quiz Éclair',
      subtitle: 'Test rapide',
      badgeText: '50 XP',
      color: AppColors.xpGold,
      route: '/quiz',
      icon: Icons.flash_on_rounded,
    );
    const duelModule = ModuleInfo(
      id: 'duel',
      title: 'Duels',
      subtitle: 'PvP en direct',
      badgeText: 'En ligne',
      color: AppColors.streakOrange,
      route: '/duel',
      icon: Icons.sports_esports_rounded,
    );
    const vocalModule = ModuleInfo(
      id: 'pronunciation',
      title: 'Vocal',
      subtitle: 'Alerte accent',
      badgeText: '',
      color: AppColors.tertiary,
      route: '/pronunciation',
      icon: Icons.mic_rounded,
    );
    const aiQuizModule = ModuleInfo(
      id: 'ai-chat',
      title: 'Quiz IA',
      subtitle: 'Chatbot oral',
      badgeText: 'Bêta',
      color: Colors.indigo,
      route: '/ai-quiz',
      icon: Icons.smart_toy_rounded,
    );
    const gamificationModule = ModuleInfo(
      id: 'gamification',
      title: 'Jeux & Progrès',
      subtitle: 'Mini-jeux & XP',
      badgeText: 'Nouveau',
      color: AppColors.xpGold,
      route: '/gamification/games',
      icon: Icons.emoji_events_rounded,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 45,
                child: _AnimatedGridItem(
                  index: 0,
                  controller: cardsController,
                  child: _ModuleCard(
                      module: lessonsModule, height: 180, isLarge: true, onTap: onModuleTap),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 55,
                child: Column(
                  children: [
                    _AnimatedGridItem(
                      index: 1,
                      controller: cardsController,
                      child: _ModuleCard(module: srsModule, height: 84, onTap: onModuleTap),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _AnimatedGridItem(
                      index: 2,
                      controller: cardsController,
                      child: _ModuleCard(module: arModule, height: 84, onTap: onModuleTap),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _AnimatedGridItem(
                  index: 3,
                  controller: cardsController,
                  child: _ModuleCard(module: quizModule, height: 90, onTap: onModuleTap),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _AnimatedGridItem(
                  index: 4,
                  controller: cardsController,
                  child: _ModuleCard(module: duelModule, height: 90, onTap: onModuleTap),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _AnimatedGridItem(
                  index: 5,
                  controller: cardsController,
                  child: _ModuleCard(module: gamificationModule, height: 110, onTap: onModuleTap),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _AnimatedGridItem(
                  index: 6,
                  controller: cardsController,
                  child: _ModuleCard(module: aiQuizModule, height: 110, onTap: onModuleTap),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _AnimatedGridItem(
            index: 7,
            controller: cardsController,
            child: const _ComingSoonCard(module: vocalModule, height: 100),
          ),
        ],
      ),
    );
  }
}

class _AnimatedGridItem extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final Widget child;

  const _AnimatedGridItem({
    required this.index,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.1).clamp(0.0, 0.5);
    final end = (start + 0.5).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final curve = CurvedAnimation(
            parent: controller, curve: Interval(start, end, curve: Curves.easeOutBack));
        return Transform.scale(
          scale: 0.8 + (0.2 * curve.value),
          child: Opacity(
            opacity: curve.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _ModuleCard extends StatefulWidget {
  final ModuleInfo module;
  final double height;
  final bool isLarge;
  final Function(Color, String?) onTap;

  const _ModuleCard({
    required this.module,
    required this.height,
    this.isLarge = false,
    required this.onTap,
  });

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: '${widget.module.title}, ${widget.module.subtitle}',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onTap(widget.module.color, widget.module.route);
        },
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Container(
            height: widget.height,
            padding: EdgeInsets.all(
                widget.isLarge ? AppSpacing.xl : AppSpacing.sm), // Reduced padding for small cards
            decoration: BoxDecoration(
              color: isDark ? AppColors.bgLevel2 : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: widget.module.color.withOpacity(0.3), width: 0.5),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                          color: widget.module.color.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4))
                    ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Opacity(
                    opacity: 0.05,
                    child: Icon(widget.module.icon,
                        size: widget.isLarge ? 120 : 60,
                        color: widget.module.color), // Smaller bg icon
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            widget.isLarge ? AppSpacing.sm : 6), // Smaller icon padding
                        decoration: BoxDecoration(
                          color: widget.module.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(widget.isLarge ? AppRadius.md : 6),
                        ),
                        child: Icon(widget.module.icon,
                            size: widget.isLarge ? 24 : 16, color: widget.module.color),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.module.title,
                        style: TextStyle(
                            fontSize: widget.isLarge ? 18 : 14,
                            fontWeight: FontWeight.w700,
                            color: _textColor(context),
                            letterSpacing: -0.3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.module.subtitle,
                        style: TextStyle(
                            fontSize: widget.isLarge ? 12 : 10,
                            color: _textColor(context, opacity: 0.5)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (widget.module.badgeText.isNotEmpty)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Tighter badge
                      decoration: BoxDecoration(
                        color: widget.module.color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.module.badgeText,
                        style: const TextStyle(
                            fontSize: 8, // Smaller badge text
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  final ModuleInfo module;
  final double height;

  const _ComingSoonCard({
    required this.module,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _surfaceColor(context),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
            color: _textColor(context, opacity: 0.08), width: 1, style: BorderStyle.solid),
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(module.icon, size: 18, color: _textColor(context, opacity: 0.5)),
                const Spacer(),
                Text(
                  module.title,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textColor(context, opacity: 0.5)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Bientôt',
                  style: TextStyle(fontSize: 10, color: _textColor(context, opacity: 0.3)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final HomeState state;
  final AnimationController streakController;
  final AnimationController cardsController;
  final AnimationController shimmerController;

  const _LeaderboardRow({
    required this.state,
    required this.streakController,
    required this.cardsController,
    required this.shimmerController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final leaderState = ref.watch(leaderboardProvider);

      if (leaderState.isLoading || (!leaderState.hasValue)) {
        return SizedBox(
          height: 80,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: AppSpacing.md),
                child: _ShimmerCard(shimmerController: shimmerController, height: 80, width: 80),
              );
            },
          ),
        );
      }

      final topPlayers = leaderState.value!.topPlayers;

      if (topPlayers.isEmpty) {
        return Container(
          height: 90,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.leaderboard_outlined, size: 28, color: _textColor(context, opacity: 0.4)),
              const SizedBox(height: 6),
              Text(
                'Pas encore de classement cette semaine',
                style: TextStyle(fontSize: 11, color: _textColor(context, opacity: 0.5)),
              ),
            ],
          ),
        );
      }

      return SizedBox(
        height: 90,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: topPlayers.length,
          itemBuilder: (context, index) {
            final player = topPlayers[index];
            final currentUserId = ref.watch(currentUserIdProvider);
            final isCurrentUser = player.userId == currentUserId;
            final isTop3 = index < 3;

            String rankIcon;
            if (index == 0) {
              rankIcon = '🥇';
            } else if (index == 1) {
              rankIcon = '🥈';
            } else if (index == 2) {
              rankIcon = '🥉';
            } else {
              rankIcon = '#${index + 1}';
            }

            return AnimatedBuilder(
              animation: cardsController,
              builder: (context, child) {
                final start = (index * 0.1).clamp(0.0, 0.8);
                final end = (start + 0.2).clamp(0.0, 1.0);
                final curve = CurvedAnimation(
                    parent: cardsController,
                    curve: Interval(start, end, curve: Curves.easeOutBack));

                return Transform.translate(
                  offset: Offset(20 * (1 - curve.value), 0),
                  child: Opacity(
                    opacity: curve.value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Semantics(
                button: true,
                label: 'Joueur ${player.userName}, position ${index + 1}, ${player.xpEarned} XP',
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                  },
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  splashColor: AppColors.primary.withValues(alpha: 0.08),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isCurrentUser
                          ? AppColors.streakOrange.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: isCurrentUser
                          ? Border.all(
                              color: AppColors.streakOrange.withValues(alpha: 0.3), width: 1)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: player.avatarGradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(color: _surfaceColor(context), width: 2),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                player.userInitials,
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Positioned(
                              top: -6,
                              right: -6,
                              child: isTop3
                                  ? Text(rankIcon, style: const TextStyle(fontSize: 16))
                                  : Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: _surfaceColor(context),
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: _textColor(context, opacity: 0.1)),
                                      ),
                                      child: Text(rankIcon,
                                          style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                              color: _textColor(context, opacity: 0.7))),
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          player.userName,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w500,
                              color: isCurrentUser ? AppColors.streakOrange : _textColor(context)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _DailyChallengeCard extends StatefulWidget {
  final HomeState state;
  final AnimationController challengeBorderCtrl;
  final AnimationController shimmerController;

  const _DailyChallengeCard({
    required this.state,
    required this.challengeBorderCtrl,
    required this.shimmerController,
  });

  @override
  State<_DailyChallengeCard> createState() => _DailyChallengeCardState();
}

class _DailyChallengeCardState extends State<_DailyChallengeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.state.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: _ShimmerCard(shimmerController: widget.shimmerController, height: 110),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Semantics(
        button: true,
        label: 'Défi quotidien : ${widget.state.dailyChallengeTitle}',
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: () {
            HapticFeedback.heavyImpact();
            // Action pour le défi
          },
          child: AnimatedScale(
            scale: _pressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: widget.challengeBorderCtrl,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _RotatingBorderPainter(
                          progress: widget.challengeBorderCtrl.value,
                          color1: AppColors.primary,
                          color2: AppColors.tertiary,
                          radius: AppRadius.lg,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(2), // Espace pour la bordure animée
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: _surfaceColor(context),
                    borderRadius: BorderRadius.circular(AppRadius.lg - 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.stars_rounded, color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Défi du jour',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: 0.5),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              widget.state.dailyChallengeTitle,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _textColor(context)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _CountdownTimer(
                              seconds: widget.state.dailyChallengeTimerSeconds, context: context),
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: const Text('GO',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownTimer extends StatelessWidget {
  final int seconds;
  final BuildContext context;

  const _CountdownTimer({required this.seconds, required this.context});

  @override
  Widget build(BuildContext context) {
    if (seconds <= 0) {
      return Text('Terminé',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: _textColor(context, opacity: 0.5)));
    }
    final m = (seconds / 60).floor();
    final s = seconds % 60;
    final display = '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return Text(
      display,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontFamily: 'monospace',
        color: AppColors.wrongRed,
      ),
    );
  }
}

class _RotatingBorderPainter extends CustomPainter {
  final double progress;
  final Color color1;
  final Color color2;
  final double radius;

  _RotatingBorderPainter({
    required this.progress,
    required this.color1,
    required this.color2,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = SweepGradient(
        colors: [color1, color2, color1],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(progress * 2 * 3.1415926535),
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _RotatingBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _AnimatedCounter extends StatelessWidget {
  final int value;
  final TextStyle style;

  const _AnimatedCounter({
    required this.value,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, val, child) {
        return Text(val.toInt().toString(), style: style);
      },
    );
  }
}

class _ShimmerOverlay extends StatelessWidget {
  final AnimationController controller;
  final double trackWidth;
  final AnimationController xpController;

  const _ShimmerOverlay({
    required this.controller,
    required this.trackWidth,
    required this.xpController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, xpController]),
      builder: (context, child) {
        final currentWidth = trackWidth * xpController.value;
        if (currentWidth <= 0) return const SizedBox.shrink();

        return ClipRect(
          child: SizedBox(
            width: currentWidth,
            child: FractionalTranslation(
              translation: Offset(-1.0 + (controller.value * 2.5), 0),
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DevThemeToggle extends ConsumerWidget {
  const _DevThemeToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(devThemeProvider);
    final isDark = currentMode == ThemeMode.dark ||
        (currentMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Tooltip(
      message: isDark ? 'Passer en Light mode (DEV)' : 'Passer en Dark mode (DEV)',
      preferBelow: false,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          ref.read(devThemeProvider.notifier).state = isDark ? ThemeMode.light : ThemeMode.dark;
        },
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isDark ? AppColors.glassBlue : AppColors.bgLevel3,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: isDark ? Colors.black.withOpacity(0.08) : Colors.white.withOpacity(0.15),
              width: 0.5,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                size: 22,
                color: isDark ? AppColors.bgLevel3 : AppColors.glassBlue,
              ),
              Positioned(
                top: 6,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.wrongRed,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    'DEV',
                    style: TextStyle(
                        fontSize: 6,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
