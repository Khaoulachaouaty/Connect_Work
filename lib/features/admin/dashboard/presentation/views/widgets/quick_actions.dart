// lib/features/admin/dashboard/presentation/views/widgets/quick_actions.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ActionButton(
              icon: Icons.person_add,
              label: 'Employé',
              color: Colors.green,
              onTap: () => context.push('/admin/employees'),
            ),
            const SizedBox(width: 12),
            _ActionButton(
              icon: Icons.group_add,
              label: 'Groupe',
              color: Colors.blue,
              onTap: () => context.push('/admin/groups'),
            ),
            const SizedBox(width: 12),
            _ActionButton(
              icon: Icons.download,
              label: 'Export',
              color: Colors.purple,
              onTap: () => _showExportDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exporter les données'),
        content: const Text('Voulez-vous exporter les données en CSV ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exportation en cours...')),
              );
            },
            child: const Text('Exporter'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}