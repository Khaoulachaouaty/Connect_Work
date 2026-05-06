import 'package:flutter/material.dart';
import '../../../../../core/widgets/app_card.dart';
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
    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.groupName != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50.withOpacity(0.5),
                border: Border(bottom: BorderSide(color: Colors.blue.shade100, width: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.groups_rounded, size: 14, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    post.groupName!,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          PostHeader(post: post),
          PostContent(content: post.content),
          if (post.mediaType != PostMediaType.none)
            PostMedia(post: post),
          const Divider(height: 1, color: Color(0xFFF8FAFC)),
          PostActions(post: post),
        ],
      ),
    );
  }
}