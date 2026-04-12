import 'package:flutter/material.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';

/// Scroll horizontal de pills colorées pour choisir la langue cible.
class ArLanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final List<String> availableLanguages;
  final void Function(String) onLanguageChanged;

  const ArLanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.availableLanguages,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: availableLanguages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final lang = availableLanguages[index];
          final selected = lang == selectedLanguage;

          return GestureDetector(
            onTap: () => onLanguageChanged(lang),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.85)
                    : Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: selected
                      ? AppColors.primary.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Text(
                lang,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: Colors.white.withValues(alpha: selected ? 1.0 : 0.6),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
