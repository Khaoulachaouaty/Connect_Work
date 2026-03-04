import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content without avatar (avatar is now positioned in Stack)
          const Text(
            'Sarah Martinez',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Product Manager',
            style: TextStyle(fontSize: 14, color: AppColor.textSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            'Passionate about building great products and leading amazing teams.',
            style: TextStyle(
              fontSize: 14,
              color: AppColor.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(Icons.email_outlined, 'sarah.martinez@company.com'),
          _buildInfoItem(Icons.location_on_outlined, 'Product Management'),
          _buildInfoItem(
            Icons.calendar_today_outlined,
            'Membre depuis janvier 2024',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColor.textSecondary),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 14, color: AppColor.textSecondary),
          ),
        ],
      ),
    );
  }
}