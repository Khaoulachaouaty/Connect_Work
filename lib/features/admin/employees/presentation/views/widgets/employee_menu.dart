// lib/features/admin/employees/presentation/views/widgets/employee_menu.dart
import 'package:flutter/material.dart';

class EmployeeMenu extends StatelessWidget {
  final bool isActive;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const EmployeeMenu({
    super.key,
    required this.isActive,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: isActive ? Colors.grey.shade600 : Colors.grey.shade400),
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      onSelected: (value) {
        if (value == 'edit') onEdit();
        if (value == 'toggle') onToggle();
        if (value == 'delete') onDelete();
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'edit',
          height: 44,
          child: Row(children: [Icon(Icons.edit_outlined, size: 20, color: Colors.blue), SizedBox(width: 12), Text('Modifier')]),
        ),
        PopupMenuItem(
          value: 'toggle',
          height: 44,
          child: Row(children: [Icon(isActive ? Icons.block_outlined : Icons.check_circle_outline, size: 20, color: isActive ? Colors.orange : Colors.green), SizedBox(width: 12), Text(isActive ? 'Désactiver' : 'Activer')]),
        ),
        const PopupMenuItem(
          value: 'delete',
          height: 44,
          child: Row(children: [Icon(Icons.delete_outline, size: 20, color: Colors.red), SizedBox(width: 12), Text('Supprimer')]),
        ),
      ],
    );
  }
}