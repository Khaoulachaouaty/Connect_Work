// lib/features/admin/employees/presentation/views/widgets/employee_avatar.dart
import 'package:flutter/material.dart';

class EmployeeAvatar extends StatelessWidget {
  final String fullName;
  final bool isActive;
  final double radius;

  const EmployeeAvatar({
    super.key,
    required this.fullName,
    required this.isActive,
    this.radius = 30,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Color _getAvatarColor(String name) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.pink];
    return colors[name.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _getAvatarColor(fullName);
    
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [BoxShadow(color: avatarColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
                : [],
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: avatarColor.withOpacity(0.2),
            child: CircleAvatar(
              radius: radius - 4,
              backgroundColor: avatarColor,
              child: Text(
                _getInitials(fullName),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: radius * 0.5,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: radius * 0.45,
            height: radius * 0.45,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2)],
            ),
          ),
        ),
      ],
    );
  }
}