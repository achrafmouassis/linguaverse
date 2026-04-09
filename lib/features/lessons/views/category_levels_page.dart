import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../models/category_level.dart';
import '../viewmodels/lesson_categories_provider.dart';
import 'lesson_content_page.dart';

class CategoryLevelsPage extends ConsumerWidget {
  final String languageId;
  final String categoryId;

  const CategoryLevelsPage({
    super.key,
    required this.languageId,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(lessonCategoriesProvider(languageId));
    final category = categories.firstWhere((c) => c.id == categoryId, orElse: () => categories.first);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).cardColor,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Méthode d\'apprentissage', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  category.learningMethod,
                  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: category.levels.length,
              itemBuilder: (context, index) {
                final level = category.levels[index];
          
          // Déverrouillé si c'est le 1er ou si le niveau précédent est complété
          bool isLevelUnlocked = index == 0 || category.levels[index - 1].isCompleted;

          return _LevelCard(
            level: level,
            isUnlocked: isLevelUnlocked,
            color: Colors.blue,
            languageId: languageId,
            categoryId: categoryId,
          );
        },
      ),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final CategoryLevel level;
  final bool isUnlocked;
  final Color color;
  final String languageId;
  final String categoryId;

  const _LevelCard({
    required this.level,
    required this.isUnlocked,
    required this.color,
    required this.languageId,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.5,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isUnlocked ? color.withOpacity(0.3) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    level.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (level.isCompleted)
                    const Icon(Icons.check_circle_rounded, color: AppColors.correctGreen)
                  else if (!isUnlocked)
                    const Icon(Icons.lock_rounded, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              ...level.lessons.map((lesson) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Icon(
                      lesson.isCompleted ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      color: lesson.isCompleted ? AppColors.correctGreen : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        lesson.title,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : AppColors.textPrimary,
                          decoration: lesson.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              if (isUnlocked && !level.isCompleted) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LessonContentPage(
                            level: level,
                            color: color,
                            languageId: languageId,
                            categoryId: categoryId,
                          ),
                        ),
                      );
                    },
                    child: const Text('Commencer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
