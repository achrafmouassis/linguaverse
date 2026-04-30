import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import 'package:linguaverse/shared/theme/app_colors.dart';
import 'package:linguaverse/shared/utils/constants.dart';
import 'package:linguaverse/features/gamification/gamification_exports.dart';
import 'package:linguaverse/features/duel/presentation/providers/duel_providers.dart';
import 'package:linguaverse/features/duel/data/mock/m6_mock_data.dart';
import 'package:linguaverse/features/duel/data/models/duel_opponent_model.dart';

// ════════════════════════════════════════════════════════════════
// PAGE LOBBY — Sélection de l'adversaire et du mode de jeu
// ════════════════════════════════════════════════════════════════
class DuelLobbyPage extends ConsumerStatefulWidget {
  const DuelLobbyPage({super.key});

  @override
  ConsumerState<DuelLobbyPage> createState() => _DuelLobbyPageState();
}

class _DuelLobbyPageState extends ConsumerState<DuelLobbyPage> with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _entryFade;
  late Animation<Offset> _entrySlide;
  late AnimationController _pulseCtrl;
  int _selectedModeIndex = 0;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _entryFade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _entrySlide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entryCtrl.forward();
      final lvl = ref.read(userProgressionProvider).valueOrNull?.currentLevel ?? 1;
      ref.read(duelLobbyProvider.notifier).loadOpponents(userLevel: lvl);
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lobby = ref.watch(duelLobbyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgScaffold : AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _entryFade,
          child: SlideTransition(
            position: _entrySlide,
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: lobby.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: AppColors.streakOrange))
                      : _buildBody(context, lobby, isDark),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, Color(0xFF1A056B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.xl)),
        boxShadow: [
          BoxShadow(
            color: AppColors.streakOrange.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 18),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.pop();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                icon: const Icon(Icons.home_rounded, color: Colors.white70, size: 20),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.go('/home');
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('⚔️  Mode Duel',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5)),
                    Text('Affronte un adversaire en temps réel',
                        style: TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ),
              // Statistiques rapides
              Consumer(builder: (ctx, ref, _) {
                final prog = ref.watch(userProgressionProvider).valueOrNull;
                final wins = prog?.duelWins ?? 0;
                final played = prog?.duelsPlayed ?? 0;
                return _StatPill(label: '$wins / $played V', icon: '🏆');
              }),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // ── Sélection du mode ────────────────────────────────────
          SizedBox(
            height: 85,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: M6MockData.gameModes.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (ctx, i) {
                final mode = M6MockData.gameModes[i];
                final selected = i == _selectedModeIndex;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedModeIndex = i);
                    ref.read(duelLobbyProvider.notifier).selectMode(mode['id'] as String);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white.withValues(alpha: 0.18)
                          : Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: selected
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(mode['icon'] as String, style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 2),
                        Text(mode['title'] as String,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.white60,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            )),
                        Text('+${mode['xpWin']} XP',
                            style: const TextStyle(
                              color: AppColors.xpGold,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, DuelLobbyState lobby, bool isDark) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        // ── Sélection langue ─────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Langue du duel',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    )),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: ['Arabe', 'Anglais'].map((lang) {
                    final selected = lobby.selectedLanguage == lang;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        ref.read(duelLobbyProvider.notifier).selectLanguage(lang);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: AppSpacing.sm),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.streakOrange.withValues(alpha: 0.12)
                              : Colors.transparent,
                          border: Border.all(
                            color: selected
                                ? AppColors.streakOrange
                                : Colors.grey.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(lang,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: selected ? AppColors.streakOrange : Colors.grey[500],
                            )),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        // ── Liste adversaires ─────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text('Choisis ton adversaire',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.primaryDark,
                  letterSpacing: -0.3,
                )),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              final opp = lobby.opponents[i];
              final isSelected = lobby.selectedOpponent?.opponentId == opp.opponentId;
              return _OpponentCard(
                opponent: opp,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref.read(duelLobbyProvider.notifier).selectOpponent(opp);
                },
              );
            },
            childCount: lobby.opponents.length,
          ),
        ),
        // ── Bouton DÉFI ───────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.xxl),
            child: _ChallengeButton(
              lobby: lobby,
              pulseCtrl: _pulseCtrl,
              onChallenge: () => _startDuel(lobby),
            ),
          ),
        ),
      ],
    );
  }

  void _startDuel(DuelLobbyState lobby) {
    if (lobby.selectedOpponent == null) return;
    HapticFeedback.heavyImpact();
    final userId = ref.read(currentUserIdProvider);
    final userName = ref.read(currentUserNameProvider);
    final modeId = lobby.selectedMode;

    ref.read(duelArenaProvider.notifier).startSession(
          opponent: lobby.selectedOpponent!,
          mode: modeId,
          language: lobby.selectedLanguage,
          currentUserId: userId,
          currentUserName: userName,
        );
    context.go('/duel/arena');
  }
}

// ── Carte adversaire ─────────────────────────────────────────────
class _OpponentCard extends StatefulWidget {
  final DuelOpponentModel opponent;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _OpponentCard({
    required this.opponent,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_OpponentCard> createState() => _OpponentCardState();
}

class _OpponentCardState extends State<_OpponentCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.opponent;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: widget.isDark
                ? (widget.isSelected ? AppColors.bgLevel3 : AppColors.bgLevel2)
                : (widget.isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7)),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: widget.isSelected ? AppColors.streakOrange : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.streakOrange.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: Row(
            children: [
              // Avatar dégradé
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [o.avatarColor1, o.avatarColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(o.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    )),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(o.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: widget.isDark ? Colors.white : AppColors.primaryDark,
                            )),
                        const SizedBox(width: AppSpacing.sm),
                        if (o.isBot)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('BOT',
                                style: TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.w700, color: Colors.grey)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Niv. ${o.level} · ${o.difficultyLabel} · ${o.winRate}% victoires',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              // Indicateur de difficulté
              _DifficultyDots(difficulty: o.difficulty),
              if (widget.isSelected)
                const Padding(
                  padding: EdgeInsets.only(left: AppSpacing.sm),
                  child: Icon(Icons.check_circle_rounded, color: AppColors.streakOrange, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Points de difficulté ─────────────────────────────────────────
class _DifficultyDots extends StatelessWidget {
  final String difficulty;
  const _DifficultyDots({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final filled = switch (difficulty) {
      'easy' => 1,
      'medium' => 2,
      'hard' => 3,
      'expert' => 4,
      _ => 2,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (i) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(left: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < filled ? _diffColor(difficulty) : Colors.grey.withValues(alpha: 0.25),
          ),
        );
      }),
    );
  }

  Color _diffColor(String d) => switch (d) {
        'easy' => AppColors.correctGreen,
        'medium' => AppColors.xpGold,
        'hard' => AppColors.streakOrange,
        'expert' => AppColors.wrongRed,
        _ => AppColors.primary,
      };
}

// ── Pill statistique ─────────────────────────────────────────────
class _StatPill extends StatelessWidget {
  final String label;
  final String icon;
  const _StatPill({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

// ── Bouton DÉFI ──────────────────────────────────────────────────
class _ChallengeButton extends StatefulWidget {
  final DuelLobbyState lobby;
  final AnimationController pulseCtrl;
  final VoidCallback onChallenge;

  const _ChallengeButton({
    required this.lobby,
    required this.pulseCtrl,
    required this.onChallenge,
  });

  @override
  State<_ChallengeButton> createState() => _ChallengeButtonState();
}

class _ChallengeButtonState extends State<_ChallengeButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.lobby.selectedOpponent != null;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTap: enabled ? widget.onChallenge : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: widget.pulseCtrl,
          builder: (ctx, child) {
            return Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: enabled
                    ? LinearGradient(
                        colors: [
                          AppColors.streakOrange,
                          Color.lerp(AppColors.streakOrange, const Color(0xFFE24B4A), 0.5)!,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: enabled ? null : Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: AppColors.streakOrange
                              .withValues(alpha: 0.3 + 0.1 * widget.pulseCtrl.value),
                          blurRadius: 16 + 8 * widget.pulseCtrl.value,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⚔️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: AppSpacing.sm),
              Text(
                enabled ? 'Défier ${widget.lobby.selectedOpponent!.name}' : 'Choisis un adversaire',
                style: TextStyle(
                  color: enabled ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
