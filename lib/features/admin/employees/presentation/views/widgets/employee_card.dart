// lib/features/admin/employees/presentation/views/widgets/employee_card.dart
import 'package:flutter/material.dart';
import '../../../data/models/employee_model.dart';
import 'employee_avatar.dart';
import 'employee_info.dart';
import 'employee_menu.dart';

class EmployeeCard extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onTap,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: employee.isActive ? 2 : 0,
        shadowColor: employee.isActive ? Colors.blue.shade200 : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: employee.isActive ? Colors.blue.shade100 : Colors.grey.shade200, width: 1),
        ),
        color: employee.isActive ? Colors.white : Colors.grey.shade50,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                EmployeeAvatar(fullName: employee.fullName, isActive: employee.isActive),
                const SizedBox(width: 16),
                Expanded(
                  child: EmployeeInfo(
                    fullName: employee.fullName,
                    email: employee.email,
                    function: employee.function,
                    department: employee.department,
                    isActive: employee.isActive,
                  ),
                ),
                EmployeeMenu(
                  isActive: employee.isActive,
                  onEdit: onEdit,
                  onToggle: onToggle,
                  onDelete: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}