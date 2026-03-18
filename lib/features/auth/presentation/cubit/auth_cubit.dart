import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial()) {
    // Vérifier si déjà connecté au démarrage
    checkAuthStatus();
  }

  // Vérifier l'état initial
  void checkAuthStatus() async {
    final user = await _authService.getCurrentUserData();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // Connexion
  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Erreur de connexion'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _authService.signOut();
    emit(AuthUnauthenticated());
  }
}