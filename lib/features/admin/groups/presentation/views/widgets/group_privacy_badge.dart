// lib/features/admin/groups/presentation/views/widgets/group_privacy_badge.dart
import 'package:flutter/material.dart';

class GroupPrivacyBadge extends StatelessWidget {
  final bool isPrivate;

  const GroupPrivacyBadge({super.key, required this.isPrivate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isPrivate ? Colors.orange.shade500 : Colors.blue.shade500,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isPrivate ? Colors.orange : Colors.blue).withOpacity(0.3),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPrivate ? Icons.lock : Icons.public,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            isPrivate ? 'Privé' : 'Public',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}