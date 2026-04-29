// lib/features/quiz/views/widgets/question_cards.dart
//
// Widgets d'affichage pour chacun des 5 types de questions.

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../models/question_model.dart';

// ─────────────────────────────────────────────
// 1. QCM
// ─────────────────────────────────────────────
class MultipleChoiceCard extends StatelessWidget {
  final MultipleChoiceQuestion question;
  final String? selectedAnswer;
  final bool showFeedback;
  final void Function(String) onAnswer;

  const MultipleChoiceCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.showFeedback,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _QuestionPromptCard(
          label: 'Que signifie ce mot ?',
          child: Text(
            question.prompt,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 36,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        ...question.options.map((opt) => _OptionButton(
              label: opt,
              selected: selectedAnswer == opt,
              correct: showFeedback ? opt == question.correctAnswer : null,
              onTap: showFeedback ? null : () => onAnswer(opt),
            )),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 2. Vrai / Faux
// ─────────────────────────────────────────────
class TrueFalseCard extends StatelessWidget {
  final TrueFalseQuestion question;
  final String? selectedAnswer;
  final bool showFeedback;
  final void Function(String) onAnswer;

  const TrueFalseCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.showFeedback,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _QuestionPromptCard(
          label: 'Vrai ou Faux ?',
          child: Text(
            question.statement,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(height: 1.5, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _TFButton(
                label: '✅  Vrai',
                value: 'true',
                selected: selectedAnswer == 'true',
                correct: showFeedback
                    ? question.correctAnswer
                    : null,
                onTap: showFeedback ? null : () => onAnswer('true'),
                color: AppColors.correctGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TFButton(
                label: '❌  Faux',
                value: 'false',
                selected: selectedAnswer == 'false',
                correct: showFeedback
                    ? !question.correctAnswer
                    : null,
                onTap: showFeedback ? null : () => onAnswer('false'),
                color: AppColors.wrongRed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 3. Écouter & Choisir
// ─────────────────────────────────────────────
class ListenAndChooseCard extends StatefulWidget {
  final ListenAndChooseQuestion question;
  final String? selectedAnswer;
  final bool showFeedback;
  final void Function(String) onAnswer;

  const ListenAndChooseCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.showFeedback,
    required this.onAnswer,
  });

  @override
  State<ListenAndChooseCard> createState() => _ListenAndChooseCardState();
}

class _ListenAndChooseCardState extends State<ListenAndChooseCard> {
  late FlutterTts _tts;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    _tts = FlutterTts();

    _tts.setStartHandler(() {
      if (mounted) setState(() => _isPlaying = true);
    });

    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isPlaying = false);
    });

    _tts.setErrorHandler((msg) {
      if (mounted) setState(() => _isPlaying = false);
      debugPrint("TTS Error: $msg");
    });

    // Optionnel mais recommandé pour le web
    _tts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak() async {
    try {
      final code = _langCode();
      final isAvailable = await _tts.isLanguageAvailable(code);
      debugPrint("TTS Language $code available: $isAvailable");

      await _tts.setLanguage(code);
      await _tts.setSpeechRate(0.4);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      
      await _tts.speak(widget.question.wordToSpeak);
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  String _langCode() {
    const map = {
      'ar': 'ar-SA',
      'es': 'es-ES',
      'de': 'de-DE',
      'it': 'it-IT',
      'en': 'en-US',
      'fr': 'fr-FR',
      'tr': 'tr-TR',
    };
    return map[widget.question.languageId] ?? 'en-US';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _QuestionPromptCard(
          label: 'Écoutez et choisissez la bonne traduction',
          child: Column(
            children: [
              GestureDetector(
                onTap: _speak,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isPlaying
                        ? Colors.white
                        : Colors.white.withOpacity(0.2),
                    boxShadow: _isPlaying
                        ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 4,
                            )
                          ]
                        : [],
                  ),
                  child: Icon(
                    _isPlaying
                        ? Icons.volume_up_rounded
                        : Icons.play_arrow_rounded,
                    size: 48,
                    color: _isPlaying ? AppColors.primary : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Appuyez pour écouter',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...widget.question.options.map((opt) => _OptionButton(
              label: opt,
              selected: widget.selectedAnswer == opt,
              correct: widget.showFeedback
                  ? opt == widget.question.correctAnswer
                  : null,
              onTap: widget.showFeedback ? null : () => widget.onAnswer(opt),
            )),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 4. Compléter la phrase
// ─────────────────────────────────────────────
class FillInBlankCard extends StatelessWidget {
  final FillInBlankQuestion question;
  final String? selectedAnswer;
  final bool showFeedback;
  final void Function(String) onAnswer;

  const FillInBlankCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.showFeedback,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _QuestionPromptCard(
          label: 'Complétez la phrase',
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
              children: _buildSpans(question.sentenceWithBlank, context),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...question.options.map((opt) => _OptionButton(
              label: opt,
              selected: selectedAnswer == opt,
              correct:
                  showFeedback ? opt == question.correctAnswer : null,
              onTap: showFeedback ? null : () => onAnswer(opt),
            )),
      ],
    );
  }

  List<InlineSpan> _buildSpans(String sentence, BuildContext ctx) {
    final parts = sentence.split('___');
    if (parts.length < 2) {
      return [TextSpan(text: sentence)];
    }
    return [
      TextSpan(text: parts[0]),
      WidgetSpan(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(
            border: Border(
                bottom: const BorderSide(color: Colors.white, width: 2)),
          ),
          child: Text(
            selectedAnswer ?? '  ?  ',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
      ),
      TextSpan(text: parts[1]),
    ];
  }
}

// ─────────────────────────────────────────────
// 5. Matching
// ─────────────────────────────────────────────
class MatchingCard extends StatefulWidget {
  final MatchingQuestion question;
  final bool showFeedback;
  final void Function(List<String>) onSubmit;

  const MatchingCard({
    super.key,
    required this.question,
    required this.showFeedback,
    required this.onSubmit,
  });

  @override
  State<MatchingCard> createState() => _MatchingCardState();
}

class _MatchingCardState extends State<MatchingCard> {
  late List<String> _translations;
  String? _selectedTerm;
  final Map<String, String> _matched = {};

  @override
  void initState() {
    super.initState();
    _translations =
        widget.question.pairs.map((p) => p.translation).toList();
    _translations.shuffle();
  }

  void _onTermTap(String term) {
    if (widget.showFeedback) return;
    setState(() => _selectedTerm = term == _selectedTerm ? null : term);
  }

  void _onTranslationTap(String translation) {
    if (widget.showFeedback || _selectedTerm == null) return;
    setState(() {
      _matched[_selectedTerm!] = translation;
      _selectedTerm = null;
    });
    if (_matched.length == widget.question.pairs.length) {
      // Build ordered list matching correctPairs terms order
      final order = widget.question.correctPairs
          .map((p) => _matched[p.term] ?? '')
          .toList();
      widget.onSubmit(order);
    }
  }

  bool _isTermMatched(String term) => _matched.containsKey(term);
  bool _isTranslationUsed(String t) => _matched.values.contains(t);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _QuestionPromptCard(
          label: 'Associez chaque mot à sa traduction',
          child: Column(
            children: [
              Text(
                widget.question.prompt,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Sélectionnez un élément à gauche puis son équivalent à droite',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontStyle: FontStyle.italic, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colonne gauche : mots cibles
            Expanded(
              child: Column(
                children: widget.question.pairs.map((pair) {
                  final isSelected = _selectedTerm == pair.term;
                  final isMatched = _isTermMatched(pair.term);
                  return _MatchChip(
                    label: pair.term,
                    isSelected: isSelected,
                    isMatched: isMatched,
                    onTap: isMatched ? null : () => _onTermTap(pair.term),
                    color: AppColors.primary,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 8),
            // Colonne droite : traductions
            Expanded(
              child: Column(
                children: _translations.map((t) {
                  final isUsed = _isTranslationUsed(t);
                  return _MatchChip(
                    label: t,
                    isSelected: false,
                    isMatched: isUsed,
                    onTap: isUsed ? null : () => _onTranslationTap(t),
                    color: AppColors.secondary,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        if (_matched.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _matched.entries
                .map((e) => Chip(
                      label: Text('${e.key} → ${e.value}',
                          style: const TextStyle(fontSize: 12)),
                      backgroundColor: AppColors.primaryLight,
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Shared sub-widgets
// ─────────────────────────────────────────────

class _QuestionPromptCard extends StatelessWidget {
  final String label;
  final Widget child;
  const _QuestionPromptCard({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A56DB), Color(0xFF0E7490)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final bool selected;
  final bool? correct; // null = pas de feedback
  final VoidCallback? onTap;

  const _OptionButton({
    required this.label,
    required this.selected,
    required this.correct,
    required this.onTap,
  });

  Color _bg() {
    if (correct == true) return const Color(0xFFECFDF5);
    if (correct == false && selected) return const Color(0xFFFEF2F2);
    if (selected) return AppColors.primaryLight;
    return Colors.white;
  }

  Color _border() {
    if (correct == true) return AppColors.correctGreen;
    if (correct == false && selected) return AppColors.wrongRed;
    if (selected) return AppColors.primary;
    return AppColors.outline;
  }

  Color _textColor() {
    if (correct == true) return AppColors.correctGreen;
    if (correct == false && selected) return AppColors.wrongRed;
    if (selected) return AppColors.primary;
    return AppColors.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _bg(),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border(), width: 1.5),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: _border().withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]
              : [],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: _textColor(),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            if (correct == true)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.correctGreen, size: 20)
            else if (correct == false && selected)
              const Icon(Icons.cancel_rounded,
                  color: AppColors.wrongRed, size: 20),
          ],
        ),
      ),
    );
  }
}

class _TFButton extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final bool? correct;
  final VoidCallback? onTap;
  final Color color;

  const _TFButton({
    required this.label,
    required this.value,
    required this.selected,
    required this.correct,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color border = AppColors.outline;
    if (correct == true) {
      bg = const Color(0xFFECFDF5);
      border = AppColors.correctGreen;
    } else if (correct == false && selected) {
      bg = const Color(0xFFFEF2F2);
      border = AppColors.wrongRed;
    } else if (selected) {
      bg = color.withOpacity(0.1);
      border = color;
    }
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 2),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: selected ? color : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _MatchChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isMatched;
  final VoidCallback? onTap;
  final Color color;

  const _MatchChip({
    required this.label,
    required this.isSelected,
    required this.isMatched,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isMatched
              ? Colors.grey.shade100
              : isSelected
                  ? color.withOpacity(0.15)
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isMatched
                ? Colors.grey.shade300
                : isSelected
                    ? color
                    : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isMatched
                ? Colors.grey
                : isSelected
                    ? color
                    : AppColors.textPrimary,
            decoration: isMatched ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}
