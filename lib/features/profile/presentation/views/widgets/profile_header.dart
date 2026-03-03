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
          // Avatar avec marge négative corrigée
          Transform.translate(
            offset: const Offset(0, -40), // Moins de décalage
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 45, // Légèrement réduit
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
              ),
            ),
          ),
          
          // Contenu sans Transform
          Padding(
            padding: const EdgeInsets.only(top: 8), // Espace après avatar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sarah Martinez',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Product Manager',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.textSecondary,
                  ),
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
                _buildInfoItem(Icons.calendar_today_outlined, 'Membre depuis janvier 2024'),
              ],
            ),
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
          Icon(
            icon,
            size: 16,
            color: AppColor.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}