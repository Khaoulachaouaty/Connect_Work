// lib/features/admin/employees/presentation/views/widgets/employee_empty_state.dart
import 'package:flutter/material.dart';

class EmployeeEmptyState extends StatelessWidget {
  final String query;
  final VoidCallback onClear;
  final VoidCallback onAdd;

  const EmployeeEmptyState({
    super.key,
    required this.query,
    required this.onClear,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final hasQuery = query.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(hasQuery ? Icons.search_off : Icons.people_outline, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(hasQuery ? 'Aucun résultat pour "$query"' : 'Aucun employé', style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 16),
          if (hasQuery)
            TextButton.icon(onPressed: onClear, icon: const Icon(Icons.clear), label: const Text('Effacer'))
          else
            ElevatedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: const Text('Ajouter un employé')),
        ],
      ),
    );
  }
}