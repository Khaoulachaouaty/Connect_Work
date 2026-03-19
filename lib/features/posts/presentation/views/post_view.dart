import 'package:connect_work/core/services/service_locator.dart';
import 'package:connect_work/features/posts/data/models/post_media.dart';
import 'package:connect_work/features/posts/data/services/post_service.dart';
import 'package:flutter/material.dart';
import 'widgets/post_card.dart';

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    final postService = getIt<PostService>();

    return StreamBuilder<List<Post>>(
      stream: postService.watchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur chargement posts : ${snapshot.error}'));
        }

        final posts = snapshot.data ?? [];
        if (posts.isEmpty) {
          return const Center(child: Text('Aucun post pour le moment'));
        }

        return Column(
          children: posts.map((post) => PostCard(post: post)).toList(),
        );
      },
    );
  }
}