// lib/features/admin/employees/presentation/views/widgets/employee_form/form_header.dart
import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  final bool isEditing;

  const FormHeader({super.key, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade400],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            isEditing ? Icons.edit : Icons.person_add,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Modifier l\'employé' : 'Ajouter un employé',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isEditing 
                  ? 'Modifiez les informations de l\'employé'
                  : 'Remplissez les informations ci-dessous',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}