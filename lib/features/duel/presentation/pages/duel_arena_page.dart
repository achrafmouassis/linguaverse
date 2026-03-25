import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:linguaverse/shared/theme/app_colors.dart';
import 'package:linguaverse/shared/utils/constants.dart';
import 'package:linguaverse/features/gamification/gamification_exports.dart';
import 'package:linguaverse/features/duel/presentation/providers/duel_providers.dart';

class DuelArenaPage extends ConsumerStatefulWidget {
  const DuelArenaPage({super.key});

  @override
  ConsumerState<DuelArenaPage> createState() => _DuelArenaPageState();
}

class _DuelArenaPageState extends ConsumerState<DuelArenaPage> with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  Timer? _timer;
  int _msPassed = 0;
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startInitialCountdown();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startInitialCountdown() {
    setState(() => _countdown = 3);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _countdown--);
      if (_countdown == 0) {
        timer.cancel();
        ref.read(duelArenaProvider.notifier).startQuestion();
        _startQuestionTimer();
      } else {
        HapticFeedback.lightImpact();
      }
    });
  }

  void _startQuestionTimer() {
    _timer?.cancel();
    _msPassed = 0;
    _fadeCtrl.forward(from: 0);

    const period = 50;
    _timer = Timer.periodic(const Duration(milliseconds: period), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final arena = ref.read(duelArenaProvider);
      if (arena.phase != ArenaPhase.question) {
        timer.cancel();
        return;
      }
      setState(() => _msPassed += period);
      if (_msPassed >= (arena.session?.timePerQuestion ?? 30) * 1000) {
        timer.cancel();
        ref.read(duelArenaProvider.notifier).onTimeout();
        _handleRevealPhase();
      }
    });
  }

  void _handleRevealPhase() {
    _timer?.cancel();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      final arena = ref.read(duelArenaProvider);
      if (arena.isLastQuestion) {
        ref.read(duelArenaProvider.notifier).nextQuestion().then((_) {
          if (mounted) context.go('/duel/result');
        });
      } else {
        ref.read(duelArenaProvider.notifier).nextQuestion().then((_) {
          if (mounted) {
            ref.read(duelArenaProvider.notifier).startQuestion();
            _startQuestionTimer();
          }
        });
      }
    });
  }

  void _onAnswerSelected(String answer) {
    if (ref.read(duelArenaProvider).phase != ArenaPhase.question) return;
    HapticFeedback.mediumImpact();
    ref.read(duelArenaProvider.notifier).submitAnswer(answer, _msPassed);
    _handleRevealPhase();
  }

  @override
  Widget build(BuildContext context) {
    final arena = ref.watch(duelArenaProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (arena.session == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.bgScaffold : const Color(0xFFF4F6FA),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (!didPop) {
          _showExitDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.bgScaffold : const Color(0xFFF4F6FA),
        body: SafeArea(
          child: arena.isLoading
              ? _buildLoadingState(isDark)
              : Column(
                  children: [
                    _buildHeader(arena),
                    _buildVersusRow(arena, isDark),
                    _buildTimerBar(arena),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (arena.phase == ArenaPhase.countdown) _buildCountdown(),
                          if (arena.phase == ArenaPhase.question ||
                              arena.phase == ArenaPhase.reveal)
                            FadeTransition(
                              opacity: _fadeCtrl,
                              child: _buildQuestionArea(arena, isDark),
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

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.streakOrange),
          const SizedBox(height: AppSpacing.lg),
          Text('Archivage du duel...',
              style: TextStyle(color: isDark ? Colors.white60 : Colors.black54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildHeader(DuelArenaState arena) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _showExitDialog(context),
            child: const Icon(Icons.close_rounded, color: Colors.grey, size: 24),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              '${arena.currentQuestionIndex + 1} / ${arena.session!.questionCount}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const Icon(Icons.more_horiz_rounded, color: Colors.transparent, size: 24),
        ],
      ),
    );
  }

  Widget _buildVersusRow(DuelArenaState arena, bool isDark) {
    final o = arena.opponent;
    final myInitials = ref.watch(currentUserInitialsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Joueur 1 (Moi)
          _PlayerScorePill(
            name: arena.session!.player1Name,
            initials: myInitials,
            score: arena.player1Score,
            isMe: true,
            isDark: isDark,
          ),
          // Indicateur VS
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.streakOrange.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Text('VS',
                style: TextStyle(
                    color: AppColors.streakOrange, fontWeight: FontWeight.w900, fontSize: 10)),
          ),
          // Joueur 2 (Opponent)
          if (o != null)
            _PlayerScorePill(
              name: o.name,
              initials: o.initials,
              score: arena.player2Score,
              isMe: false,
              isDark: isDark,
              c1: o.avatarColor1,
              c2: o.avatarColor2,
            ),
        ],
      ),
    );
  }

  Widget _buildTimerBar(DuelArenaState arena) {
    final limitMs = (arena.session?.timePerQuestion ?? 30) * 1000;
    final ratio = 1 - (_msPassed / limitMs).clamp(0.0, 1.0);
    final color = ratio < 0.25 ? AppColors.wrongRed : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: arena.phase == ArenaPhase.countdown ? 1.0 : ratio,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountdown() {
    return TweenAnimationBuilder<double>(
      key: ValueKey(_countdown),
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      builder: (ctx, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Text(
            '$_countdown',
            style: const TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestionArea(DuelArenaState arena, bool isDark) {
    final q = arena.currentQuestion;
    if (q == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: isDark ? AppColors.bgLevel2 : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              q.questionText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: q.questionType == 'emoji_battle' ? 48 : 22,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (q.choices.isNotEmpty)
            ...q.choices.map((choice) => _buildChoice(arena, choice, isDark)),
          if (q.choices.isEmpty) // mode vocabulaire ou emoji
            _buildDirectInputPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildDirectInputPlaceholder() {
    // Dans une V2, ici on aurait un Textfield.
    // Pour l'instant (M6), on simule les choix pour tous les modes.
    // Je retourne du vide car la logique de choix vide n'est qu'un placeholder.
    return const Expanded(
      child: Center(
        child: Text('Input libre à implémenter pour ce mode'),
      ),
    );
  }

  Widget _buildChoice(DuelArenaState arena, String choice, bool isDark) {
    final phase = arena.phase;
    final q = arena.currentQuestion!;

    // Logique de couleur en phase Reveal
    Color? bgColor;
    Color borderColor = Colors.transparent;
    Color textColor = isDark ? Colors.white : Colors.black87;

    final isMyAnswer = q.player1Answer == choice;
    final isBotAnswer = q.player2Answer == choice;
    final isCorrect = q.correctAnswer == choice;

    if (phase == ArenaPhase.reveal) {
      if (isCorrect) {
        bgColor = AppColors.correctGreen.withValues(alpha: 0.2);
        borderColor = AppColors.correctGreen;
        textColor = AppColors.correctGreen;
      } else if (isMyAnswer) {
        bgColor = AppColors.wrongRed.withValues(alpha: 0.2);
        borderColor = AppColors.wrongRed;
        textColor = AppColors.wrongRed;
      } else {
        bgColor = isDark ? AppColors.bgLevel2 : Colors.white;
        borderColor = Colors.transparent;
        textColor = Colors.grey;
      }
    } else {
      bgColor = isDark ? AppColors.bgLevel3 : Colors.white;
    }

    final oppInitials = arena.opponent?.initials ?? 'B';

    return GestureDetector(
      onTap: phase == ArenaPhase.question ? () => _onAnswerSelected(choice) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(choice,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  )),
            ),
            if (phase == ArenaPhase.reveal && isCorrect && isBotAnswer && !isMyAnswer)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.streakOrange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(oppInitials,
                    style: const TextStyle(
                        fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            if (phase == ArenaPhase.reveal && isMyAnswer)
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: textColor,
              ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgLevel2,
        title: const Text('Abandonner le duel ?', style: TextStyle(color: Colors.white)),
        content: const Text(
            'Si tu quittes maintenant, tu perdras ce duel et ton streak sera réinitialisé.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Rester', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.wrongRed,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/');
            },
            child: const Text('Abandonner', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _PlayerScorePill extends StatelessWidget {
  final String name;
  final String initials;
  final int score;
  final bool isMe;
  final bool isDark;
  final Color c1;
  final Color c2;

  const _PlayerScorePill({
    required this.name,
    required this.initials,
    required this.score,
    required this.isMe,
    required this.isDark,
    this.c1 = AppColors.primary,
    this.c2 = AppColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [c1, c2]),
      ),
      alignment: Alignment.center,
      child:
          Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );

    final scoreBlock = Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(name.split(' ').first,
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54)),
        Text('$score',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black87)),
      ],
    );

    return Row(
      children: isMe
          ? [avatar, const SizedBox(width: AppSpacing.sm), scoreBlock]
          : [scoreBlock, const SizedBox(width: AppSpacing.sm), avatar],
    );
  }
}
