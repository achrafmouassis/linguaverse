import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linguaverse/shared/theme/app_colors.dart';
import '../viewmodels/auth_provider.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authNotifierProvider.notifier).signInWithEmailPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (!mounted) return;

      // Vérifie si onboarding est requis
      final authState = ref.read(authNotifierProvider);
      if (authState.isOnboardingRequired) {
        context.go('/onboarding');
      } else {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) _showErrorSnackbar(e.toString());
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await ref.read(authNotifierProvider.notifier).signInWithGoogle();

      if (!mounted) return;

      // Vérifie si onboarding est requis
      final authState = ref.read(authNotifierProvider);
      if (authState.isOnboardingRequired) {
        context.go('/onboarding');
      } else {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) _showErrorSnackbar(e.toString());
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.wrongRed,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _showForgotPasswordDialog() async {
    final TextEditingController resetEmailController = TextEditingController();
    
    // Fill with current email if available
    if (_emailController.text.isNotEmpty) {
      resetEmailController.text = _emailController.text;
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.bgLevel2
              : Colors.white,
          title: const Text('Mot de passe oublié ?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Entrez votre adresse email pour recevoir un lien de réinitialisation.'),
              const SizedBox(height: 16),
              TextField(
                controller: resetEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = resetEmailController.text.trim();
                if (email.isEmpty || !email.contains('@')) {
                  _showErrorSnackbar('Veuillez entrer une adresse email valide');
                  return;
                }
                
                Navigator.pop(context); // Close dialog
                
                try {
                  await ref.read(authNotifierProvider.notifier).sendPasswordResetEmail(email);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Un email de réinitialisation a été envoyé.'),
                        backgroundColor: AppColors.correctGreen,
                        duration: Duration(seconds: 4),
                      ),
                    );
                  }
                } catch (e) {
                  _showErrorSnackbar(e.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ❌ NE PAS METTRE ref.listen() DANS build() !
    // Cela cause des modifications d'état pendant la construction

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpaceBlue : AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  // Logo et titre
                  Column(
                    children: [
                      Icon(
                        Icons.language,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'LinguaVerse',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Apprenez sans limites',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Formulaire de connexion
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Lien mot de passe oublié
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        _showForgotPasswordDialog();
                      },
                      child: Text(
                        'Mot de passe oublié?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bouton de connexion
                  AuthButton(
                    label: 'Se connecter',
                    isLoading: authState.isLoading,
                    isEnabled: !authState.isLoading,
                    onPressed: _handleSignIn,
                  ),

                  const SizedBox(height: 20),

                  // Divider
                  const DividerWithText(text: 'ou'),

                  const SizedBox(height: 20),

                  // Bouton Google
                  SocialLoginButton(
                    label: 'Continuer avec Google',
                    icon: Icons.login,
                    isLoading: authState.isLoading,
                    onPressed: _handleGoogleSignIn,
                  ),

                  const SizedBox(height: 24),

                  // Lien inscription
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pas de compte? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.go('/signup'),
                        child: Text(
                          'S\'inscrire',
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
      ),
    );
  }
}
