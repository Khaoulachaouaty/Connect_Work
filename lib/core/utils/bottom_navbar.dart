import 'package:connect_work/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../functions/navigation.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  void _onItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        customNavigate(context, "/home");
        break;
      case 1:
        customNavigate(context, "/groups");
        break;
      case 2:
        customNavigate(context, "/create-post");
        break;
      case 3:
        customNavigate(context, "/messages");
        break;
      case 4:
        customNavigate(context, "/profile");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border(top: BorderSide(color: AppColor.iconPrimary, width: 0)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Accueil',
                isActive: currentIndex == 0,
                onTap: () => _onItemTap(context, 0),
              ),
              _NavItem(
                icon: Icons.people_outline_outlined,
                activeIcon: Icons.people,
                label: 'Groupes',
                isActive: currentIndex == 1,
                onTap: () => _onItemTap(context, 1),
              ),
              _NavItem(
                icon: Icons.add_circle_outline,
                activeIcon: Icons.add_circle,
                label: 'Publier',
                isActive: currentIndex == 2,
                onTap: () => _onItemTap(context, 2),
                isCenter: true,
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble,
                label: 'Messages',
                isActive: currentIndex == 3,
                onTap: () => _onItemTap(context, 3),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
                isActive: currentIndex == 4,
                onTap: () => _onItemTap(context, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isCenter = false,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isCenter;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColor.primary : AppColor.iconPrimary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: isCenter ? 60 : 54,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: color,
              size: isCenter ? 42 : 30,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}