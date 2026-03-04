import 'package:connect_work/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class EditProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditProfileAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
      title: const Text(
        'Modifier le profil',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {
            // Sauvegarder
            Navigator.pop(context);
          },
          child: Text(
            'Enregistrer',
            style: TextStyle(
              color: AppColor.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}