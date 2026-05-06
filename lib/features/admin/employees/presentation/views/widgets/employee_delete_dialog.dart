// lib/features/admin/employees/presentation/views/widgets/employee_delete_dialog.dart
import 'package:flutter/material.dart';
import '../../../data/models/employee_model.dart';

class EmployeeDeleteDialog extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onConfirm;

  const EmployeeDeleteDialog({super.key, required this.employee, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Supprimer l\'employé'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Voulez-vous vraiment supprimer ${employee.fullName} ?'),
          const SizedBox(height: 8),
          Text('⚠️ Cette action est irréversible.', style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
          const SizedBox(height: 4),
          Text('Toutes les données associées seront perdues.', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        ElevatedButton(onPressed: () { Navigator.pop(context); onConfirm(); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Supprimer définitivement')),
      ],
    );
  }
}