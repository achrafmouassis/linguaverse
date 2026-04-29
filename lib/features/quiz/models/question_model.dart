// lib/features/quiz/models/question_model.dart
import '../../lessons/data/lesson_content_data.dart';

// ─────────────────────────────────────────────
// Enum des types de questions
// ─────────────────────────────────────────────
enum QuestionType {
  multipleChoice,   // QCM
  trueFalse,        // Vrai / Faux
  listenAndChoose,  // Écouter & Choisir (TTS)
  fillInBlank,      // Compléter la phrase
  matching,         // Association (drag & drop)
}

// ─────────────────────────────────────────────
// Classe de base abstraite
// ─────────────────────────────────────────────
abstract class Question {
  final String id;
  final QuestionType type;
  final LessonItem sourceItem; // mot source de la leçon
  final String languageId;
  final String categoryId;

  const Question({
    required this.id,
    required this.type,
    required this.sourceItem,
    required this.languageId,
    required this.categoryId,
  });
}

// ─────────────────────────────────────────────
// 1. QCM — Choix multiple
// ─────────────────────────────────────────────
class MultipleChoiceQuestion extends Question {
  /// Le mot dans la langue cible affiché à l'utilisateur
  final String prompt;

  /// Les 4 options (1 correcte + 3 distracteurs), ordre mélangé
  final List<String> options;

  /// La réponse correcte (translation)
  final String correctAnswer;

  /// Explication affichée après réponse
  final String explanation;

  const MultipleChoiceQuestion({
    required super.id,
    required super.sourceItem,
    required super.languageId,
    required super.categoryId,
    required this.prompt,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  }) : super(type: QuestionType.multipleChoice);
}

// ─────────────────────────────────────────────
// 2. Vrai / Faux
// ─────────────────────────────────────────────
class TrueFalseQuestion extends Question {
  /// Phrase affichée : "X signifie Y ?"
  final String statement;

  /// La réponse attendue
  final bool correctAnswer;

  /// Explication affichée après réponse
  final String explanation;

  const TrueFalseQuestion({
    required super.id,
    required super.sourceItem,
    required super.languageId,
    required super.categoryId,
    required this.statement,
    required this.correctAnswer,
    required this.explanation,
  }) : super(type: QuestionType.trueFalse);
}

// ─────────────────────────────────────────────
// 3. Écouter & Choisir (TTS)
// ─────────────────────────────────────────────
class ListenAndChooseQuestion extends Question {
  /// Texte à prononcer via TTS
  final String wordToSpeak;

  /// 4 options (traductions possibles)
  final List<String> options;

  /// La réponse correcte
  final String correctAnswer;

  const ListenAndChooseQuestion({
    required super.id,
    required super.sourceItem,
    required super.languageId,
    required super.categoryId,
    required this.wordToSpeak,
    required this.options,
    required this.correctAnswer,
  }) : super(type: QuestionType.listenAndChoose);
}

// ─────────────────────────────────────────────
// 4. Compléter la phrase
// ─────────────────────────────────────────────
class FillInBlankQuestion extends Question {
  /// Phrase avec "___" à la place du mot manquant
  final String sentenceWithBlank;

  /// 4 options possibles
  final List<String> options;

  /// Le mot correct qui complète la phrase
  final String correctAnswer;

  /// La phrase complète (pour l'explication)
  final String fullSentence;

  const FillInBlankQuestion({
    required super.id,
    required super.sourceItem,
    required super.languageId,
    required super.categoryId,
    required this.sentenceWithBlank,
    required this.options,
    required this.correctAnswer,
    required this.fullSentence,
  }) : super(type: QuestionType.fillInBlank);
}

// ─────────────────────────────────────────────
// 5. Matching — Association
// ─────────────────────────────────────────────
class MatchingPair {
  final String term;        // Mot cible
  final String translation; // Traduction française
  const MatchingPair({required this.term, required this.translation});
}

class MatchingQuestion extends Question {
  /// Enoncé affiché au-dessus de l'exercice d'association
  final String prompt;

  /// Paires à associer (4 paires mélangées)
  final List<MatchingPair> pairs;

  /// Paires dans l'ordre correct pour validation
  final List<MatchingPair> correctPairs;

  const MatchingQuestion({
    required super.id,
    required super.sourceItem,
    required super.languageId,
    required super.categoryId,
    required this.prompt,
    required this.pairs,
    required this.correctPairs,
  }) : super(type: QuestionType.matching);
}
