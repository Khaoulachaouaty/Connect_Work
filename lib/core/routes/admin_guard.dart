// lib/features/admin/presentation/views/admin_access_guard.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/admin/dashboard/presentation/views/admin_dashboard.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';

class AdminAccessGuard extends StatelessWidget {
  const AdminAccessGuard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthAuthenticated) {
          // Vérifie si l'utilisateur est admin
          if (state.user.role == 'admin') {
            return const AdminDashboard();  // ← Changé: utiliser le vrai dashboard
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text('Accès refusé')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Accès réservé aux administrateurs',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vous n\'avez pas les permissions nécessaires',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Retour'),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Connexion requise')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.login,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Veuillez vous connecter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Retour'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}