import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/functions/navigation.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';

class ProfileAppBar extends StatelessWidget {
  final VoidCallback? onEditTap;

  const ProfileAppBar({super.key, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        onPressed: () => context.pop(),
      ),
      actions: [
        _AppBarButton(
          icon: Icons.settings_outlined,
          color: Colors.black87,
          onTap: onEditTap ?? () => _onEditTap(context),
        ),
        _AppBarButton(
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

  void _onEditTap(BuildContext context) {
    customNavigate(context, "/edit-profile");
  }
}

class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _AppBarButton({
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Material(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Icon(icon, color: color ?? Colors.black87, size: 20),
          ),
        ),
      ),
    );
  }
}
