// lib/features/admin/groups/presentation/views/widgets/group_stats.dart
import 'package:flutter/material.dart';

class GroupStats extends StatelessWidget {
  final int memberCount;
  final DateTime createdAt;

  const GroupStats({
    super.key,
    required this.memberCount,
    required this.createdAt,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return "aujourd'hui";
    if (diff.inDays == 1) return 'hier';
    if (diff.inDays < 7) return 'il y a ${diff.inDays} jours';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildChip(Icons.people_outline, '$memberCount membres'),
        const SizedBox(width: 8),
        _buildChip(Icons.calendar_today_outlined, _formatDate(createdAt)),
      ],
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}