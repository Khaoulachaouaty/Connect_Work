import 'package:connect_work/features/posts/data/models/post_media.dart';
import 'package:flutter/material.dart';

class PostActions extends StatelessWidget {
  const PostActions({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _ActionButton(
            icon: Icons.favorite_outline,
            count: post.likes.toString(),
            onTap: () {
              // TODO: call postService.likePost(post.id);
            },
          ),
          const SizedBox(width: 24),
          _ActionButton(
            icon: Icons.chat_bubble_outline,
            count: post.comments.toString(),
            onTap: () {
              // TODO: open comments
            },
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final String count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            count,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}