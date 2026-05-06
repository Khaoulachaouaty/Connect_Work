// lib/features/admin/groups/presentation/views/widgets/group_actions.dart
import 'package:flutter/material.dart';

class GroupActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GroupActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text('Modifier'),
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, size: 18),
          label: const Text('Supprimer'),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
        ),
      ],
    );
  }
}