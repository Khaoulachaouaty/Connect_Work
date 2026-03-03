import 'package:flutter/material.dart';
import '../../../../data/models/group_modele.dart';

class GroupInfo extends StatelessWidget {
  final Group group;

  const GroupInfo({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildMemberCount(),
            const SizedBox(height: 12),
            _buildDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCount() {
    return Row(
      children: [
        Icon(
          Icons.people_outline,
          size: 18,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 6),
        Text(
          '${group.memberCount} membres',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      'Discussions techniques et partage de connaissances entre développeurs',
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 14,
        height: 1.4,
      ),
    );
  }
}