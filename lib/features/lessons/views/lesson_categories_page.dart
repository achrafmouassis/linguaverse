import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../../shared/theme/app_colors.dart';
import '../models/lesson_category.dart';
import '../viewmodels/languages_provider.dart';
import '../viewmodels/lesson_categories_provider.dart';

class LessonCategoriesPage extends ConsumerWidget {
  final String languageId;

  const LessonCategoriesPage({super.key, required this.languageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languagesProvider).firstWhere(
          (l) => l.id == languageId,
          orElse: () => ref.watch(languagesProvider).first,
        );
    final categories = ref.watch(lessonCategoriesProvider(languageId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('${language.flagEmoji} ${language.name}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 40, bottom: 100),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          // Determine position in the zigzag (cycle of 4: middle, right, middle, left)
          final cycle = index % 4;
          double offsetMultiplier = 0;
          if (cycle == 1) offsetMultiplier = 1;
          if (cycle == 3) offsetMultiplier = -1;

          final screenWidth = MediaQuery.of(context).size.width;
          // Max offset is about 30% of screen width from center
          final maxOffset = screenWidth * 0.25;
          final offsetX = offsetMultiplier * maxOffset;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Transform.translate(
              offset: Offset(offsetX, 0),
              child: _CategoryNode(
                category: category,
                color: language.color,
                isDark: isDark,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryNode extends StatefulWidget {
  final LessonCategory category;
  final Color color;
  final bool isDark;

  const _CategoryNode({
    required this.category,
    required this.color,
    required this.isDark,
  });

  @override
  State<_CategoryNode> createState() => _CategoryNodeState();
}

class _CategoryNodeState extends State<_CategoryNode> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double nodeSize = 90.0;

    // Utiliser le vrai état de verrouillage
    final bool isActualLocked = !widget.category.isUnlocked;

    final displayColor = isActualLocked
        ? (widget.isDark ? Colors.grey.shade800 : Colors.grey.shade300)
        : widget.color;
    final iconColor = isActualLocked ? Colors.grey.shade500 : Colors.white;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        if (!isActualLocked) {
          // Navigation vers la page des niveaux
          context.push('/lessons/${widget.category.languageId}/${widget.category.id}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez compléter la catégorie précédente d\'abord.')),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: _isPressed ? 0.9 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Activity Ring (Circular Progress)
                SizedBox(
                  width: nodeSize + 16,
                  height: nodeSize + 16,
                  child: CircularProgressIndicator(
                    value: widget.category.progress > 0 ? widget.category.progress : null,
                    strokeWidth: 8,
                    backgroundColor: widget.isDark ? Colors.white10 : Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(displayColor),
                  ),
                ),
                // Main Button
                Container(
                  width: nodeSize,
                  height: nodeSize,
                  decoration: BoxDecoration(
                    color: displayColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (!_isPressed && !isActualLocked)
                        BoxShadow(
                          color: displayColor.withOpacity(isActualLocked ? 0 : 0.6),
                          offset: const Offset(0, 5),
                          blurRadius: 0,
                        ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: _isPressed ? 0 : 4.0),
                    child: Icon(
                      isActualLocked ? Icons.lock_rounded : widget.category.icon,
                      color: iconColor,
                      size: 40,
                    ),
                  ),
                ),
                // Crown icon for completed
                if (widget.category.isCompleted)
                  Positioned(
                    top: -12,
                    right: -10,
                    child: Transform.rotate(
                      angle: math.pi / 8,
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.amber,
                        size: 32,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.category.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActualLocked
                  ? (widget.isDark ? Colors.white30 : Colors.black38)
                  : (widget.isDark ? Colors.white : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
