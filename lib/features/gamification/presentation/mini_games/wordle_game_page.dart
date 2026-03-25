// ignore_for_file: curly_braces_in_flow_control_structures
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

enum LetterState { empty, absent, present, correct }

class WordleGamePage extends ConsumerStatefulWidget {
  const WordleGamePage({super.key});

  @override
  ConsumerState<WordleGamePage> createState() => _WordleGamePageState();
}

class _WordleGamePageState extends ConsumerState<WordleGamePage> with TickerProviderStateMixin {
  late Map<String, dynamic> _currentWord;

  List<List<String>> _grid = List.generate(6, (_) => List.filled(5, ''));
  List<List<LetterState>> _states = List.generate(6, (_) => List.filled(5, LetterState.empty));
  int _currentRow = 0;
  int _currentCol = 0;
  bool _gameOver = false;
  bool _won = false;
  final Map<String, LetterState> _usedLetters = {};

  late AnimationController _shakeController;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _initGame();
    _shakeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _bounceController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
  }

  void _initGame() {
    final list = List<Map<String, dynamic>>.from(M7MockData.wordleWords['Arabe'] ?? []);
    list.shuffle();
    _currentWord = list.first;
    _grid = List.generate(6, (_) => List.filled(5, ''));
    _states = List.generate(6, (_) => List.filled(5, LetterState.empty));
    _currentRow = 0;
    _currentCol = 0;
    _gameOver = false;
    _won = false;
    _usedLetters.clear();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  static Color _stateColor(LetterState s, bool isDark) {
    switch (s) {
      case LetterState.correct:
        return AppColors.correctGreen;
      case LetterState.present:
        return AppColors.xpGold;
      case LetterState.absent:
        return isDark ? Colors.white.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.20);
      case LetterState.empty:
        return Colors.transparent;
    }
  }

  LetterState _bestState(LetterState a, LetterState b) {
    if (a == LetterState.correct || b == LetterState.correct) return LetterState.correct;
    if (a == LetterState.present || b == LetterState.present) return LetterState.present;
    if (a == LetterState.absent || b == LetterState.absent) return LetterState.absent;
    return LetterState.empty;
  }

  void _addLetter(String key) {
    if (_gameOver || _currentRow >= 6) return;
    if (_currentCol < 5) {
      setState(() {
        _grid[_currentRow][_currentCol] = key;
        _currentCol++;
      });
      HapticFeedback.selectionClick();
    }
  }

  void _deleteLetter() {
    if (_gameOver || _currentRow >= 6) return;
    if (_currentCol > 0) {
      setState(() {
        _currentCol--;
        _grid[_currentRow][_currentCol] = '';
      });
      HapticFeedback.selectionClick();
    }
  }

  void _submitGuess() {
    if (_currentCol < 5) {
      _shakeController.forward(from: 0);
      HapticFeedback.heavyImpact();
      return;
    }

    final guess = _grid[_currentRow].join();
    final target = _currentWord['word'] as String;
    final newStates = List<LetterState>.filled(5, LetterState.absent);

    for (int i = 0; i < 5; i++) {
      if (guess[i] == target[i]) {
        newStates[i] = LetterState.correct;
      }
    }
    for (int i = 0; i < 5; i++) {
      if (newStates[i] == LetterState.correct) continue;
      if (target.contains(guess[i])) {
        newStates[i] = LetterState.present;
      }
    }

    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (!mounted) return;
        setState(() {
          _states[_currentRow][i] = newStates[i];
          _usedLetters[guess[i]] =
              _bestState(_usedLetters[guess[i]] ?? LetterState.absent, newStates[i]);
        });
        HapticFeedback.selectionClick();
      });
    }

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      if (guess == target) {
        _handleWin();
      } else if (_currentRow == 5) {
        _handleLoss();
      } else {
        setState(() {
          _currentRow++;
          _currentCol = 0;
        });
      }
    });
  }

  void _handleWin() {
    setState(() {
      _gameOver = true;
      _won = true;
    });
    _bounceController.forward();
    HapticFeedback.heavyImpact();

    final xpKey = 'wordle_win_${_currentRow + 1}';
    final xp = M7MockData.xpRewards[xpKey] ?? 40;

    // Enregistrement de la progression réelle
    final userId = ref.read(currentUserIdProvider);
    ref.read(streakServiceProvider).recordActivity(userId);
    ref.read(addXPProvider)(
      sourceType: 'lesson_complete',
      overrideAmount: xp,
      sourceName: 'Wordle : ${_currentWord['word']}',
      language: 'Arabe',
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      XPGainOverlay.show(context, xp);
      Future.delayed(const Duration(milliseconds: 800), _showGameResult);
    });
  }

  void _handleLoss() {
    setState(() {
      _gameOver = true;
      _won = false;
    });
    _shakeController.forward(from: 0);
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 600), _showGameResult);
  }

  void _showGameResult() {
    final xpKey = 'wordle_win_${_currentRow + 1}';
    final xpEarned = _won ? (M7MockData.xpRewards[xpKey] ?? 40) : 0;

    GameResultSheet.show(
      context,
      won: _won,
      xpEarned: xpEarned,
      gameName: 'Wordle',
      stats: {
        'Essais': _won ? '${_currentRow + 1}/6' : 'X/6',
        'Mot': _currentWord['word'] as String,
        'Traduction': _currentWord['translation'] as String,
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
        title: const Text('Wordle — Arabe',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
                color: AppColors.xpGold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Text('🔥 +150',
                  style: TextStyle(color: AppColors.xpGold, fontWeight: FontWeight.bold))
            ]),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Indice: ${_currentWord["hint"]}',
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Essai ${min(_currentRow + 1, 6)}/6',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(child: Center(child: _buildGrid())),
            const SizedBox(height: 8),
            _buildKeyboard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(6, (row) {
        final isCurrentRow = row == _currentRow;
        return AnimatedBuilder(
          animation: _shakeController,
          builder: (_, child) {
            final shake =
                isCurrentRow && !_gameOver ? sin(_shakeController.value * pi * 6) * 8 : 0.0;
            return Transform.translate(offset: Offset(shake, 0), child: child);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (col) => _buildCell(row, col)),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCell(int row, int col) {
    final letter = _grid[row][col];
    final state = _states[row][col];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = row == _currentRow;
    final isFilled = letter.isNotEmpty;

    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        double offset = 0.0;
        if (_won && row == _currentRow) {
          final delay = col * 0.1;
          final time = (_bounceController.value - delay) * 2;
          if (time > 0 && time < 1) {
            offset = -sin(time * pi) * 15;
          }
        }
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        width: 52,
        height: 52,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        // ignore: deprecated_member_use
        transform: Matrix4.identity()..scale(isFilled && isActive ? 1.08 : 1.0),
        decoration: BoxDecoration(
          color: _stateColor(state, isDark),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: state == LetterState.empty
                ? (isActive && isFilled ? AppColors.primary : Colors.white.withValues(alpha: 0.15))
                : Colors.transparent,
            width: isActive && isFilled ? 2.0 : 0.5,
          ),
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    const rows = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['⌫', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '↵'],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows
          .map((row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((key) {
                    final state = _usedLetters[key] ?? LetterState.empty;
                    final isSpecial = key == '⌫' || key == '↵';
                    final isDark = Theme.of(context).brightness == Brightness.dark;

                    return Expanded(
                      flex: isSpecial ? 2 : 1,
                      child: GestureDetector(
                        onTap: () {
                          if (key == '⌫') {
                            _deleteLetter();
                          } else if (key == '↵')
                            _submitGuess();
                          else
                            _addLetter(key);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSpecial
                                ? AppColors.primary.withValues(alpha: 0.50)
                                : _stateColor(state, isDark)
                                    .withValues(alpha: state == LetterState.empty ? 0.12 : 0.85),
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.white.withValues(alpha: 0.10), width: 0.5),
                          ),
                          child: Center(
                            child: Text(
                              key,
                              style: TextStyle(
                                  fontSize: isSpecial ? 16 : 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ))
          .toList(),
    );
  }
}
