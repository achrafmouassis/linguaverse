import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Exception personnalisée pour les erreurs d'authentification
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Repository pour la gestion Firebase Auth
/// Gère l'authentification Email/Password et Google Sign-in
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Obtient l'utilisateur actuellement connecté
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream des changements d'authentification
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Inscription avec email et mot de passe
  /// Durée estimée : 2-3 secondes
  Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw AuthException('Signup timeout'),
          );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        _mapException(e.code, action: 'signup'),
        code: e.code,
      );
    }
  }

  /// Connexion avec email et mot de passe
  /// Durée estimée : 1-2 secondes
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw AuthException('Signin timeout'),
          );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        _mapException(e.code, action: 'signin'),
        code: e.code,
      );
    }
  }

  /// Connexion avec Google
  /// Durée estimée : 2-3 secondes (dépend de la latence réseau)
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Lance le flux d'authentification Google
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn().timeout(
                const Duration(seconds: 10),
                onTimeout: () => throw AuthException('Google signin timeout'),
              );

      if (googleUser == null) {
        throw AuthException('Google signin cancelled by user');
      }

      // Obtient les tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication.timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw AuthException('Google auth token timeout'),
      );

      // Crée les credentials pour Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connecte-toi à Firebase
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential).timeout(
                const Duration(seconds: 10),
                onTimeout: () => throw AuthException('Firebase signin timeout'),
              );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        _mapException(e.code, action: 'google_signin'),
        code: e.code,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Google sign-in failed: ${e.toString()}');
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Signout failed: ${e.toString()}');
    }
  }

  /// Envoie un email de réinitialisation du mot de passe
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim()).timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw AuthException('Password reset email timeout'),
          );
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        _mapException(e.code, action: 'password_reset'),
        code: e.code,
      );
    }
  }

  /// Vérifie si l'email est déjà utilisé
  /// Note: La vérification réelle se fera lors de signUpWithEmailPassword
  /// car Firebase lèvera une exception 'email-already-in-use'
  Future<bool> isEmailRegistered({required String email}) async {
    try {
      // Retourne false because Firebase handles the verification during signup
      return false;
    } catch (e) {
      throw AuthException('Failed to check email: ${e.toString()}');
    }
  }

  /// Obtient un JWT token pour la persistance
  Future<String?> getIdToken() async {
    try {
      return await currentUser?.getIdToken();
    } catch (e) {
      throw AuthException('Failed to get ID token: ${e.toString()}');
    }
  }

  /// Sauvegarde un utilisateur dans Firestore
  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      debugPrint('🔥 Attempting to save user to Firestore: ${user.id}');
      debugPrint('🔥 Firebase apps count: ${Firebase.apps.length}');

      if (Firebase.apps.isEmpty) {
        debugPrint('❌ Firebase not initialized, cannot save to Firestore');
        throw AuthException('Firebase not initialized');
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toFirestore())
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw AuthException('Firestore save timeout'),
          );
      debugPrint('✅ User saved to Firestore successfully: ${user.id}');
    } catch (e) {
      debugPrint('❌ Failed to save user to Firestore: $e');
      throw AuthException('Failed to save user to Firestore: ${e.toString()}');
    }
  }

  /// Mappe les codes d'erreur Firebase aux messages français lisibles
  static String _mapException(String code, {required String action}) {
    switch (code) {
      case 'weak-password':
        return 'Le mot de passe est trop faible. Utilisez au moins 6 caractères.';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'invalid-email':
        return 'L\'adresse email n\'est pas valide.';
      case 'user-disabled':
        return 'Cet utilisateur a été désactivé.';
      case 'user-not-found':
        return 'Utilisateur non trouvé.';
      case 'wrong-password':
        return 'Le mot de passe est incorrect.';
      case 'operation-not-allowed':
        return 'Cette opération n\'est pas autorisée.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      case 'network-request-failed':
        return 'Erreur réseau. Vérifiez votre connexion.';
      default:
        return 'Une erreur d\'authentification s\'est produite. Réessayez.';
    }
  }
}
