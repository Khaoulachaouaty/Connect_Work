import 'package:connect_work/features/posts/data/models/post_media.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({super.key, required Post post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?img=11',
            ),
          ),
          const SizedBox(width: 12),
          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Marc Dupont',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Développeur Senior',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Il y a 2h',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Menu plus
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }
}