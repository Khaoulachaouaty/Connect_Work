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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 52,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.blue.shade50,
                  backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null || user.photoUrl!.isEmpty
                      ? Text(
                          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColor.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user.function ?? 'Professionnel',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (user.bio != null && user.bio!.isNotEmpty) ...[
                  Text(
                    user.bio!,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Row(
                  children: [
                    _buildModernInfo(Icons.alternate_email, user.email.split('@').first),
                    const SizedBox(width: 12),
                    _buildModernInfo(Icons.calendar_month_outlined, '${user.createdAt.year}'),
                    const SizedBox(width: 12),
                    _buildModernInfo(Icons.work_outline, user.role.toUpperCase()),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildModernInfo(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
