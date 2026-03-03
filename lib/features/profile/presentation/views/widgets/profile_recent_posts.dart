import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';

class ProfileRecentPosts extends StatelessWidget {
  const ProfileRecentPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Publications récentes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _PostCard(
            content: 'Excellente réunion ce matin ! Notre nouveau projet prend forme 🚀',
            timeAgo: 'Il y a 2 jours',
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final String content;
  final String timeAgo;

  const _PostCard({required this.content, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.inputBackground),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            timeAgo,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}