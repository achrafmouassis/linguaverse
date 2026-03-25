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

class SynonymGamePage extends ConsumerStatefulWidget {
  const SynonymGamePage({super.key});

  @override
  ConsumerState<SynonymGamePage> createState() => _SynonymGamePageState();
}

class _SynonymGamePageState extends ConsumerState<SynonymGamePage> with TickerProviderStateMixin {
  late Map<String, dynamic> _currentPair;
  bool _synonymMode = true;
  int _streak = 0;
  int _score = 0;
  int _questionIndex = 0;

  List<String> _options = [];
  String? _selectedAnswer;
  String? _correctAnswer;
  bool _answered = false;
  int _correctAnswers = 0;

  late AnimationController _correctPulseCtrl;
  late AnimationController _wrongShakeCtrl;
  late AnimationController _streakFireCtrl;

  @override
  void initState() {
    super.initState();
    _correctPulseCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _wrongShakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _streakFireCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _initGame();
  }

  void _initGame() {
    _streak = 0;
    _score = 0;
    _questionIndex = 0;
    _correctAnswers = 0;
    _nextQuestion();
  }

  @override
  void dispose() {
    _correctPulseCtrl.dispose();
    _wrongShakeCtrl.dispose();
    _streakFireCtrl.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    if (_questionIndex >= 10) {
      _showGameResult();
      return;
    }
    setState(() {
      _questionIndex++;
      final list = List<Map<String, dynamic>>.from(M7MockData.synonymPairs)..shuffle();
      _currentPair = list.first;
      _generateOptions();
    });
  }

  void _generateOptions() {
    final allWords = M7MockData.synonymPairs
        .expand((p) => [...p['synonyms'], ...p['antonyms']])
        .toSet()
        .toList();

    final correct = _synonymMode
        ? _currentPair['synonyms'][0] as String
        : _currentPair['antonyms'][0] as String;
    final distractors = allWords.where((w) => w != correct).toList()..shuffle();

    _options = [correct, ...distractors.take(3)]..shuffle();
    _correctAnswer = correct;
    _selectedAnswer = null;
    _answered = false;
  }

  void _answer(String choice) {
    if (_answered) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedAnswer = choice;
      _answered = true;
    });

    if (choice == _correctAnswer) {
      setState(() {
        _streak++;
        _score += 30;
        _correctAnswers++;
      });
      _correctPulseCtrl.forward(from: 0);
      if (_streak >= 5) _streakFireCtrl.forward(from: 0);
      HapticFeedback.heavyImpact();

      if (_streak == 5) {
        final streakXP = M7MockData.xpRewards['synonym_streak_5'] ?? 100;
        ref.read(addXPProvider)(
          sourceType: 'streak_bonus',
          overrideAmount: streakXP,
          sourceName: 'Série de 5 Synonymes',
        );
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) XPGainOverlay.show(context, streakXP);
        });
      }

      Future.delayed(const Duration(milliseconds: 800), _nextQuestion);
    } else {
      setState(() {
        _streak = 0;
      });
      _wrongShakeCtrl.forward(from: 0);
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 1200), _nextQuestion);
    }
  }

  void _showGameResult() {
    final won = _correctAnswers >= 5;
    if (won) {
      final userId = ref.read(currentUserIdProvider);
      ref.read(streakServiceProvider).recordActivity(userId);
      ref.read(addXPProvider)(
        sourceType: 'lesson_complete',
        overrideAmount: _score,
        sourceName: 'Session Synonymes',
      );
    }

    GameResultSheet.show(
      context,
      won: won,
      xpEarned: _score,
      gameName: 'Synonymes',
      stats: {
        'Correctes': '$_correctAnswers/10',
        'Meilleure Série': '$_streak',
        'Mode': _synonymMode ? 'Synonymes' : 'Antonymes',
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
        title:
            const Text('Mots croisés', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Text('🔥 $_streak',
                  style: const TextStyle(color: AppColors.tertiary, fontWeight: FontWeight.bold))
            ]),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildModeToggle(),
              const Spacer(flex: 1),
              Text('Trouvez le ${_synonymMode ? "synonyme" : "contraire"} de :',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.white70)),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _wrongShakeCtrl,
                builder: (context, child) {
                  final shake = _answered && _selectedAnswer != _correctAnswer
                      ? sin(_wrongShakeCtrl.value * pi * 4) * 8
                      : 0.0;
                  return Transform.translate(offset: Offset(shake, 0), child: child);
                },
                child: Text(
                  _currentPair['word'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
              const Spacer(flex: 2),
              ..._options.map((opt) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _buildAnswerButton(opt),
                  )),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: _TogglePill(
                  'Synonymes',
                  _synonymMode,
                  () => setState(() {
                        _synonymMode = true;
                        _initGame();
                      }))),
          Expanded(
              child: _TogglePill(
                  'Antonymes',
                  !_synonymMode,
                  () => setState(() {
                        _synonymMode = false;
                        _initGame();
                      }))),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(String option) {
    final isSelected = _selectedAnswer == option;
    final isCorrect = option == _correctAnswer;

    Color bgColor = Colors.white.withValues(alpha: 0.03);
    Color borderColor = Colors.white.withValues(alpha: 0.06);

    if (_answered) {
      if (isCorrect) {
        bgColor = AppColors.correctGreen.withValues(alpha: 0.20);
        borderColor = AppColors.correctGreen.withValues(alpha: 0.60);
      } else if (isSelected) {
        bgColor = AppColors.wrongRed.withValues(alpha: 0.20);
        borderColor = AppColors.wrongRed.withValues(alpha: 0.60);
      }
    }

    return GestureDetector(
      onTap: () => _answer(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(option,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white))),
            if (_answered && isCorrect)
              const Icon(Icons.check_circle_rounded, color: AppColors.correctGreen, size: 24),
            if (_answered && isSelected && !isCorrect)
              const Icon(Icons.cancel_rounded, color: AppColors.wrongRed, size: 24),
          ],
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TogglePill(this.text, this.isSelected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.tertiary : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}
