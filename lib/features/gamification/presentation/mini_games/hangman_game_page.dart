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

class HangmanGamePage extends ConsumerStatefulWidget {
  const HangmanGamePage({super.key});

  @override
  ConsumerState<HangmanGamePage> createState() => _HangmanGamePageState();
}

class _HangmanGamePageState extends ConsumerState<HangmanGamePage> with TickerProviderStateMixin {
  late Map<String, dynamic> _currentWord;
  static const int maxErrors = 6;
  int _errors = 0;
  final Set<String> _guessedLetters = {};
  bool _gameOver = false;
  bool _won = false;

  late AnimationController _wrongShakeCtrl;
  late AnimationController _drawHangmanCtrl;
  late AnimationController _revealLetterCtrl;

  @override
  void initState() {
    super.initState();
    _wrongShakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _drawHangmanCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _revealLetterCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _initGame();
  }

  void _initGame() {
    final list = List<Map<String, dynamic>>.from(M7MockData.hangmanWords['Anglais'] ?? []);
    list.shuffle();
    _currentWord = list.first;
    _errors = 0;
    _guessedLetters.clear();
    _gameOver = false;
    _won = false;
    _drawHangmanCtrl.reset();
  }

  @override
  void dispose() {
    _wrongShakeCtrl.dispose();
    _drawHangmanCtrl.dispose();
    _revealLetterCtrl.dispose();
    super.dispose();
  }

  void _guessLetter(String letter) {
    if (_gameOver) return;
    HapticFeedback.selectionClick();
    setState(() => _guessedLetters.add(letter));

    final word = _currentWord['word'] as String;
    if (!word.contains(letter)) {
      setState(() => _errors++);
      _wrongShakeCtrl.forward(from: 0);
      _drawHangmanCtrl.forward(from: 0);
      if (_errors >= maxErrors) _handleLoss();
    } else {
      _revealLetterCtrl.forward(from: 0);
      HapticFeedback.heavyImpact();
      if (word.split('').every((l) => _guessedLetters.contains(l))) {
        _handleWin();
      }
    }
  }

  void _handleWin() {
    setState(() {
      _gameOver = true;
      _won = true;
    });
    HapticFeedback.heavyImpact();

    final xp = _errors == 0
        ? M7MockData.xpRewards['hangman_win_0err'] ?? 120
        : M7MockData.xpRewards['hangman_win'] ?? 60;

    // Enregistrement de la progression réelle
    final userId = ref.read(currentUserIdProvider);
    ref.read(streakServiceProvider).recordActivity(userId);
    ref.read(addXPProvider)(
      sourceType: 'lesson_complete',
      overrideAmount: xp,
      sourceName: 'Pendu : ${_currentWord['word']}',
      language: 'Anglais',
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      XPGainOverlay.show(context, xp);
      Future.delayed(const Duration(milliseconds: 1000), _showGameResult);
    });
  }

  void _handleLoss() {
    setState(() {
      _gameOver = true;
      _won = false;
    });
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 1500), _showGameResult);
  }

  void _showGameResult() {
    final xpEarned = _won
        ? (_errors == 0
            ? (M7MockData.xpRewards['hangman_win_0err'] ?? 120)
            : (M7MockData.xpRewards['hangman_win'] ?? 60))
        : 0;

    GameResultSheet.show(
      context,
      won: _won,
      xpEarned: xpEarned,
      gameName: 'Pendu',
      stats: {
        'Erreurs': '$_errors/6',
        'Catégorie': _currentWord['category'] as String,
        'Mot entier': _currentWord['word'] as String,
      },
      onReplay: () => setState(() {
        _initGame();
      }),
      onHub: () => context.pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.bgScaffold,
      appBar: AppBar(
        title: const Text('Le Pendu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Text('🎭 +120',
                  style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold))
            ]),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Catégorie ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: Text(
                'Catégorie : ${_currentWord["category"]}',
                style: const TextStyle(
                    fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ),
            // ── Pendu & mot ─────────────────────────────────────────
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _wrongShakeCtrl,
                    builder: (context, child) {
                      final shake = !_gameOver ? sin(_wrongShakeCtrl.value * pi * 4) * 10 : 0.0;
                      return Transform.translate(offset: Offset(shake, 0), child: child);
                    },
                    child: SizedBox(
                      height: 180,
                      width: 180,
                      child: CustomPaint(
                        painter: _HangmanPainter(
                          errors: _errors,
                          animationValue: _drawHangmanCtrl.value,
                          isDark: isDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildWordDisplay(),
                ],
              ),
            ),
            // ── Clavier ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: _buildAlphabetKeyboard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordDisplay() {
    final word = _currentWord['word'] as String;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: word.split('').map((letter) {
        final revealed = _guessedLetters.contains(letter) || _gameOver;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 32,
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: revealed ? AppColors.correctGreen : Colors.white.withValues(alpha: 0.30),
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: revealed ? 28 : 0,
                fontWeight: FontWeight.w800,
                color: revealed && !_won && _gameOver ? AppColors.wrongRed : Colors.white,
              ),
              child: Text(revealed ? letter : ''),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAlphabetKeyboard() {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final word = _currentWord['word'] as String;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 10,
      children: alphabet.split('').map((letter) {
        final isGuessed = _guessedLetters.contains(letter);
        final isCorrect = word.contains(letter);

        return GestureDetector(
          onTap: isGuessed || _gameOver ? null : () => _guessLetter(letter),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 48,
            decoration: BoxDecoration(
              color: isGuessed
                  ? (isCorrect
                      ? AppColors.correctGreen.withValues(alpha: 0.25)
                      : AppColors.wrongRed.withValues(alpha: 0.20))
                  : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isGuessed
                    ? (isCorrect
                        ? AppColors.correctGreen.withValues(alpha: 0.50)
                        : AppColors.wrongRed.withValues(alpha: 0.40))
                    : Colors.white.withValues(alpha: 0.12),
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isGuessed
                      ? (isCorrect ? AppColors.correctGreen : AppColors.wrongRed)
                      : Colors.white,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HangmanPainter extends CustomPainter {
  final int errors;
  final double animationValue;
  final bool isDark;

  const _HangmanPainter({
    required this.errors,
    required this.animationValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? Colors.white.withValues(alpha: 0.70) : Colors.black.withValues(alpha: 0.70)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final errorPaint = Paint()
      ..color = AppColors.wrongRed.withValues(alpha: 0.80)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(20, 200), const Offset(140, 200), paint);
    canvas.drawLine(const Offset(50, 200), const Offset(50, 30), paint);
    canvas.drawLine(const Offset(50, 30), const Offset(120, 30), paint);
    canvas.drawLine(const Offset(120, 30), const Offset(120, 50), paint);

    if (errors >= 1) {
      canvas.drawCircle(const Offset(120, 70), 20, errorPaint);
    }
    if (errors >= 2) {
      canvas.drawLine(const Offset(120, 90), const Offset(120, 140), errorPaint);
    }
    if (errors >= 3) {
      canvas.drawLine(const Offset(120, 100), const Offset(90, 125), errorPaint);
    }
    if (errors >= 4) {
      canvas.drawLine(const Offset(120, 100), const Offset(150, 125), errorPaint);
    }
    if (errors >= 5) {
      canvas.drawLine(const Offset(120, 140), const Offset(95, 175), errorPaint);
    }
    if (errors >= 6) {
      canvas.drawLine(const Offset(120, 140), const Offset(145, 175), errorPaint);
      canvas.drawLine(const Offset(112, 62), const Offset(118, 68), errorPaint);
      canvas.drawLine(const Offset(118, 62), const Offset(112, 68), errorPaint);
      canvas.drawLine(const Offset(122, 62), const Offset(128, 68), errorPaint);
      canvas.drawLine(const Offset(128, 62), const Offset(122, 68), errorPaint);
    }
  }

  @override
  bool shouldRepaint(_HangmanPainter old) =>
      old.errors != errors || old.animationValue != animationValue;
}
