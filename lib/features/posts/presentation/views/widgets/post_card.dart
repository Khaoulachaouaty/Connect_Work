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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(post: post),
          PostContent(content: post.content),
          if (post.mediaType != PostMediaType.none)
            PostMedia(post: post),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          PostActions(post: post),
        ],
      ),
    );
  }
}