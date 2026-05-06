import 'package:flutter/material.dart';
import 'package:connect_work/features/posts/data/models/post_media.dart';

class ProfileMediaGrid extends StatelessWidget {
  final List<Post> posts;
  const ProfileMediaGrid({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    final mediaPosts = posts.where((p) => p.mediaType != PostMediaType.none).toList();
    if (mediaPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Aucun média partagé', style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: mediaPosts.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            mediaPosts[index].mediaUrl!,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
