// lib/features/admin/drawer/presentation/views/widgets/drawer_menu_item.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final bool isActive;

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue.shade50 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: isActive ? Colors.blue.shade600 : Colors.grey.shade600, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.blue.shade700 : Colors.grey.shade700,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}