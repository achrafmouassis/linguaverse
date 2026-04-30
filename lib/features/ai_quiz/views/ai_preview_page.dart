import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../router.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/constants.dart';
import '../models/ai_question.dart';
import '../viewmodels/ai_quiz_notifier.dart';

// ════════════════════════════════════════════════════════════════════
// AI PREVIEW PAGE — Liste éditable des questions avant le quiz
// ════════════════════════════════════════════════════════════════════

class AiPreviewPage extends ConsumerStatefulWidget {
  const AiPreviewPage({super.key});

  @override
  ConsumerState<AiPreviewPage> createState() => _AiPreviewPageState();
}

class _AiPreviewPageState extends ConsumerState<AiPreviewPage> {
  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(aiQuizNotifierProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor:
                isDark ? theme.scaffoldBackgroundColor : colorScheme.surface,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded,
                  color: colorScheme.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                  left: AppSpacing.xl, bottom: AppSpacing.lg),
              title: Text(
                'Aperçu des questions',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            actions: [
              // Bouton Home
              IconButton(
                icon: const Icon(Icons.home_rounded),
                onPressed: () => context.go('/home'),
              ),
              // Question count
              Container(
                margin: const EdgeInsets.only(right: AppSpacing.lg),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '${quizState.questions.length} Q',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          // ── Info Banner (Supprimé) ──────────────────────────────
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

          // ── Questions List ──────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final question = quizState.questions[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _QuestionCard(
                      index: index,
                      question: question,
                      isDark: isDark,
                    ),
                  );
                },
                childCount: quizState.questions.length,
              ),
            ),
          ),

          // ── Bottom spacing ──────────────────────────────────────
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // ── Start Quiz FAB ──────────────────────────────────────────
      floatingActionButton: quizState.questions.isNotEmpty
          ? _buildStartButton(theme, colorScheme, isDark, quizState)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Bouton "Commencer le Quiz" en bas.
  Widget _buildStartButton(ThemeData theme, ColorScheme colorScheme,
      bool isDark, AiQuizState quizState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          // Naviguer vers l'écran de jeu interactif de M8
          context.push(AppRoutes.aiQuizGame);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6A11CB).withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                'Commencer le Quiz (${quizState.questions.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Dialog d'édition d'une question.
  void _showEditDialog(
      BuildContext context, int index, AiQuestion question) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final questionCtrl = TextEditingController(text: question.question);
    final answerCtrl = TextEditingController(text: question.answer);
    final explanationCtrl =
        TextEditingController(text: question.explanation);
    final choiceControllers =
        question.choices.map((c) => TextEditingController(text: c)).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? theme.scaffoldBackgroundColor
                : colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.xl)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.md),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Modifier la question ${index + 1}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Sauvegarder
                        ref
                            .read(aiQuizNotifierProvider.notifier)
                            .editQuestion(
                              index,
                              question.copyWith(
                                question: questionCtrl.text,
                                answer: answerCtrl.text,
                                explanation: explanationCtrl.text,
                                choices: choiceControllers
                                    .map((c) => c.text)
                                    .toList(),
                              ),
                            );
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius:
                              BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          'Sauver',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Fields
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _editField('Question', questionCtrl, theme,
                          colorScheme, isDark,
                          maxLines: 3),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Choix',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface
                                .withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          )),
                      const SizedBox(height: AppSpacing.sm),
                      ...choiceControllers.asMap().entries.map((entry) {
                        final choiceIndex = entry.key;
                        final ctrl = entry.value;
                        final isCorrect =
                            ctrl.text == answerCtrl.text;
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isCorrect
                                      ? AppColors.correctGreen
                                          .withValues(alpha: 0.15)
                                      : colorScheme.onSurface
                                          .withValues(alpha: 0.06),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  String.fromCharCode(65 + choiceIndex),
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: isCorrect
                                        ? AppColors.correctGreen
                                        : colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: TextField(
                                  controller: ctrl,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(
                                          color: colorScheme.onSurface),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.md,
                                            vertical: AppSpacing.md),
                                    filled: true,
                                    fillColor: isDark
                                        ? colorScheme.surface
                                            .withValues(alpha: 0.4)
                                        : colorScheme
                                            .surfaceContainerHighest
                                            .withValues(alpha: 0.3),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              AppRadius.sm),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: AppSpacing.lg),
                      _editField('Réponse correcte', answerCtrl, theme,
                          colorScheme, isDark),
                      const SizedBox(height: AppSpacing.lg),
                      _editField('Explication', explanationCtrl, theme,
                          colorScheme, isDark,
                          maxLines: 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _editField(String label, TextEditingController ctrl,
      ThemeData theme, ColorScheme colorScheme, bool isDark,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            )),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: colorScheme.onSurface, height: 1.4),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            filled: true,
            fillColor: isDark
                ? colorScheme.surface.withValues(alpha: 0.4)
                : colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// QUESTION CARD — Carte pour chaque question dans la preview
// ════════════════════════════════════════════════════════════════════

class _QuestionCard extends StatelessWidget {
  final int index;
  final AiQuestion question;
  final bool isDark;

  const _QuestionCard({
    required this.index,
    required this.question,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surface.withValues(alpha: 0.4)
            : colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: numéro + type + edit icon
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      question.type.toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Question text
              Text(
                question.question,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),

              // Choices
              ...question.choices.asMap().entries.map((entry) {
                final choiceIndex = entry.key;
                final choice = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          String.fromCharCode(65 + choiceIndex),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          choice,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
  }
}
