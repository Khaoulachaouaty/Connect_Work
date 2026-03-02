import 'package:flutter/material.dart';

import 'app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showSearch = true,
    this.showNotifications = true,  // ← NOUVEAU
    this.onSearchTap,
    this.onNotificationsTap,         // ← NOUVEAU
    this.onMoreTap,
  });

  final String title;
  final bool showSearch;
  final bool showNotifications;      // ← NOUVEAU
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationsTap;  // ← NOUVEAU
  final VoidCallback? onMoreTap;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColor.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (showSearch)
          IconButton(
            onPressed: onSearchTap,
            icon: const Icon(
              Icons.search,
              color: AppColor.iconPrimary,
              size: 34,
            ),
          ),
        if (showNotifications)  // ← NOUVEAU
          IconButton(
            onPressed: onNotificationsTap,
            icon: const Icon(
              Icons.notifications_none_outlined,  // ← Icône notification
              color: AppColor.iconPrimary,
              size: 30,
            ),
          ),
        if (onMoreTap != null)
          IconButton(
            onPressed: onMoreTap,
            icon: const Icon(
              Icons.more_vert,
              color: AppColor.black,
            ),
          ),
      ],
    );
  }
}