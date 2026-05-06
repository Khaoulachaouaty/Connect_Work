import 'package:flutter/material.dart';
import 'package:connect_work/core/utils/app_colors.dart';
import '../functions/navigation.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  void _onItemTap(BuildContext context, int index) {
    if (currentIndex == index) return;
    switch (index) {
      case 0: customNavigate(context, "/home"); break;
      case 1: customNavigate(context, "/groups"); break;
      case 2: customNavigate(context, "/create-post"); break;
      case 3: customNavigate(context, "/messages"); break;
      case 4: customNavigate(context, "/profile"); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Accueil',
                isActive: currentIndex == 0,
                onTap: () => _onItemTap(context, 0),
              ),
              _NavItem(
                icon: Icons.people_outline_rounded,
                activeIcon: Icons.people_rounded,
                label: 'Groupes',
                isActive: currentIndex == 1,
                onTap: () => _onItemTap(context, 1),
              ),
              _CenterNavItem(
                onTap: () => _onItemTap(context, 2),
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: 'Messages',
                isActive: currentIndex == 3,
                onTap: () => _onItemTap(context, 3),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
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
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColor.primary : Colors.grey.shade500;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: color,
              size: 24, // Reduced from 28
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10, // Reduced from 11
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterNavItem extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterNavItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, // Reduced from 52
        height: 48, // Reduced from 52
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColor.primary, Color(0xFF6366F1)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 26, // Reduced from 30
        ),
      ),
    );
  }
}