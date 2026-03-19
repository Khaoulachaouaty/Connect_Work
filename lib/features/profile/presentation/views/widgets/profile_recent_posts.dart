import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../posts/data/models/post_media.dart';

class ProfileRecentPosts extends StatelessWidget {
  final List<Post> posts;

  const ProfileRecentPosts({super.key, required this.posts});

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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (posts.isEmpty)
            Text(
              'Aucune publication récente.',
              style: TextStyle(color: AppColor.textSecondary),
            )
          else
            ...posts
                .take(3)
                .map(
                  (post) => _PostCard(
                    content: post.content,
                    timeAgo: _formatTimeAgo(post.createdAt),
                  ),
                ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} j';
    return 'Le ${date.day}/${date.month}/${date.year}';
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
          Text(content, style: const TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 8),
          Text(
            timeAgo,
            style: TextStyle(fontSize: 12, color: AppColor.textSecondary),
          ),
        ],
      ),
    );
  }
}
