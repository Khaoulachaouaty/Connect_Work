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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                _buildPrivacyBadge(),
              ],
            ),
            const SizedBox(height: 12),
            _buildMemberCount(),
            const SizedBox(height: 20),
            Text(
              'À propos de ce groupe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              group.description.isNotEmpty 
                ? group.description 
                : 'Aucune description disponible pour ce groupe.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: group.isPrivate ? Colors.orange.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            group.isPrivate ? Icons.lock_rounded : Icons.public_rounded,
            size: 14,
            color: group.isPrivate ? Colors.orange.shade700 : Colors.green.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            group.isPrivate ? 'Privé' : 'Public',
            style: TextStyle(
              color: group.isPrivate ? Colors.orange.shade700 : Colors.green.shade700,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCount() {
    return Row(
      children: [
        Stack(
          children: List.generate(3, (index) => Padding(
            padding: EdgeInsets.only(left: index * 16.0),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, size: 12, color: Colors.blue),
              ),
            ),
          )),
        ),
        const SizedBox(width: 12),
        Text(
          '${group.memberCount} membres',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}