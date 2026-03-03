import 'package:flutter/material.dart';
import 'app_colors.dart';

class SliverCustomAppBar extends StatelessWidget {
  const SliverCustomAppBar({
    super.key,
    required this.title,
    this.showSearch = true,
    this.showNotifications = true,
    this.onSearchTap,
    this.onNotificationsTap,
    this.onMoreTap,
  });

  final String title;
  final bool showSearch;
  final bool showNotifications;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      elevation: 0,
      backgroundColor: AppColor.white,
      
      // NE PAS mettre de SafeArea ici, géré automatiquement
      automaticallyImplyLeading: false,
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
        if (showNotifications)
          IconButton(
            onPressed: onNotificationsTap,
            icon: const Icon(
              Icons.notifications_none_outlined,
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