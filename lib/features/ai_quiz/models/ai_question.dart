/// Modèle de données pour les questions générées par l'IA.
///
/// Structure immutable qui correspond au format JSON retourné par Claude :
/// ```json
/// { "type": "mcq", "question": "...", "choices": [...], "answer": "...", "explanation": "..." }
/// ```

class AiQuestion {
  final String type;
  final String question;
  final List<String> choices;
  final String answer;
  final String explanation;

  const AiQuestion({
    required this.type,
    required this.question,
    required this.choices,
    required this.answer,
    required this.explanation,
  });

  /// Désérialise depuis le JSON retourné par Claude.
  factory AiQuestion.fromJson(Map<String, dynamic> json) {
    return AiQuestion(
      type: json['type'] as String? ?? 'mcq',
      question: json['question'] as String? ?? '',
      choices: (json['choices'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      answer: json['answer'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
    );
  }

  /// Sérialise vers JSON (utile pour la sauvegarde locale).
  Map<String, dynamic> toJson() => {
        'type': type,
        'question': question,
        'choices': choices,
        'answer': answer,
        'explanation': explanation,
      };

  /// Crée une copie modifiée (pour l'édition dans la preview).
  AiQuestion copyWith({
    String? type,
    String? question,
    List<String>? choices,
    String? answer,
    String? explanation,
  }) {
    return AiQuestion(
      type: type ?? this.type,
      question: question ?? this.question,
      choices: choices ?? this.choices,
      answer: answer ?? this.answer,
      explanation: explanation ?? this.explanation,
    );
  }

  @override
  String toString() =>
      'AiQuestion(type: $type, question: $question, answer: $answer)';
}

/// Les différentes étapes de génération du quiz IA.
enum AiQuizPhase {
  /// Écran initial — l'utilisateur n'a encore rien fait.
  initial,

  /// L'utilisateur sélectionne un fichier PDF.
  pickingFile,

  /// ML Kit extrait le texte du PDF.
  extracting,

  /// Claude génère les questions.
  generating,

  /// Les questions sont prêtes et affichées dans la preview.
  ready,

  /// Une erreur s'est produite.
  error,
}

/// État complet du module AI Quiz.
class AiQuizState {
  final AiQuizPhase phase;
  final String? sourceText;
  final List<AiQuestion> questions;
  final String? errorMessage;
  final int remainingQuota;
  final double progress;

  const AiQuizState({
    this.phase = AiQuizPhase.initial,
    this.sourceText,
    this.questions = const [],
    this.errorMessage,
    this.remainingQuota = 5,
    this.progress = 0.0,
  });

  bool get isLoading =>
      phase == AiQuizPhase.extracting || phase == AiQuizPhase.generating;

  bool get hasQuestions => questions.isNotEmpty;

  String get phaseLabel {
    switch (phase) {
      case AiQuizPhase.initial:
        return 'Prêt';
      case AiQuizPhase.pickingFile:
        return 'Sélection du fichier…';
      case AiQuizPhase.extracting:
        return 'Extraction du texte…';
      case AiQuizPhase.generating:
        return 'Génération des questions…';
      case AiQuizPhase.ready:
        return 'Questions prêtes !';
      case AiQuizPhase.error:
        return 'Erreur';
    }
  }

  AiQuizState copyWith({
    AiQuizPhase? phase,
    String? sourceText,
    List<AiQuestion>? questions,
    String? errorMessage,
    int? remainingQuota,
    double? progress,
  }) {
    return AiQuizState(
      phase: phase ?? this.phase,
      sourceText: sourceText ?? this.sourceText,
      questions: questions ?? this.questions,
      errorMessage: errorMessage,
      remainingQuota: remainingQuota ?? this.remainingQuota,
      progress: progress ?? this.progress,
    );
  }
}
