import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';
import '../viewmodels/auth_provider.dart';
import '../widgets/auth_widgets.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Simple email validation
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authNotifierProvider.notifier).signUpWithEmailPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (!mounted) return;
      context.go('/onboarding');
    } catch (e) {
      _showErrorSnackbar(e.toString());
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.wrongRed,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        _showErrorSnackbar(next.errorMessage!);
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpaceBlue : AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Titre
                  Column(
                    children: [
                      Text(
                        'Créer un compte',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rejoignez LinguaVerse et commencez votre voyage linguistique',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Formulaire
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          label: 'Email',
                          hint: 'votre@email.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          prefixIcon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          label: 'Mot de passe',
                          hint: '••••••••',
                          controller: _passwordController,
                          isPassword: true,
                          validator: _validatePassword,
                          prefixIcon: Icons.lock_outlined,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          label: 'Confirmer le mot de passe',
                          hint: '••••••••',
                          controller: _confirmPasswordController,
                          isPassword: true,
                          validator: _validateConfirmPassword,
                          prefixIcon: Icons.lock_outlined,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bouton inscription
                  AuthButton(
                    label: 'S\'inscrire',
                    isLoading: authState.isLoading,
                    isEnabled: !authState.isLoading,
                    onPressed: _handleSignUp,
                  ),

                  const SizedBox(height: 24),

                  // Lien connexion
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Vous avez un compte? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text(
                          'Se connecter',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
