// lib/features/admin/groups/presentation/views/widgets/group_empty_state.dart
import 'package:flutter/material.dart';

class GroupEmptyState extends StatelessWidget {
  final String query;
  final VoidCallback onClear;
  final VoidCallback onAdd;

  const GroupEmptyState({
    super.key,
    required this.query,
    required this.onClear,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            query.isEmpty ? Icons.group_off : Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'Aucun groupe' : 'Aucun résultat',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          if (query.isNotEmpty)
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.clear),
              label: const Text('Effacer'),
            )
          else
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Créer un groupe'),
            ),
        ],
      ),
    );
  }
}