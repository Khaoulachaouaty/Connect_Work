import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/app_colors.dart';

class CreatePostAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onPublish;

  const CreatePostAppBar({super.key, required this.onPublish});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.close, color: AppColor.black),
      ),
      title: const Text(
        'Créer une publication',
        style: TextStyle(
          color: AppColor.black,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ElevatedButton(
            onPressed: onPublish,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Publier',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}