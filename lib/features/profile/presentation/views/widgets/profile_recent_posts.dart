import 'package:flutter/material.dart';
import '../../../../posts/data/models/post_media.dart';
import '../../../../posts/presentation/views/widgets/post_card.dart';

class ProfileRecentPosts extends StatelessWidget {
  final List<Post> posts;

  const ProfileRecentPosts({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Aucune publication pour le moment',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: posts.length,
      itemBuilder: (context, index) => PostCard(post: posts[index]),
    );
  }
}
