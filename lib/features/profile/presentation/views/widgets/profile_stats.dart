import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';

class ProfileStats extends StatelessWidget {
  final int publications;
  final int likes;
  final int groups;

  const ProfileStats({
    super.key,
    this.publications = 0,
    this.likes = 0,
    this.groups = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              number: publications.toString(),
              label: 'Posts',
              icon: Icons.article_outlined,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatItem(
              number: likes.toString(),
              label: 'Likes',
              icon: Icons.favorite_border_rounded,
              color: Colors.pink,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatItem(
              number: groups.toString(),
              label: 'Groupes',
              icon: Icons.groups_outlined,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.number,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            number,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}