// lib/features/admin/groups/presentation/views/widgets/group_card.dart
import 'package:flutter/material.dart';
import '../../../data/models/group_model.dart';
import 'group_banner.dart';
import 'group_stats.dart';
import 'group_actions.dart';

class GroupCard extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GroupCard({
    super.key,
    required this.group,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GroupBanner(
            imageUrl: group.imageUrl,
            isPrivate: group.isPrivate,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                if (group.description.isNotEmpty)
                  Text(
                    group.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 12),
                GroupStats(
                  memberCount: group.members.length,
                  createdAt: group.createdAt,
                ),
                const SizedBox(height: 12),
                GroupActions(
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}