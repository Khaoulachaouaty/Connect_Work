import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream pour écouter l'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Getter pour l'utilisateur courant Firebase
  User? get currentUser => _auth.currentUser;

  // Connexion (l'admin a déjà créé le compte)
  Future<UserModel?> signIn(String email, String password) async {
    try {
      // 1. Connexion Firebase Auth
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) return null;

      // 2. Récupérer les infos depuis Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .get();

      if (!userDoc.exists) {
        await _auth.signOut();
        throw Exception('Utilisateur non trouvé dans la base de données');
      }

      final userModel = UserModel.fromFirestore(userDoc);

      // 3. Vérifier si le compte est actif
      if (!userModel.isActive) {
        await _auth.signOut();
        throw Exception('Ce compte a été désactivé. Contactez l\'administrateur.');
      }

      // 4. Mettre à jour la dernière connexion
      await _firestore.collection('users').doc(result.user!.uid).update({
        'lastLoginAt': Timestamp.now(),
      });

      return userModel;

    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Récupérer l'utilisateur connecté depuis Firestore
  Future<UserModel?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromFirestore(doc);
    } catch (e) {
      print('Erreur getCurrentUserData: $e');
      return null;
    }
  }

  // Gestion des erreurs Firebase Auth
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun compte trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-email':
        return 'Email invalide.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect.';
      case 'network-request-failed':
        return 'Problème de connexion internet.';
      default:
        return 'Erreur de connexion: ${e.message}';
    }
  }
}