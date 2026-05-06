import 'package:flutter/material.dart';
import '../../../../../../core/services/service_locator.dart';
import '../../../../../posts/data/models/post_media.dart';
import '../../../../../posts/data/services/post_service.dart';
import '../../../../../posts/presentation/views/widgets/post_card.dart';


class GroupPublicationsTab extends StatelessWidget {
  final String groupId;
  const GroupPublicationsTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final postService = getIt<PostService>();

    return StreamBuilder<List<Post>>(
      stream: postService.watchGroupPosts(groupId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }
        final posts = snapshot.data ?? [];
        if (posts.isEmpty) {
          return const Center(
            child: Text(
              'Aucune publication dans ce groupe.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostCard(post: posts[index]);
          },
        );
      },
    );
  }
}