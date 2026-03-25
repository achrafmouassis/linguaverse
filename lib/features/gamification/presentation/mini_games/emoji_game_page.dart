// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';
import 'package:linguaverse/features/gamification/presentation/providers/gamification_providers.dart';
import 'package:linguaverse/features/gamification/data/mock/m7_mock_data.dart';
import 'package:linguaverse/features/gamification/presentation/widgets/xp_gain_overlay.dart';
import 'package:linguaverse/features/gamification/presentation/widgets/game_result_sheet.dart';

class EmojiGamePage extends ConsumerStatefulWidget {
  const EmojiGamePage({super.key});

  @override
  ConsumerState<EmojiGamePage> createState() => _EmojiGamePageState();
}

class _EmojiGamePageState extends ConsumerState<EmojiGamePage> with TickerProviderStateMixin {
  bool _advancedMode = false;
  late Map<String, dynamic> _currentQuestion;

  final TextEditingController _inputCtrl = TextEditingController();
  bool _answered = false;
  bool _correct = false;
  int _timerSeconds = 30;
  Timer? _timer;
  int _score = 0;
  int _questionCount = 0;
  int _correctAnswers = 0;

  late AnimationController _emojiBouncCtrl;
  late AnimationController _successCtrl;
  late AnimationController _failCtrl;
  late AnimationController _timerPulseCtrl;

  @override
  void initState() {
    super.initState();
    _emojiBouncCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _successCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _failCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _timerPulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _initGame();
  }

  void _initGame() {
    _score = 0;
    _questionCount = 0;
    _correctAnswers = 0;
    _loadQuestion();
  }

  void _loadQuestion() {
    if (_questionCount >= 5) {
      _showGameResult();
      return;
    }

    _inputCtrl.clear();
    _answered = false;
    _correct = false;
    _questionCount++;

    final list = _advancedMode
        ? List<Map<String, dynamic>>.from(M7MockData.emojiCombo)
        : List<Map<String, dynamic>>.from(M7MockData.emojiSimple);

    list.shuffle();
    _currentQuestion = list.first;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timerSeconds = 30;
    _timerPulseCtrl.reset();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _timerSeconds--;
        if (_timerSeconds <= 10) _timerPulseCtrl.repeat(reverse: true);
        if (_timerSeconds <= 0) _handleTimeout();
      });
    });
  }

  void _handleTimeout() {
    _timer?.cancel();
    setState(() {
      _answered = true;
      _correct = false;
    });
    _failCtrl.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 1500), _loadQuestion);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _inputCtrl.dispose();
    _emojiBouncCtrl.dispose();
    _successCtrl.dispose();
    _failCtrl.dispose();
    _timerPulseCtrl.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_answered) return;

    final input = _inputCtrl.text.trim().toUpperCase();
    if (input.isEmpty) return;

    final answer = _currentQuestion["answer"] as String;
    final correct = input == answer;

    _timer?.cancel();
    HapticFeedback.mediumImpact();
    setState(() {
      _answered = true;
      _correct = correct;
    });

    if (correct) {
      _successCtrl.forward(from: 0);
      HapticFeedback.heavyImpact();
      const xpRewards = M7MockData.xpRewards;
      int xp = 0;
      if (_advancedMode) {
        xp = xpRewards['emoji_combo'] ?? 70;
      } else {
        xp = _timerSeconds > 20
            ? (xpRewards['emoji_simple_fast'] ?? 80)
            : (xpRewards['emoji_simple'] ?? 40);
      }
      _score += xp;
      _correctAnswers++;

      // Enregistrement de l'XP
      ref.read(addXPProvider)(
        sourceType: 'lesson_complete',
        overrideAmount: xp,
        sourceName: 'Émoji : $answer',
      );

      XPGainOverlay.show(context, xp);
      Future.delayed(const Duration(milliseconds: 1200), _loadQuestion);
    } else {
      _failCtrl.forward(from: 0);
      Future.delayed(const Duration(milliseconds: 1500), _loadQuestion);
    }
  }

  void _showGameResult() {
    final won = _correctAnswers >= 3;
    if (won) {
      final userId = ref.read(currentUserIdProvider);
      ref.read(streakServiceProvider).recordActivity(userId);
    }

    GameResultSheet.show(
      context,
      won: won,
      xpEarned: _score,
      gameName: 'Émojis',
      stats: {
        'Score': '$_correctAnswers/5',
        'Mode': _advancedMode ? 'Avancé' : 'Simple',
      },
      onReplay: () => setState(() {
        _initGame();
      }),
      onHub: () => context.pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        title: const Text('Détective Émoji',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
                color: AppColors.xpGold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Text('🌍 $_score XP',
                  style: const TextStyle(color: AppColors.xpGold, fontWeight: FontWeight.bold))
            ]),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildModeSelector(),
              const SizedBox(height: 32),
              _buildTimerBar(),
              const SizedBox(height: 16),
              Text(
                "00:${_timerSeconds.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: _timerSeconds <= 10 ? AppColors.wrongRed : Colors.white,
                ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _failCtrl,
                builder: (context, child) {
                  final shake = _answered && !_correct ? sin(_failCtrl.value * pi * 4) * 8 : 0.0;
                  return Transform.translate(offset: Offset(shake, 0), child: child);
                },
                child: _buildEmojiDisplay(),
              ),
              const SizedBox(height: 16),
              Text(
                'Indice : ${_currentQuestion["hint"]}',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const Spacer(),
              _buildInputField(),
              const SizedBox(height: 16),
              if (_answered && !_correct)
                Text(
                  'La réponse était : ${_currentQuestion["answer"]}',
                  style: TextStyle(
                      color: AppColors.wrongRed, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiDisplay() {
    final emojis = _advancedMode
        ? (_currentQuestion["emojis"] as List<String>)
        : [_currentQuestion["emoji"] as String];

    return AnimatedBuilder(
      animation: _emojiBouncCtrl,
      builder: (_, child) => Transform.scale(
        scale: 1.0 + 0.05 * sin(_emojiBouncCtrl.value * pi),
        child: child,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: emojis
            .map((emoji) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(emoji, style: const TextStyle(fontSize: 80, height: 1.2)),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTimerBar() {
    return AnimatedBuilder(
      animation: _timerPulseCtrl,
      builder: (_, __) {
        final progress = _timerSeconds / 30;
        final color = _timerSeconds > 10
            ? AppColors.correctGreen
            : Color.lerp(AppColors.wrongRed, AppColors.xpGold, _timerPulseCtrl.value) ??
                AppColors.wrongRed;

        return Container(
          height: 6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3), color: Colors.white.withValues(alpha: 0.08)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: color),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _answered
              ? (_correct
                  ? AppColors.correctGreen.withValues(alpha: 0.80)
                  : AppColors.wrongRed.withValues(alpha: 0.80))
              : Colors.white.withValues(alpha: 0.15),
          width: 2.0,
        ),
      ),
      child: TextField(
        controller: _inputCtrl,
        enabled: !_answered,
        textCapitalization: TextCapitalization.characters,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3),
        decoration: InputDecoration(
          hintText: _advancedMode ? 'Votre réponse' : 'Votre mot',
          hintStyle: const TextStyle(
              fontSize: 16, color: Colors.white38, fontWeight: FontWeight.w400, letterSpacing: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          suffixIcon: _answered
              ? Icon(_correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: _correct ? AppColors.correctGreen : AppColors.wrongRed, size: 28)
              : IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white54),
                  onPressed: _checkAnswer,
                ),
        ),
        onSubmitted: (_) => _checkAnswer(),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      children: [
        Expanded(
            child: _ModeCard(
          title: 'Simple',
          subtitle: '1 emoji → 1 mot',
          emoji: '🍎',
          selected: !_advancedMode,
          onTap: () => setState(() {
            _advancedMode = false;
            _initGame();
          }),
        )),
        const SizedBox(width: 12),
        Expanded(
            child: _ModeCard(
          title: 'Avancé',
          subtitle: 'Combinaisons',
          emoji: '🌧️☂️',
          selected: _advancedMode,
          onTap: () => setState(() {
            _advancedMode = true;
            _initGame();
          }),
        )),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const _ModeCard(
      {required this.title,
      required this.subtitle,
      required this.emoji,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.xpGold.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected ? AppColors.xpGold.withValues(alpha: 0.5) : Colors.transparent),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selected ? AppColors.xpGold : Colors.white)),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}
