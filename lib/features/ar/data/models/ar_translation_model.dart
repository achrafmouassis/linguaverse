/// Contient le mot en anglais (affiché en grand) et sa traduction
/// dans la langue cible (affichée en dessous, plus petite).
///
/// Règle d'affichage :
///   → Ligne 1 (grande) : mot en ANGLAIS — toujours
///   → Ligne 2 (petite) : traduction dans la langue cible + romanisation
///   → Si langue cible = Anglais : afficher seulement la ligne 1
class ArTranslationModel {
  final String englishWord;
  final String targetWord;
  final String romanization;
  final String pronunciation;
  final String targetLanguage;
  final bool isFromAPI;
  final bool fromCache;
  final DateTime fetchedAt;

  const ArTranslationModel({
    required this.englishWord,
    required this.targetWord,
    required this.romanization,
    required this.pronunciation,
    required this.targetLanguage,
    this.isFromAPI = false,
    this.fromCache = false,
    required this.fetchedAt,
  });

  /// Indique si on affiche la traduction (langue cible ≠ anglais)
  bool get showTranslation => targetLanguage != 'Anglais' && targetWord.isNotEmpty;

  /// Ligne de traduction complète avec romanisation si disponible
  String get translationLine {
    if (romanization.isNotEmpty) return '$targetWord — $romanization';
    return targetWord;
  }

  /// Depuis le dictionnaire local (M4MockData)
  factory ArTranslationModel.fromDictionary({
    required String englishWord,
    required Map<String, String> translationMap,
    required String targetLanguage,
  }) {
    return ArTranslationModel(
      englishWord: englishWord.substring(0, 1).toUpperCase() + englishWord.substring(1),
      targetWord: translationMap['word'] ?? '',
      romanization: translationMap['roman'] ?? '',
      pronunciation: translationMap['sound'] ?? '',
      targetLanguage: targetLanguage,
      isFromAPI: false,
      fromCache: false,
      fetchedAt: DateTime.now(),
    );
  }

  /// Depuis Claude API (mode texte)
  factory ArTranslationModel.fromAPI({
    required String englishText,
    required String translatedText,
    required String targetLanguage,
    required bool fromCache,
  }) {
    return ArTranslationModel(
      englishWord: englishText,
      targetWord: translatedText,
      romanization: '',
      pronunciation: '',
      targetLanguage: targetLanguage,
      isFromAPI: true,
      fromCache: fromCache,
      fetchedAt: DateTime.now(),
    );
  }

  ArTranslationModel copyWith({bool? fromCache}) {
    return ArTranslationModel(
      englishWord: englishWord,
      targetWord: targetWord,
      romanization: romanization,
      pronunciation: pronunciation,
      targetLanguage: targetLanguage,
      isFromAPI: isFromAPI,
      fromCache: fromCache ?? this.fromCache,
      fetchedAt: fetchedAt,
    );
  }
}
