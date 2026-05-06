// lib/features/admin/employees/presentation/views/widgets/employee_status_badge.dart
import 'package:flutter/material.dart';

class EmployeeStatusBadge extends StatelessWidget {
  final bool isActive;

  const EmployeeStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Actif' : 'Inactif',
        style: TextStyle(fontSize: 10, color: isActive ? Colors.green.shade700 : Colors.red.shade700, fontWeight: FontWeight.w500),
      ),
    );
  }
}