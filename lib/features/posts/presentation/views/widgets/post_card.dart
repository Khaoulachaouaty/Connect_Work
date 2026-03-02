import 'package:flutter/material.dart';
import '../../../data/models/post_media.dart';
import 'post_action.dart';
import 'post_header.dart';
import 'post_content.dart';
import 'post_media.dart';


class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(post: post),
          PostContent(content: post.content),
          if (post.mediaType != PostMediaType.none)
            PostMedia(post: post),
          PostActions(post: post),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}