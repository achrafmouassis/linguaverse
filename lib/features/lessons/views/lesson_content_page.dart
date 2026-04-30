import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../data/course_catalog.dart';
import '../models/lesson_course.dart';
import '../viewmodels/user_progress_provider.dart';
import '../viewmodels/lesson_categories_provider.dart';
import '../../../shared/providers/tts_provider.dart';

class LessonContentPage extends ConsumerStatefulWidget {
  final int levelIndex;
  final int lessonIndex;
  final Color color;
  final String languageId;
  final String categoryId;

  const LessonContentPage({
    super.key,
    required this.levelIndex,
    required this.lessonIndex,
    required this.color,
    required this.languageId,
    required this.categoryId,
  });

  @override
  ConsumerState<LessonContentPage> createState() => _LessonContentPageState();
}

class _LessonContentPageState extends ConsumerState<LessonContentPage> {
  int _courseIndex = 0;
  int _sectionIndex = 0;

  late List<LessonCourse> _courses;

  static const _sectionTitles = [
    'Introduction',
    'Vocabulaire',
    'Prononciation',
    'Exemples',
    'Résumé',
  ];

  static const _sectionIcons = [
    Icons.menu_book_rounded,
    Icons.abc_rounded,
    Icons.volume_up_rounded,
    Icons.format_quote_rounded,
    Icons.check_circle_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _courses = CourseCatalog.getCourses(widget.languageId, widget.categoryId);
    // Slice to courses belonging to this level (3 per level)
    final start = widget.levelIndex * 3;
    final end = (start + 3).clamp(0, _courses.length);
    if (start < _courses.length) {
      _courses = _courses.sublist(start, end);
    } else {
      _courses = CourseCatalog.getCourses('', '');
    }
    _courseIndex = widget.lessonIndex % _courses.length;
  }

  LessonCourse get currentCourse => _courses.isNotEmpty
      ? _courses[_courseIndex.clamp(0, _courses.length - 1)]
      : CourseCatalog.getCourses('', '')[0];

  int get totalSections => _sectionTitles.length;

  void _next() {
    if (_sectionIndex < totalSections - 1) {
      setState(() => _sectionIndex++);
    } else if (_courseIndex < _courses.length - 1) {
      setState(() {
        _courseIndex++;
        _sectionIndex = 0;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _prev() {
    if (_sectionIndex > 0) {
      setState(() => _sectionIndex--);
    } else if (_courseIndex > 0) {
      setState(() {
        _courseIndex--;
        _sectionIndex = totalSections - 1;
      });
    }
  }

  bool get isFirstPage => _courseIndex == 0 && _sectionIndex == 0;
  bool get isLastPage => _courseIndex == _courses.length - 1 && _sectionIndex == totalSections - 1;

  void _showCompletionDialog() {
    final categories = ref.read(lessonCategoriesProvider(widget.languageId));
    final category = categories.firstWhere((c) => c.id == widget.categoryId);
    final level = category.levels[widget.levelIndex];
    // Résoudre la leçon actuelle à partir de son index dans le niveau
    final lessonIdx = widget.lessonIndex.clamp(0, level.lessons.length - 1);
    final lesson = level.lessons[lessonIdx];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            Text('${lesson.title} terminée !',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: widget.color),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('Vous avez parcouru tout le contenu. Excellent travail !',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            const Text('🎯 Passez le quiz pour débloquer la suite !',
                style: TextStyle(color: AppColors.correctGreen, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  ref.read(userProgressProvider.notifier).markLessonAsCompleted(lesson.id);

                  Navigator.of(ctx).pop();
                  context.pushNamed('quiz', queryParameters: {
                    'languageId': widget.languageId,
                    'categoryId': widget.categoryId,
                    'levelIndex': widget.levelIndex.toString(),
                    'lessonIndex': lessonIdx.toString(),
                    'lessonId': lesson.id,
                  });
                },
                child: const Text('🎯 Passer le Quiz',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalSteps = _courses.length * totalSections;
    final currentStep = _courseIndex * totalSections + _sectionIndex;
    final progress = (currentStep + 1) / totalSteps;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top bar ───
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.close_rounded, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.grey.withValues(alpha: 0.15),
                            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cours ${_courseIndex + 1}/${_courses.length} · ${_sectionTitles[_sectionIndex]}',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── Section tab indicator ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: List.generate(totalSections, (i) {
                  final active = i == _sectionIndex;
                  final done = i < _sectionIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _sectionIndex = i),
                      child: Container(
                        height: 36,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: active
                              ? widget.color
                              : done
                                  ? widget.color.withValues(alpha: 0.15)
                                  : Colors.grey.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _sectionIcons[i],
                          size: 16,
                          color: active
                              ? Colors.white
                              : done
                                  ? widget.color
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ─── Content ───
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildSection(isDark),
              ),
            ),

            // ─── Navigation ───
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Row(
                children: [
                  if (!isFirstPage)
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: _prev,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                    ),
                  if (!isFirstPage) const SizedBox(width: 12),
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: _next,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: widget.color.withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isLastPage ? '✅  Terminer le niveau' : 'Suivant →',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(bool isDark) {
    switch (_sectionIndex) {
      case 0:
        return _buildIntroduction(isDark);
      case 1:
        return _buildVocabulary(isDark);
      case 2:
        return _buildPhonetics(isDark);
      case 3:
        return _buildExamples(isDark);
      case 4:
        return _buildSummary(isDark);
      default:
        return const SizedBox();
    }
  }

  // ─── 1. Introduction ───
  Widget _buildIntroduction(bool isDark) {
    final course = currentCourse;
    return SingleChildScrollView(
      key: const ValueKey('intro'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HeaderCard
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color, widget.color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.menu_book_rounded, color: Colors.white70, size: 32),
                const SizedBox(height: 12),
                Text(course.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text('${course.language} · ${course.category}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Meta row
          Row(
            children: [
              _metaChip(Icons.timer_rounded, course.estimatedDuration, widget.color),
              const SizedBox(width: 8),
              _metaChip(Icons.psychology_rounded, course.learningMethod, Colors.purple),
              const SizedBox(width: 8),
              _metaChip(Icons.lock_open_rounded, 'Accessible', AppColors.correctGreen),
            ],
          ),
          const SizedBox(height: 16),

          // Prerequisites
          _card(isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Pré-requis', Icons.checklist_rounded, Colors.orange),
                  const SizedBox(height: 8),
                  Text(course.prerequisites,
                      style: TextStyle(color: isDark ? Colors.white70 : AppColors.textSecondary)),
                ],
              )),
          const SizedBox(height: 12),

          // Introduction text
          _card(isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Introduction', Icons.info_rounded, widget.color),
                  const SizedBox(height: 8),
                  Text(course.introduction,
                      style: TextStyle(
                          height: 1.6, color: isDark ? Colors.white70 : AppColors.textPrimary)),
                ],
              )),
          const SizedBox(height: 12),

          // Objectives
          _card(isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Objectifs du cours', Icons.flag_rounded, AppColors.correctGreen),
                  const SizedBox(height: 10),
                  ...course.objectives.map((obj) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_right_rounded, color: widget.color, size: 22),
                            const SizedBox(width: 6),
                            Expanded(
                                child: Text(obj,
                                    style: TextStyle(
                                        color: isDark ? Colors.white70 : AppColors.textPrimary,
                                        height: 1.4))),
                          ],
                        ),
                      )),
                ],
              )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ─── 2. Vocabulary ───
  Widget _buildVocabulary(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('vocab'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Vocabulaire et Concepts', Icons.abc_rounded, widget.color),
          const SizedBox(height: 12),
          ...currentCourse.vocabulary.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: widget.color.withValues(alpha: 0.15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: widget.color, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text('${i + 1}',
                              style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.word,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : AppColors.textPrimary)),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: widget.color.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(6)),
                                          child: Text('[${item.pronunciation}]',
                                              style: TextStyle(
                                                  color: widget.color,
                                                  fontSize: 13,
                                                  fontFamily: 'monospace')),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => ref
                                              .read(ttsProvider)
                                              .speak(item.word, widget.languageId),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                                color: widget.color.withValues(alpha: 0.1),
                                                shape: BoxShape.circle),
                                            child: Icon(Icons.volume_up_rounded,
                                                size: 16, color: widget.color),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (item.imageUrl != null)
                                Container(
                                  width: 80,
                                  height: 80,
                                  margin: const EdgeInsets.only(left: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: widget.color.withValues(alpha: 0.2)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2)),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      item.imageUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2, color: widget.color));
                                      },
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey.shade400),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(item.definition,
                              style: TextStyle(
                                  color: isDark ? Colors.white60 : AppColors.textSecondary,
                                  fontSize: 13)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.format_quote_rounded,
                                  size: 14, color: Colors.grey.shade400),
                              const SizedBox(width: 4),
                              Expanded(
                                  child: Text(item.example,
                                      style: TextStyle(
                                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ─── 3. Phonetics ───
  Widget _buildPhonetics(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('phonetics'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Prononciation & Phonétique', Icons.volume_up_rounded, widget.color),
          const SizedBox(height: 12),
          _card(isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(
                      'Guide de prononciation', Icons.record_voice_over_rounded, widget.color),
                  const SizedBox(height: 12),
                  ...currentCourse.phoneticsExplanation.split('\n').map((line) {
                    if (line.trim().isEmpty) return const SizedBox(height: 4);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: widget.color.withValues(alpha: 0.12)),
                        ),
                        child: Text(line,
                            style: TextStyle(
                                height: 1.5,
                                fontFamily: 'monospace',
                                color: isDark ? Colors.white70 : AppColors.textPrimary,
                                fontSize: 13)),
                      ),
                    );
                  }),
                ],
              )),
          const SizedBox(height: 12),
          // Quick reference table
          _card(isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Tableau des sons', Icons.table_chart_rounded, Colors.teal),
                  const SizedBox(height: 10),
                  ...currentCourse.vocabulary.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(item.word,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : AppColors.textPrimary))),
                            Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: widget.color.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6)),
                                      child: Text('[${item.pronunciation}]',
                                          style: TextStyle(
                                              color: widget.color,
                                              fontFamily: 'monospace',
                                              fontSize: 12)),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: Icon(Icons.volume_up_rounded,
                                          size: 18, color: widget.color),
                                      onPressed: () =>
                                          ref.read(ttsProvider).speak(item.word, widget.languageId),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      )),
                ],
              )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ─── 4. Examples ───
  Widget _buildExamples(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('examples'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Exemples d\'utilisation', Icons.format_quote_rounded, widget.color),
          const SizedBox(height: 12),
          ...currentCourse.usageExamples.asMap().entries.map((entry) {
            final parts = entry.value.split('→');
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: widget.color.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: widget.color, borderRadius: BorderRadius.circular(6)),
                        child: Text('Ex. ${entry.key + 1}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up_rounded, size: 20, color: widget.color),
                        onPressed: () =>
                            ref.read(ttsProvider).speak(parts[0].trim(), widget.languageId),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (parts.isNotEmpty) ...[
                    Text(parts[0].trim(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.textPrimary)),
                    if (parts.length > 1) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 6),
                          Expanded(
                              child: Text(parts[1].trim(),
                                  style: TextStyle(
                                      color: isDark ? Colors.white54 : AppColors.textSecondary,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic))),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ─── 5. Summary ───
  Widget _buildSummary(bool isDark) {
    return SingleChildScrollView(
      key: const ValueKey('summary'),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
              'Résumé & Points clés', Icons.check_circle_rounded, AppColors.correctGreen),
          const SizedBox(height: 12),
          _card(isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(
                      'Ce que vous avez appris', Icons.workspace_premium_rounded, widget.color),
                  const SizedBox(height: 12),
                  ...currentCourse.summaryPoints.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                  color: AppColors.correctGreen, shape: BoxShape.circle),
                              child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Text(entry.value,
                                    style: TextStyle(
                                        height: 1.4,
                                        color: isDark ? Colors.white70 : AppColors.textPrimary))),
                          ],
                        ),
                      )),
                ],
              )),
          const SizedBox(height: 12),
          _card(isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Méta-informations', Icons.info_outline_rounded, Colors.blueGrey),
                  const SizedBox(height: 10),
                  _metaRow(Icons.timer_rounded, 'Durée estimée', currentCourse.estimatedDuration,
                      isDark),
                  _metaRow(
                      Icons.psychology_rounded, 'Méthode', currentCourse.learningMethod, isDark),
                  _metaRow(
                      Icons.checklist_rounded, 'Pré-requis', currentCourse.prerequisites, isDark),
                  _metaRow(Icons.lock_open_rounded, 'Statut', 'Accessible', isDark,
                      valueColor: AppColors.correctGreen),
                ],
              )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ─── Helpers ───
  Widget _card(bool isDark, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.color.withValues(alpha: 0.12)),
      ),
      child: child,
    );
  }

  Widget _sectionLabel(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: color, letterSpacing: 0.3)),
      ],
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration:
          BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _metaRow(IconData icon, String label, String value, bool isDark, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label :',
              style:
                  const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 13)),
          const SizedBox(width: 6),
          Flexible(
              child: Text(value,
                  style: TextStyle(
                      fontSize: 13,
                      color: valueColor ?? (isDark ? Colors.white70 : AppColors.textPrimary),
                      fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
