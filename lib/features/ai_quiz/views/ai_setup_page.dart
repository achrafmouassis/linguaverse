import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/constants.dart';
import '../viewmodels/ai_quiz_notifier.dart';
import '../models/ai_question.dart';
import 'ai_preview_page.dart';

// ════════════════════════════════════════════════════════════════════
// AI SETUP PAGE — Écran principal de configuration du quiz IA
// ════════════════════════════════════════════════════════════════════

class AiSetupPage extends ConsumerStatefulWidget {
  const AiSetupPage({super.key});

  @override
  ConsumerState<AiSetupPage> createState() => _AiSetupPageState();
}

class _AiSetupPageState extends ConsumerState<AiSetupPage>
    with SingleTickerProviderStateMixin {
  final _textController = TextEditingController();
  int _questionCount = 10;
  String _cecrLevel = 'B1';
  bool _isTextMode = false;

  late final AnimationController _pulseController;

  static const _cecrLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(aiQuizNotifierProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Navigation automatique vers la preview quand les questions sont prêtes
    ref.listen<AiQuizState>(aiQuizNotifierProvider, (prev, next) {
      if (next.phase == AiQuizPhase.ready && next.hasQuestions) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AiPreviewPage()),
        );
      }
    });

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: isDark
                ? theme.scaffoldBackgroundColor
                : colorScheme.surface,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded,
                  color: colorScheme.onSurface),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                  left: AppSpacing.xl, bottom: AppSpacing.lg),
              title: Text(
                'Quiz IA',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.08),
                      AppColors.tertiary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              // Bouton Home
              IconButton(
                icon: const Icon(Icons.home_rounded),
                onPressed: () => context.go('/home'),
              ),
              // Quota badge
              Container(
                margin: const EdgeInsets.only(right: AppSpacing.lg),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded,
                        size: 16, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      '${quizState.remainingQuota}/${AppConstants.aiQuotaPerDay}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Source Selector ────────────────────────────────
                _buildSourceSelector(theme, colorScheme, isDark),
                const SizedBox(height: AppSpacing.xl),

                // ── Source Input ───────────────────────────────────
                if (_isTextMode)
                  _buildTextInput(theme, colorScheme, isDark, quizState)
                else
                  _buildPdfPicker(theme, colorScheme, isDark, quizState),

                const SizedBox(height: AppSpacing.xxl),

                // ── CECR Level ────────────────────────────────────
                _buildCecrSelector(theme, colorScheme, isDark),
                const SizedBox(height: AppSpacing.xxl),

                // ── Question Count Slider ─────────────────────────
                _buildQuestionCountSlider(theme, colorScheme, isDark),
                const SizedBox(height: AppSpacing.giant),

                // ── Generate Button ───────────────────────────────
                _buildGenerateButton(theme, colorScheme, isDark, quizState),

                // ── Loading Indicator ─────────────────────────────
                if (quizState.isLoading) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  _buildGlassmorphicProgress(
                      theme, colorScheme, isDark, quizState),
                ],

                // ── Error Message ─────────────────────────────────
                if (quizState.phase == AiQuizPhase.error &&
                    quizState.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  _buildErrorCard(theme, colorScheme, isDark, quizState),
                ],

                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════
  // WIDGETS PRIVÉS
  // ════════════════════════════════════════════════════════════════════

  /// Toggle PDF / Texte libre.
  Widget _buildSourceSelector(
      ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surface.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          _tabButton(
            label: 'PDF / Image',
            icon: Icons.picture_as_pdf_rounded,
            isSelected: !_isTextMode,
            theme: theme,
            colorScheme: colorScheme,
            onTap: () => setState(() => _isTextMode = false),
          ),
          _tabButton(
            label: 'Texte libre',
            icon: Icons.edit_note_rounded,
            isSelected: _isTextMode,
            theme: theme,
            colorScheme: colorScheme,
            onTap: () => setState(() => _isTextMode = true),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface.withValues(alpha: 0.6)),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Zone de texte libre.
  Widget _buildTextInput(ThemeData theme, ColorScheme colorScheme,
      bool isDark, AiQuizState quizState) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surface.withValues(alpha: 0.4)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        controller: _textController,
        maxLines: 8,
        minLines: 5,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText:
              'Collez votre texte ici...\n\nExemple : un extrait de cours, un article, des notes de révision…',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.35),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(AppSpacing.lg),
          suffixIcon: _textController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded,
                      color: colorScheme.onSurface.withValues(alpha: 0.4)),
                  onPressed: () {
                    _textController.clear();
                    ref.read(aiQuizNotifierProvider.notifier).setFreeText('');
                    setState(() {});
                  },
                )
              : null,
        ),
        onChanged: (text) {
          ref.read(aiQuizNotifierProvider.notifier).setFreeText(text);
          setState(() {}); // Refresh the clear button
        },
      ),
    );
  }

  /// Bouton d'upload PDF.
  Widget _buildPdfPicker(ThemeData theme, ColorScheme colorScheme,
      bool isDark, AiQuizState quizState) {
    final hasSource = quizState.sourceText != null &&
        quizState.sourceText!.isNotEmpty;

    return GestureDetector(
      onTap: quizState.isLoading
          ? null
          : () {
              HapticFeedback.mediumImpact();
              ref.read(aiQuizNotifierProvider.notifier).pickPdf();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surface.withValues(alpha: 0.4)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: hasSource
                ? AppColors.correctGreen.withValues(alpha: 0.5)
                : colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
            style: hasSource ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: (hasSource
                        ? AppColors.correctGreen
                        : colorScheme.primary)
                    .withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasSource
                    ? Icons.check_circle_rounded
                    : Icons.upload_file_rounded,
                size: 36,
                color:
                    hasSource ? AppColors.correctGreen : colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasSource
                  ? '${quizState.sourceText!.length} caractères extraits'
                  : 'Importer un document',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasSource
                  ? 'Touchez pour remplacer le document'
                  : 'PDF, JPG, PNG • Extraction locale (RGPD)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Sélecteur de niveau CECR.
  Widget _buildCecrSelector(
      ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Niveau CECR',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: _cecrLevels.map((level) {
            final isSelected = _cecrLevel == level;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _cecrLevel = level);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : isDark
                            ? colorScheme.surface.withValues(alpha: 0.5)
                            : colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: isSelected
                        ? null
                        : Border.all(
                            color:
                                colorScheme.outline.withValues(alpha: 0.15)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    level,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Slider nombre de questions.
  Widget _buildQuestionCountSlider(
      ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nombre de questions',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                '$_questionCount',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: colorScheme.primary,
            inactiveTrackColor:
                colorScheme.primary.withValues(alpha: 0.15),
            thumbColor: colorScheme.primary,
            overlayColor: colorScheme.primary.withValues(alpha: 0.1),
            trackHeight: 4,
          ),
          child: Slider(
            value: _questionCount.toDouble(),
            min: 5,
            max: 20,
            divisions: 15,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              setState(() => _questionCount = value.round());
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('5',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.4))),
            Text('20',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.4))),
          ],
        ),
      ],
    );
  }

  /// Bouton de génération.
  Widget _buildGenerateButton(ThemeData theme, ColorScheme colorScheme,
      bool isDark, AiQuizState quizState) {
    final isDisabled = quizState.isLoading ||
        quizState.remainingQuota <= 0 ||
        (quizState.sourceText == null || quizState.sourceText!.trim().isEmpty);

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              HapticFeedback.heavyImpact();
              ref.read(aiQuizNotifierProvider.notifier).generateQuiz(
                    questionCount: _questionCount,
                    cecrLevel: _cecrLevel,
                  );
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: isDisabled
              ? null
              : LinearGradient(
                  colors: [
                    colorScheme.primary,
                    AppColors.tertiary,
                  ],
                ),
          color: isDisabled
              ? colorScheme.onSurface.withValues(alpha: 0.1)
              : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              color: isDisabled
                  ? colorScheme.onSurface.withValues(alpha: 0.3)
                  : Colors.white,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              quizState.isLoading
                  ? 'Génération en cours…'
                  : 'Générer le Quiz',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDisabled
                    ? colorScheme.onSurface.withValues(alpha: 0.3)
                    : Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Barre de progression glassmorphism.
  Widget _buildGlassmorphicProgress(ThemeData theme, ColorScheme colorScheme,
      bool isDark, AiQuizState quizState) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.9 + (_pulseController.value * 0.2),
                        child: child,
                      );
                    },
                    child: Icon(Icons.psychology_rounded,
                        color: colorScheme.primary, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      quizState.phaseLabel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${(quizState.progress * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: TweenAnimationBuilder<double>(
                  tween:
                      Tween(begin: 0, end: quizState.progress),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 6,
                      backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.lerp(
                            colorScheme.primary, AppColors.tertiary, value)!,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Carte d'erreur.
  Widget _buildErrorCard(ThemeData theme, ColorScheme colorScheme,
      bool isDark, AiQuizState quizState) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.wrongRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.wrongRed.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded,
              color: AppColors.wrongRed, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              quizState.errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.wrongRed.withValues(alpha: 0.9)
                    : AppColors.wrongRed,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: () =>
                ref.read(aiQuizNotifierProvider.notifier).reset(),
            child: Icon(Icons.close_rounded,
                size: 18,
                color: colorScheme.onSurface.withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }
}
