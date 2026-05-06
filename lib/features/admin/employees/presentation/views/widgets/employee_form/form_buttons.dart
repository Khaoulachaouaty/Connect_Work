// lib/features/admin/employees/presentation/views/widgets/employee_form/form_buttons.dart
import 'package:flutter/material.dart';

class FormButtons extends StatelessWidget {
  final VoidCallback onSubmit;
  final bool isEditing;

  const FormButtons({
    super.key,
    required this.onSubmit,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.grey.shade400),
            ),
            child: const Text(
              'Annuler',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              isEditing ? 'Modifier' : 'Créer',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}