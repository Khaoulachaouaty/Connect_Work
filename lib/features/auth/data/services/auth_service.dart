// lib/auth/data/services/auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // Getters
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Connexion avec email et mot de passe
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Authentification Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Erreur d\'authentification');
      }

      // Récupérer les données utilisateur depuis Firestore
      final userDoc = await _firestore
          .collection(Config.userCollection)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        await _firebaseAuth.signOut();
        throw Exception('Utilisateur non trouvé dans la base de données');
      }

      final userModel = UserModel.fromFirestore(userDoc);

      // Vérifier si le compte est actif
      if (!userModel.isActive) {
        await _firebaseAuth.signOut();
        throw Exception('Ce compte a été désactivé. Contactez l\'administrateur.');
      }

      // Mettre à jour la dernière connexion
      await _firestore
          .collection(Config.userCollection)
          .doc(userCredential.user!.uid)
          .update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  /// Inscription
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    String? gender,
  }) async {
    try {
      // Créer l'utilisateur Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Erreur lors de la création du compte');
      }

      // Mettre à jour le displayName
      await userCredential.user!.updateDisplayName(fullName);

      // Créer le document utilisateur dans Firestore
      final newUser = UserModel(
        uid: userCredential.user!.uid,
        email: email.trim(),
        fullName: fullName,
        phoneNumber: phoneNumber,
        gender: gender,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(Config.userCollection)
          .doc(newUser.uid)
          .set(newUser.toFirestore());

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    } catch (e) {
      throw Exception('Erreur lors de l\'inscription: ${e.toString()}');
    }
  }

  /// Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    } catch (e) {
      throw Exception('Erreur: ${e.toString()}');
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Récupérer l'utilisateur courant
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore
          .collection(Config.userCollection)
          .doc(user.uid)
          .get();

      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e) {
      debugPrint('Erreur getCurrentUser: $e');
      return null;
    }
  }

  /// Mettre à jour le profil utilisateur
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(Config.userCollection).doc(uid).update(data);
      
      // Si le nom est mis à jour, mettre à jour aussi dans Firebase Auth
      if (data.containsKey('fullName')) {
        await _firebaseAuth.currentUser?.updateDisplayName(data['fullName']);
      }
    } catch (e) {
      throw Exception('Erreur mise à jour profil: ${e.toString()}');
    }
  }

  /// Gestion des erreurs Firebase Auth
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun compte trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet email';
      case 'weak-password':
        return 'Le mot de passe doit contenir au moins 6 caractères';
      case 'invalid-email':
        return 'Adresse email invalide';
      case 'user-disabled':
        return 'Ce compte a été désactivé';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard';
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect';
      case 'network-request-failed':
        return 'Problème de connexion internet';
      default:
        return e.message ?? 'Une erreur est survenue';
    }
  }
}