import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../shared/utils/constants.dart';
import '../models/ai_question.dart';
import '../repositories/ai_repository.dart';

// ════════════════════════════════════════════════════════════════════
// PROVIDERS
// ════════════════════════════════════════════════════════════════════

/// Provider pour le repository IA.
final aiRepositoryProvider = Provider<AiRepository>((ref) {
  final repo = AiRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});

/// Provider principal pour l'état du module AI Quiz.
final aiQuizNotifierProvider =
    StateNotifierProvider<AiQuizNotifier, AiQuizState>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  final secureStorage = ref.watch(_secureStorageProvider);
  return AiQuizNotifier(repository, secureStorage);
});

/// Provider interne pour le stockage sécurisé.
final _secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// ════════════════════════════════════════════════════════════════════
// NOTIFIER — Logique métier séparée de l'UI
// ════════════════════════════════════════════════════════════════════

class AiQuizNotifier extends StateNotifier<AiQuizState> {
  final AiRepository _repository;
  final FlutterSecureStorage _secureStorage;

  static const _quotaKey = 'ai_quiz_quota';
  static const _quotaDateKey = 'ai_quiz_quota_date';

  AiQuizNotifier(this._repository, this._secureStorage)
      : super(const AiQuizState()) {
    _loadQuota();
  }

  // ────────────────────────────────────────────────────────────────────
  // Quota Management (5 générations / jour via flutter_secure_storage)
  // ────────────────────────────────────────────────────────────────────

  /// Charge le quota restant depuis le stockage sécurisé.
  /// Si la date a changé, réinitialise le compteur à 5.
  Future<void> _loadQuota() async {
    try {
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final savedDate = await _secureStorage.read(key: _quotaDateKey);
      final savedQuota = await _secureStorage.read(key: _quotaKey);

      if (savedDate != today || savedQuota == null) {
        // Nouveau jour → réinitialiser le quota
        await _secureStorage.write(key: _quotaDateKey, value: today);
        await _secureStorage.write(
            key: _quotaKey, value: AppConstants.aiQuotaPerDay.toString());
        state =
            state.copyWith(remainingQuota: AppConstants.aiQuotaPerDay);
      } else {
        state = state.copyWith(remainingQuota: int.parse(savedQuota));
      }
    } catch (e) {
      debugPrint('⚠️ Quota load error: $e');
      state = state.copyWith(remainingQuota: AppConstants.aiQuotaPerDay);
    }
  }

  /// Décrémente le quota et le persiste.
  Future<bool> _decrementQuota() async {
    if (state.remainingQuota <= 0) return false;

    final newQuota = state.remainingQuota - 1;
    await _secureStorage.write(key: _quotaKey, value: newQuota.toString());
    state = state.copyWith(remainingQuota: newQuota);
    return true;
  }

  // ────────────────────────────────────────────────────────────────────
  // Source Text Input
  // ────────────────────────────────────────────────────────────────────

  /// Ouvre le file picker, extrait le texte via ML Kit.
  Future<void> pickPdf() async {
    try {
      state = state.copyWith(phase: AiQuizPhase.pickingFile);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        // L'utilisateur a annulé
        state = state.copyWith(phase: AiQuizPhase.initial);
        return;
      }

      final filePath = result.files.single.path;
      if (filePath == null) {
        state = state.copyWith(
          phase: AiQuizPhase.error,
          errorMessage: 'Impossible de lire le fichier sélectionné.',
        );
        return;
      }

      // Extraction du texte via ML Kit (local, RGPD)
      state = state.copyWith(phase: AiQuizPhase.extracting, progress: 0.3);

      final extractedText = await _repository.extractTextFromFile(filePath);

      state = state.copyWith(
        phase: AiQuizPhase.initial,
        sourceText: extractedText,
        progress: 1.0,
      );

      debugPrint('✅ Texte extrait : ${extractedText.length} caractères');
    } catch (e) {
      state = state.copyWith(
        phase: AiQuizPhase.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Définit directement le texte source (mode texte libre).
  void setFreeText(String text) {
    state = state.copyWith(
      sourceText: text.trim(),
      phase: AiQuizPhase.initial,
    );
  }

  // ────────────────────────────────────────────────────────────────────
  // Quiz Generation
  // ────────────────────────────────────────────────────────────────────

  /// Génère le quiz en appelant Claude 3 Haiku.
  ///
  /// Vérifie le quota, envoie le texte source, parse la réponse.
  /// Objectif : < 8 secondes.
  Future<void> generateQuiz({
    required int questionCount,
    required String cecrLevel,
  }) async {
    // Vérifie le texte source
    final text = state.sourceText;
    if (text == null || text.trim().isEmpty) {
      state = state.copyWith(
        phase: AiQuizPhase.error,
        errorMessage: 'Veuillez d\'abord saisir ou extraire du texte.',
      );
      return;
    }

    // Vérifie le quota
    if (state.remainingQuota <= 0) {
      state = state.copyWith(
        phase: AiQuizPhase.error,
        errorMessage:
            'Quota épuisé ! Vous avez atteint la limite de ${AppConstants.aiQuotaPerDay} '
            'générations par jour. Revenez demain 🌙',
      );
      return;
    }

    try {
      state = state.copyWith(phase: AiQuizPhase.generating, progress: 0.0);

      // Simule une progression smooth pendant l'attente API
      _simulateProgress();

      final questions = await _repository.generateQuiz(
        sourceText: text,
        questionCount: questionCount,
        cecrLevel: cecrLevel,
      );

      if (questions.isEmpty) {
        state = state.copyWith(
          phase: AiQuizPhase.error,
          errorMessage: 'Aucune question générée. Réessayez avec un texte plus riche.',
        );
        return;
      }

      // Décrémente le quota après succès
      await _decrementQuota();

      state = state.copyWith(
        phase: AiQuizPhase.ready,
        questions: questions,
        progress: 1.0,
      );

      debugPrint('✅ ${questions.length} questions générées');
    } catch (e) {
      state = state.copyWith(
        phase: AiQuizPhase.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Simule une barre de progression smooth pendant la requête API.
  void _simulateProgress() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (state.phase == AiQuizPhase.generating && state.progress < 0.3) {
        state = state.copyWith(progress: 0.3);
      }
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (state.phase == AiQuizPhase.generating && state.progress < 0.6) {
        state = state.copyWith(progress: 0.6);
      }
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (state.phase == AiQuizPhase.generating && state.progress < 0.85) {
        state = state.copyWith(progress: 0.85);
      }
    });
  }

  // ────────────────────────────────────────────────────────────────────
  // Question Editing (Preview)
  // ────────────────────────────────────────────────────────────────────

  /// Met à jour une question à l'index donné.
  void editQuestion(int index, AiQuestion updated) {
    if (index < 0 || index >= state.questions.length) return;

    final newList = List<AiQuestion>.from(state.questions);
    newList[index] = updated;
    state = state.copyWith(questions: newList);
  }

  /// Supprime une question à l'index donné.
  void removeQuestion(int index) {
    if (index < 0 || index >= state.questions.length) return;

    final newList = List<AiQuestion>.from(state.questions);
    newList.removeAt(index);
    state = state.copyWith(questions: newList);
  }

  /// Réinitialise l'état pour une nouvelle génération.
  void reset() {
    state = AiQuizState(remainingQuota: state.remainingQuota);
  }
}
