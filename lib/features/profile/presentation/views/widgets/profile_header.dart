import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../auth/data/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const monthNames = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    final memberSince = '${monthNames[user.createdAt.month - 1]} ${user.createdAt.year}';
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content without avatar (avatar is now positioned in Stack)
          Text(
            user.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user.function ?? 'Fonction non renseignée',
            style: const TextStyle(fontSize: 14, color: AppColor.textSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            user.bio ?? 'Aucune biographie disponible.',
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(Icons.email_outlined, user.email),
          _buildInfoItem(
            Icons.location_on_outlined,
            user.function ?? 'Non défini',
          ),
          _buildInfoItem(
            Icons.calendar_today_outlined,
            'Membre depuis $memberSince',
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
