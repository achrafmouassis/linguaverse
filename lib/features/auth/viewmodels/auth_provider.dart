import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../repositories/local_user_service.dart';

// ============================================================================
// Services Providers
// ============================================================================

/// Provider pour le service d'authentification Firebase
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Provider pour le service de base de données locale
final localUserServiceProvider = Provider<LocalUserService>((ref) {
  return LocalUserService();
});

/// Provider pour le stockage sécurisé des tokens
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// ============================================================================
// Auth State
// ============================================================================

/// État de l'authentification
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;
  final bool isOnboardingRequired;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
    this.isOnboardingRequired = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
    bool? isOnboardingRequired,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isOnboardingRequired: isOnboardingRequired ?? this.isOnboardingRequired,
    );
  }

  @override
  String toString() =>
      'AuthState(user: $user, isLoading: $isLoading, isAuthenticated: $isAuthenticated, isOnboardingRequired: $isOnboardingRequired)';
}

// ============================================================================
// Auth State Notifier
// ============================================================================

/// Gère la logique d'authentification avec Riverpod
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final LocalUserService _localUserService;
  final FlutterSecureStorage _secureStorage;

  AuthNotifier(
      this._authRepository, this._localUserService, this._secureStorage)
      : super(const AuthState());

  /// Initialise l'authentification au démarrage de l'app
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      // Vérifie si l'utilisateur est actuellement connecté à Firebase
      final firebaseUser = _authRepository.currentUser;

      if (firebaseUser != null) {
        // Utilisateur connecté à Firebase, récupère depuis la BD locale
        final localUser = await _localUserService.getUser(firebaseUser.uid);

        if (localUser != null) {
          state = AuthState(
            user: localUser,
            isAuthenticated: true,
            isOnboardingRequired: !localUser.isOnboarded,
            isLoading: false,
          );
        } else {
          // Utilisateur Firebase mais pas en BD locale, crée un profil par défaut
          final newUser = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            displayName: firebaseUser.displayName,
            profileImageUrl: firebaseUser.photoURL,
            languageLevel: 'A1',
            learningGoal: 'CULTURE',
            dailyLearningMinutes: '15',
            preferredTheme: 'ARABIC',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isOnboarded: false,
          );

          // Sauvegarde dans Firestore
          debugPrint('📝 Saving user to Firestore during init: ${newUser.id}');
          await _authRepository.saveUserToFirestore(newUser);

          // Sauvegarde dans la base locale SQLite
          debugPrint('💾 Saving user to SQLite during init: ${newUser.id}');
          await _localUserService.saveUser(newUser);

          state = AuthState(
            user: newUser,
            isAuthenticated: true,
            isOnboardingRequired: true,
            isLoading: false,
          );
        }
      } else {
        // Pas d'utilisateur Firebase, vérifie s'il y a une session sauvegardée
        final savedToken = await _secureStorage.read(key: 'jwt_token');

        if (savedToken != null) {
          // Il y a un token sauvegardé, essaie de récupérer l'utilisateur depuis SQLite
          final allUsers = await _localUserService.getAllUsers();

          if (allUsers.isNotEmpty) {
            // Prend le dernier utilisateur connecté
            final lastUser = allUsers.first; // Ou logique pour trouver le dernier

            // Marque comme connecté mais avec un indicateur de reconnexion nécessaire
            state = AuthState(
              user: lastUser,
              isAuthenticated: true,
              isOnboardingRequired: !lastUser.isOnboarded,
              isLoading: false,
              errorMessage: 'Session expirée, veuillez vous reconnecter',
            );
          } else {
            state = const AuthState(isLoading: false);
          }
        } else {
          state = const AuthState(isLoading: false);
        }
      }
    } catch (e) {
      state = AuthState(
        isLoading: false,
        errorMessage: 'Erreur lors de l\'initialisation: ${e.toString()}',
      );
    }
  }

  /// Inscription avec email et mot de passe
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final userCredential = await _authRepository.signUpWithEmailPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('No user returned from signup');

      // Crée l'utilisateur dans la base locale
      final newUser = UserModel(
        id: user.uid,
        email: email,
        displayName: user.displayName,
        profileImageUrl: user.photoURL,
        languageLevel: 'A1',
        learningGoal: 'CULTURE',
        dailyLearningMinutes: '15',
        preferredTheme: 'ARABIC',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isOnboarded: false,
      );

      // Sauvegarde dans Firestore
      debugPrint('📝 Saving user to Firestore during signup: ${newUser.id}');
      await _authRepository.saveUserToFirestore(newUser);

      // Sauvegarde dans la base locale SQLite
      debugPrint('💾 Saving user to SQLite during signup: ${newUser.id}');
      await _localUserService.saveUser(newUser);

      // Sauvegarde le token JWT
      final idToken = await _authRepository.getIdToken();
      if (idToken != null) {
        await _secureStorage.write(key: 'jwt_token', value: idToken);
      }

      state = AuthState(
        user: newUser,
        isAuthenticated: true,
        isOnboardingRequired: true,
        isLoading: false,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur d\'inscription: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Connexion avec email et mot de passe
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final userCredential = await _authRepository.signInWithEmailPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('No user returned from signin');

      // Récupère ou crée l'utilisateur en base locale
      var localUser = await _localUserService.getUser(user.uid);
      localUser ??= UserModel(
        id: user.uid,
        email: email,
        displayName: user.displayName,
        profileImageUrl: user.photoURL,
        languageLevel: 'A1',
        learningGoal: 'CULTURE',
        dailyLearningMinutes: '15',
        preferredTheme: 'ARABIC',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isOnboarded: true, // Si reco, suppose onboarding fait
      );

      // Sauvegarde dans Firestore si c'est un nouvel utilisateur
      if (localUser.id == user.uid && await _isUserInFirestore(user.uid) == false) {
        debugPrint('📝 Saving user to Firestore during signin: ${localUser.id}');
        await _authRepository.saveUserToFirestore(localUser);
      }

      await _localUserService.saveUser(localUser);

      // Sauvegarde le token JWT
      final idToken = await _authRepository.getIdToken();
      if (idToken != null) {
        await _secureStorage.write(key: 'jwt_token', value: idToken);
      }

      state = AuthState(
        user: localUser,
        isAuthenticated: true,
        isOnboardingRequired: !localUser.isOnboarded,
        isLoading: false,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur de connexion: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Connexion avec Google
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final userCredential = await _authRepository.signInWithGoogle();

      final user = userCredential.user;
      if (user == null) throw Exception('No user returned from Google signin');

      // Récupère ou crée l'utilisateur en base locale
      var localUser = await _localUserService.getUser(user.uid);
      localUser ??= UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        profileImageUrl: user.photoURL,
        languageLevel: 'A1',
        learningGoal: 'CULTURE',
        dailyLearningMinutes: '15',
        preferredTheme: 'ARABIC',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isOnboarded: false,
      );

      // Sauvegarde dans Firestore si c'est un nouvel utilisateur
      if (localUser.id == user.uid && await _isUserInFirestore(user.uid) == false) {
        debugPrint('📝 Saving user to Firestore during Google signin: ${localUser.id}');
        await _authRepository.saveUserToFirestore(localUser);
      }

      await _localUserService.saveUser(localUser);

      // Sauvegarde le token JWT
      final idToken = await _authRepository.getIdToken();
      if (idToken != null) {
        await _secureStorage.write(key: 'jwt_token', value: idToken);
      }

      state = AuthState(
        user: localUser,
        isAuthenticated: true,
        isOnboardingRequired: !localUser.isOnboarded,
        isLoading: false,
      );
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur Google Sign-in: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Complète le processus d'onboarding
  Future<void> completeOnboarding({
    required String languageLevel,
    required String learningGoal,
    required String dailyLearningMinutes,
    required String preferredTheme,
  }) async {
    if (state.user == null) throw Exception('No user to onboard');

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _localUserService.updateUserOnboarding(
        userId: state.user!.id,
        languageLevel: languageLevel,
        learningGoal: learningGoal,
        dailyLearningMinutes: dailyLearningMinutes,
        preferredTheme: preferredTheme,
      );

      final updatedUser = state.user!.copyWith(
        languageLevel: languageLevel,
        learningGoal: learningGoal,
        dailyLearningMinutes: dailyLearningMinutes,
        preferredTheme: preferredTheme,
        isOnboarded: true,
      );

      state = AuthState(
        user: updatedUser,
        isAuthenticated: true,
        isOnboardingRequired: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur during onboarding: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.signOut();
      await _secureStorage.delete(key: 'jwt_token');
      state = const AuthState(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur de déconnexion: ${e.toString()}',
      );
    }
  }

  /// Envoie un email de réinitialisation du mot de passe
  Future<void> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authRepository.sendPasswordResetEmail(email: email);
      state = state.copyWith(isLoading: false);
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de l\'envoi de l\'email: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Met à jour l'XP de l'utilisateur
  Future<void> updateUserXP(int xpToAdd) async {
    if (state.user == null) return;
    try {
      final updatedUser = state.user!.copyWith(
        xpTotal: state.user!.xpTotal + xpToAdd,
      );
      
      // Update in local DB
      await _localUserService.saveUser(updatedUser);
      // Update in Firestore
      await _authRepository.saveUserToFirestore(updatedUser);
      
      state = state.copyWith(user: updatedUser);
    } catch (e) {
      debugPrint('Error updating user XP: $e');
    }
  }

  /// Efface le message d'erreur
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Vérifie si un utilisateur existe dans Firestore
  Future<bool> _isUserInFirestore(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return doc.exists;
    } catch (e) {
      debugPrint('❌ Error checking Firestore user existence: $e');
      return false;
    }
  }
}

// ============================================================================
// Riverpod Providers
// ============================================================================

/// Provider pour le notifier AuthNotifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final localUserService = ref.watch(localUserServiceProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  return AuthNotifier(authRepository, localUserService, secureStorage);
});

/// Provider pour streamer les changements d'authentification Firebase
final firebaseAuthStateProvider = StreamProvider<void>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges.map((user) {
    if (user != null) {
      // Utilise Future.delayed pour garantir que la mutation se fait dans le
      // prochain cycle de l'Event Loop (et non pas dans la microtask queue
      // qui pourrait s'exécuter avant la fin de la frame courante).
      Future.delayed(Duration.zero, () {
        ref.read(authNotifierProvider.notifier).initialize();
      });
    }
  });
});
