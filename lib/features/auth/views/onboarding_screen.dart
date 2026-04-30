import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';
import '../viewmodels/auth_provider.dart';
import '../widgets/auth_widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  // Réponses du onboarding
  String? _selectedLevel;
  String? _selectedGoal;
  String? _selectedMinutes;
  String? _selectedTheme;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    if (_selectedLevel == null ||
        _selectedGoal == null ||
        _selectedMinutes == null ||
        _selectedTheme == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez compléter toutes les étapes')),
      );
      return;
    }

    try {
      await ref.read(authNotifierProvider.notifier).completeOnboarding(
            languageLevel: _selectedLevel!,
            learningGoal: _selectedGoal!,
            dailyLearningMinutes: _selectedMinutes!,
            preferredTheme: _selectedTheme!,
          );

      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              )
            : null,
      ),
      body: Column(
        children: [
          // Page indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: OnboardingPageIndicator(
              currentPage: _currentPage,
              totalPages: 4,
            ),
          ),

          // PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Page 1: Language Level
                _OnboardingPage(
                  title: 'Quel est votre niveau?',
                  subtitle:
                      'Sélectionnez votre niveau actuel pour un apprentissage adapté',
                  options: const [
                    ('A1', 'Débutant'),
                    ('A2', 'Élémentaire'),
                    ('B1', 'Intermédiaire'),
                    ('B2', 'Intermédiaire+'),
                    ('C1', 'Avancé'),
                    ('C2', 'Maîtrise'),
                  ],
                  selectedValue: _selectedLevel,
                  onSelected: (value) => setState(() => _selectedLevel = value),
                ),

                // Page 2: Learning Goal
                _OnboardingPage(
                  title: 'Quel est votre objectif?',
                  subtitle: 'Cela nous aidera à personnaliser votre expérience',
                  options: const [
                    ('TRAVEL', 'Voyager'),
                    ('WORK', 'Travail'),
                    ('CULTURE', 'Culture'),
                    ('HOBBY', 'Loisir'),
                  ],
                  selectedValue: _selectedGoal,
                  onSelected: (value) => setState(() => _selectedGoal = value),
                ),

                // Page 3: Daily Learning Minutes
                _OnboardingPage(
                  title: 'Combien de temps par jour?',
                  subtitle: 'Choisissez votre engagement quotidien',
                  options: const [
                    ('5', '5 minutes'),
                    ('15', '15 minutes'),
                    ('30', '30 minutes'),
                    ('60', '1 heure'),
                  ],
                  selectedValue: _selectedMinutes,
                  onSelected: (value) =>
                      setState(() => _selectedMinutes = value),
                ),

                // Page 4: Preferred Theme
                _OnboardingPage(
                  title: 'Quelle langue apprenez-vous?',
                  subtitle: 'Vous pouvez changer cela plus tard',
                  options: const [
                    ('ARABIC', 'العربية'),
                    ('ENGLISH', 'English'),
                    ('FRENCH', 'Français'),
                    ('SPANISH', 'Español'),
                  ],
                  selectedValue: _selectedTheme,
                  onSelected: (value) => setState(() => _selectedTheme = value),
                ),
              ],
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (_currentPage < 3)
                  AuthButton(
                    label: 'Suivant',
                    onPressed: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  )
                else
                  AuthButton(
                    label: 'Commencer',
                    isLoading: authState.isLoading,
                    onPressed: _completeOnboarding,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget réutilisable pour une page de onboarding
class _OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<(String, String)> options;
  final String? selectedValue;
  final Function(String) onSelected;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 32),
          ...options.map((option) {
            final (value, label) = option;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ChoiceOption(
                title: label,
                isSelected: selectedValue == value,
                onTap: () => onSelected(value),
              ),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
