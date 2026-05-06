// lib/features/admin/drawer/presentation/views/widgets/drawer_menu_list.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'drawer_menu_item.dart';

class DrawerMenuList extends StatelessWidget {
  const DrawerMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          DrawerMenuItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            route: '/admin',
            isActive: currentRoute == '/admin',
          ),
          DrawerMenuItem(
            icon: Icons.people_outline,
            title: 'Employés',
            route: '/admin/employees',
            isActive: currentRoute == '/admin/employees',
          ),
          DrawerMenuItem(
            icon: Icons.group_outlined,
            title: 'Groupes',
            route: '/admin/groups',
            isActive: currentRoute == '/admin/groups',
          ),
        ],
      ),
    );
  }
}