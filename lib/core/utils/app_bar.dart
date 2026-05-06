import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'app_colors.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

class SliverCustomAppBar extends StatelessWidget {
  const SliverCustomAppBar({
    super.key,
    required this.title,
    this.showSearch = true,
    this.showNotifications = true,
    this.showLogout = false,
    this.onSearchTap,
    this.onNotificationsTap,
    this.onMoreTap,
    this.actions,
  });

  final String title;
  final bool showSearch;
  final bool showNotifications;
  final bool showLogout;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onMoreTap;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(0.9),
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1F2937),
          fontSize: 24, // Reduced from 30
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        if (actions != null) ...actions!,
        if (showSearch)
          _buildActionIcon(
            icon: Icons.search_rounded,
            onTap: onSearchTap,
          ),
        if (showNotifications)
          _buildActionIcon(
            icon: Icons.notifications_none_rounded,
            onTap: onNotificationsTap,
          ),
        if (showLogout)
          _buildActionIcon(
            icon: Icons.logout_rounded,
            color: Colors.red.shade400,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Déconnexion'),
                  content: const Text('Voulez-vous vraiment vous déconnecter ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Déconnecter', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                await context.read<AuthCubit>().signOut();
                context.go('/login');
              }
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required VoidCallback? onTap,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: (color != null ? color.withOpacity(0.1) : Colors.grey.shade100),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: color ?? const Color(0xFF4B5563),
              size: 20, // Reduced from 34/30
            ),
          ),
        ),
      ),
    );
  }
}