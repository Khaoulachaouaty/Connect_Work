import 'package:flutter/material.dart';
import '../../../../../posts/data/models/post_media.dart';
import '../../../../../posts/presentation/views/widgets/post_card.dart';

class GroupPublicationsTab extends StatelessWidget {
  const GroupPublicationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      Post(
        id: '1',
        authorName: 'Marc Dupont',
        authorRole: 'Développeur Senior',
        authorAvatar: 'https://i.pravatar.cc/150?img=11',
        content: 'Nouvelle mise à jour du framework disponible ! N\'oubliez pas de mettre à jour vos projets 🚀',
        timeAgo: 'Il y a 2h',
        mediaType: PostMediaType.none,
        likes: 12,
        comments: 4,
      ),
      Post(
        id: '2',
        authorName: 'Julie Bernard',
        authorRole: 'Designer UX/UI',
        authorAvatar: 'https://i.pravatar.cc/150?img=5',
        content: 'Code review à 15h aujourd\'hui. Préparez vos pull requests !',
        timeAgo: 'Il y a 5h',
        mediaType: PostMediaType.none,
        likes: 8,
        comments: 2,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[index]);
      },
    );
  }
}