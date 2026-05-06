// lib/features/admin/employees/presentation/views/widgets/employee_status_dialog.dart
import 'package:flutter/material.dart';

class EmployeeStatusDialog extends StatelessWidget {
  final bool isActive;
  final VoidCallback onConfirm;

  const EmployeeStatusDialog({super.key, required this.isActive, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isActive ? 'Activer l\'employé' : 'Désactiver l\'employé'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Text(isActive ? 'Activer cet employé ?' : 'Désactiver cet employé ?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        TextButton(onPressed: () { Navigator.pop(context); onConfirm(); }, style: TextButton.styleFrom(foregroundColor: isActive ? Colors.green : Colors.red), child: Text(isActive ? 'Activer' : 'Désactiver')),
      ],
    );
  }
}