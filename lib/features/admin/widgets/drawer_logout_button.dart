// lib/features/admin/drawer/presentation/views/widgets/drawer_logout_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/presentation/cubit/auth_cubit.dart';

class DrawerLogoutButton extends StatelessWidget {
  const DrawerLogoutButton({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().signOut();
              Navigator.pop(context);
              context.go('/login');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Déconnecter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.red.shade600),
        title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
        onTap: () => _logout(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}