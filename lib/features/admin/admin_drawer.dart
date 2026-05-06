// lib/features/admin/drawer/presentation/views/widgets/admin_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/presentation/cubit/auth_cubit.dart';
import '../auth/presentation/cubit/auth_state.dart';
import 'widgets/drawer_header.dart';
import 'widgets/drawer_logout_button.dart';
import 'widgets/drawer_menu_list.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final adminName = authState is AuthAuthenticated ? authState.user.fullName : 'Administrateur';
    final adminEmail = authState is AuthAuthenticated ? authState.user.email : 'admin@email.com';

    return Drawer(
      width: 280,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeaderWidget(adminName: adminName, adminEmail: adminEmail),
          const SizedBox(height: 8),
          const Expanded(child: DrawerMenuList()),
          const DrawerLogoutButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}