import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/functions/navigation.dart';

class ProfileAppBar extends StatelessWidget {
  final VoidCallback? onEditTap;

  const ProfileAppBar({super.key, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      floating: false,
      elevation: 0,
      backgroundColor: AppColor.primary,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: AppColor.primary),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 20),
          child: _EditButton(
            onTap: onEditTap ?? () => _onEditTap(context),
          ),
        ),
      ],
    );
  }

  void _onEditTap(BuildContext context) {
    print('Clic sur Modifier'); // Debug
    customNavigate(context, "/edit-profile");
  }
}

class _EditButton extends StatelessWidget {
  final VoidCallback onTap;

  const _EditButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.settings_outlined,
                size: 16,
                color: AppColor.textPrimary,
              ),
              const SizedBox(width: 6),
              Text(
                'Modifier',
                style: TextStyle(
                  color: AppColor.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
