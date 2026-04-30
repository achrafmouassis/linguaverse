// ════════════════════════════════════════════════════════════════
// DONNÉES PROVISOIRES — MODULE M8 IA QUIZ
// ════════════════════════════════════════════════════════════════
// SOURCE RÉELLE : Claude API → POST /v1/messages
// POUR REMPLACER : AIQuizService.generateQuestions(userId, language, level)
// ════════════════════════════════════════════════════════════════

class M8MockData {
  /// Questions de secours (si Claude API indisponible ou quota atteint)
  static const Map<String, List<Map<String, dynamic>>> fallbackQuestions = {
    'Arabe': [
      {
        'question': 'Complète la phrase : "أنا _____ من المغرب"',
        'type': 'fill_blank',
        'correct': 'قادم',
        'choices': ['قادم', 'ذاهب', 'آتٍ', 'راجع'],
        'explanation': '"قادم" signifie "venant de" — utilisé pour l\'origine',
        'difficulty': 2,
      },
      {
        'question': 'Quelle est la forme plurielle de "كتاب" ?',
        'type': 'qcm',
        'correct': 'كتب',
        'choices': ['كتب', 'كتابات', 'أكتاب', 'كتابون'],
        'explanation': 'Le pluriel brisé de كتاب est كتب',
        'difficulty': 3,
      },
      {
        'question': 'Traduire : "Le professeur enseigne les élèves"',
        'type': 'translation',
        'correct': 'يُعلِّم الأستاذ الطلاب',
        'choices': [
          'يُعلِّم الأستاذ الطلاب',
          'الطلاب يدرسون مع الأستاذ',
          'يعمل الأستاذ في المدرسة',
          'يقرأ الأستاذ الكتاب',
        ],
        'explanation': 'Structure VSO : Verbe + Sujet + Objet en arabe',
        'difficulty': 3,
      },
      {
        'question': 'Quel mot signifie "demain" ?',
        'type': 'qcm',
        'correct': 'غداً',
        'choices': ['غداً', 'اليوم', 'أمس', 'الآن'],
        'explanation': 'غداً = demain, اليوم = aujourd\'hui, أمس = hier',
        'difficulty': 1,
      },
      {
        'question': 'Comment dit-on "je comprends" ?',
        'type': 'qcm',
        'correct': 'أفهم',
        'choices': ['أفهم', 'أعرف', 'أعلم', 'أدرك'],
        'explanation': 'فهم = comprendre, أفهم = je comprends',
        'difficulty': 2,
      },
    ],
    'Français': [
      {
        'question': 'Conjuguez "aller" au futur simple (1re personne)',
        'type': 'fill_blank',
        'correct': 'irai',
        'choices': ['irai', 'allera', 'iras', 'allerai'],
        'explanation': 'Futur irrégulier : j\'irai, tu iras, il ira…',
        'difficulty': 2,
      },
      {
        'question': 'Quel est le participe passé de "prendre" ?',
        'type': 'qcm',
        'correct': 'pris',
        'choices': ['pris', 'prenu', 'prendu', 'prit'],
        'explanation': 'Prendre → pris (3e groupe, irrégulier)',
        'difficulty': 2,
      },
      {
        'question': 'Complétez : "Il faut que je _____ à l\'heure."',
        'type': 'fill_blank',
        'correct': 'sois',
        'choices': ['sois', 'suis', 'serai', 'étais'],
        'explanation': 'Subjonctif présent de "être" : que je sois',
        'difficulty': 3,
      },
      {
        'question': 'Quel est le synonyme de "rapidement" ?',
        'type': 'qcm',
        'correct': 'vite',
        'choices': ['vite', 'lentement', 'doucement', 'tard'],
        'explanation': 'Rapidement = vite (adverbe de manière)',
        'difficulty': 1,
      },
      {
        'question': '"Malgré" est suivi de quel mode ?',
        'type': 'qcm',
        'correct': 'l\'indicatif',
        'choices': ['l\'indicatif', 'le subjonctif', 'le conditionnel', 'l\'impératif'],
        'explanation': '"Malgré" + nom / "Malgré que" + subjonctif (familier)',
        'difficulty': 3,
      },
    ],
    'Anglais': [
      {
        'question': 'Choose the correct form: "She ___ to school every day."',
        'type': 'fill_blank',
        'correct': 'goes',
        'choices': ['goes', 'go', 'going', 'gone'],
        'explanation': '3rd person singular present: goes',
        'difficulty': 1,
      },
      {
        'question': 'What is the past tense of "buy"?',
        'type': 'qcm',
        'correct': 'bought',
        'choices': ['bought', 'buyed', 'buied', 'boughted'],
        'explanation': 'Buy → bought (irregular verb)',
        'difficulty': 1,
      },
      {
        'question': 'Complete: "If I ___ rich, I would travel."',
        'type': 'fill_blank',
        'correct': 'were',
        'choices': ['were', 'was', 'am', 'be'],
        'explanation': 'Second conditional uses "were" for all subjects',
        'difficulty': 2,
      },
      {
        'question': 'Which word is a synonym of "happy"?',
        'type': 'qcm',
        'correct': 'joyful',
        'choices': ['joyful', 'angry', 'tired', 'bored'],
        'explanation': 'Joyful = happy, delighted',
        'difficulty': 1,
      },
      {
        'question': '"Despite" is followed by:',
        'type': 'qcm',
        'correct': 'a noun or gerund',
        'choices': ['a noun or gerund', 'a clause', 'an infinitive', 'a past tense'],
        'explanation': 'Despite + noun/gerund (e.g., despite the rain)',
        'difficulty': 2,
      },
    ],
  };

  /// Construit le prompt Claude selon le contexte
  static String buildClaudePrompt({
    required String language,
    required int userLevel,
    required List<String> recentTopics,
    required int questionCount,
  }) {
    final topics =
        recentTopics.isEmpty ? 'vocabulaire général' : recentTopics.join(', ');
    return '''
Tu es un professeur de $language expert. Génère exactement $questionCount questions de quiz adaptées au niveau $userLevel, basées sur : $topics.

Réponds UNIQUEMENT avec un JSON valide, sans backticks ni texte :
{
  "questions": [
    {
      "question": "texte de la question",
      "type": "qcm",
      "correct": "bonne réponse",
      "choices": ["bonne réponse", "fausse 1", "fausse 2", "fausse 3"],
      "explanation": "explication courte (max 80 car)"
    }
  ]
}

Règles :
- Questions variées (QCM, traduction, complétion)
- Niveau adapté ($userLevel/30)
- Distracteurs plausibles
''';
  }

  /// XP par résultat IA Quiz
  static const Map<String, int> xpRewards = {
    'ai_perfect': 120, // 100%
    'ai_pass': 80, // >= 70%
    'ai_attempt': 30, // < 70%
  };

  static const List<String> perfectMessages = [
    '🧠 Impressionnant ! L\'IA n\'a pas réussi à te piéger !',
    '🎯 Score parfait ! Tu maîtrises vraiment cette matière !',
    '🚀 Exceptionnel ! Claude est impressionné par tes réponses !',
  ];

  static const List<String> passMessages = [
    '✅ Bien joué ! Tu progresses rapidement !',
    '📚 Bonne performance ! Continue comme ça !',
    '⭐ Quiz réussi ! Tes efforts paient !',
  ];

  static const List<String> failMessages = [
    '💪 Pas encore, mais chaque essai te rapproche du succès !',
    '📖 Révise les leçons et retente ta chance !',
    '🔄 L\'important c\'est de continuer à apprendre !',
  ];
}
