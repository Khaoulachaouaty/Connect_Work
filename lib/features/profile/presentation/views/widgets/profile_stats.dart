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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.inputBackground),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(number: publications.toString(), label: 'Publications'),
          _StatItem(number: likes.toString(), label: 'Likes reçus'),
          _StatItem(number: groups.toString(), label: 'Groupes'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColor.textSecondary,
          ),
        ),
      ],
    );
  }
}