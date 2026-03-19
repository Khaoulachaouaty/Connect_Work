import 'package:flutter/material.dart';
import '../../../../../posts/data/models/post_media.dart';
import '../../../../../posts/presentation/views/widgets/post_card.dart';

class GroupPublicationsTab extends StatelessWidget {
  const GroupPublicationsTab({super.key});

  @override
  Widget build(BuildContext context) {
       return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      //itemCount: posts.length,
      itemBuilder: (context, index) {
       // return PostCard(post: posts[index]);
      },
    );
  }
}