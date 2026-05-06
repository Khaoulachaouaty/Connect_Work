// lib/features/admin/employees/presentation/views/widgets/employee_info.dart
import 'package:flutter/material.dart';
import 'employee_status_badge.dart';

class EmployeeInfo extends StatelessWidget {
  final String fullName;
  final String email;
  final String? function;
  final String? department;
  final bool isActive;

  const EmployeeInfo({
    super.key,
    required this.fullName,
    required this.email,
    this.function,
    this.department,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                fullName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isActive ? Colors.black87 : Colors.grey.shade600,
                ),
              ),
            ),
            if (!isActive) const EmployeeStatusBadge(isActive: false),
          ],
        ),
        const SizedBox(height: 6),
        _buildInfoRow(Icons.email_outlined, email),
        if (function != null) ...[
          const SizedBox(height: 4),
          _buildInfoRow(Icons.work_outline, function!),
        ],
        if (department != null) ...[
          const SizedBox(height: 4),
          _buildInfoRow(Icons.business_outlined, department!, isSmall: true),
        ],
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isSmall = false}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: isActive ? Colors.grey.shade500 : Colors.grey.shade400),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmall ? 11 : 12,
              color: isActive ? Colors.grey.shade600 : Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }
}