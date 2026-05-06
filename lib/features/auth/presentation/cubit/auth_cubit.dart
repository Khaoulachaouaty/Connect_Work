// lib/auth/presentation/cubit/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial()) {
    _checkAuthStatus();
  }

  /// Vérifier si l'utilisateur est déjà connecté
  Future<void> _checkAuthStatus() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Connexion
  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authService.signIn(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Inscription
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    String? gender,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _authService.register(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        gender: gender,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    await _authService.signOut();
    emit(AuthUnauthenticated());
  }

  /// Mettre à jour le profil
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _authService.updateProfile(uid, data);
      final updatedUser = await _authService.getCurrentUser();
      if (updatedUser != null) {
        emit(AuthAuthenticated(updatedUser));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }
}