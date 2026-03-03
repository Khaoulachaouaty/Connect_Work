import 'package:flutter/material.dart';
import '../../data/models/post_media.dart';
import 'widgets/post_card.dart';

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      // Post avec image
      Post(
        id: '1',
        authorName: 'Marc Dupont',
        authorRole: 'Développeur Senior',
        authorAvatar: 'https://i.pravatar.cc/150?img=11',
        content: 'Excellente réunion ce matin ! Notre nouveau projet prend forme. Hâte de voir les résultats 🚀',
        timeAgo: 'Il y a 2h',
        mediaType: PostMediaType.image,
        mediaUrl: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600',
        likes: 24,
        comments: 8,
      ),
      
      // Post avec vidéo
      Post(
        id: '2',
        authorName: 'Julie Bernard',
        authorRole: 'Designer UX/UI',
        authorAvatar: 'https://i.pravatar.cc/150?img=5',
        content: 'Nouveau design system disponible ! N\'hésitez pas à me faire vos retours 👇',
        timeAgo: 'Il y a 5h',
        mediaType: PostMediaType.video,
        mediaUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        likes: 42,
        comments: 12,
      ),
      
      // Post avec PDF
      Post(
        id: '3',
        authorName: 'Thomas Laurent',
        authorRole: 'Chef de Projet',
        authorAvatar: 'https://i.pravatar.cc/150?img=3',
        content: 'Voici le rapport de projet du mois de mars. Bonne lecture à tous !',
        timeAgo: 'Hier',
        mediaType: PostMediaType.pdf,
        mediaUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        fileName: 'Rapport_Projet_Mars_2024.pdf',
        likes: 15,
        comments: 3,
      ),
      
      // Post sans média
      Post(
        id: '4',
        authorName: 'Sophie Martin',
        authorRole: 'RH Manager',
        authorAvatar: 'https://i.pravatar.cc/150?img=9',
        content: 'Bienvenue à nos nouveaux collaborateurs qui rejoignent l\'équipe cette semaine ! 🎉 Nous sommes ravis de vous accueillir.',
        timeAgo: 'Il y a 2j',
        mediaType: PostMediaType.none,
        likes: 89,
        comments: 24,
      ),
      
      // Post avec image
      Post(
        id: '5',
        authorName: 'Lucas Bernard',
        authorRole: 'Développeur Mobile',
        authorAvatar: 'https://i.pravatar.cc/150?img=12',
        content: 'Flutter 3.19 est sorti ! Tellement hâte de tester les nouvelles fonctionnalités 🔥',
        timeAgo: 'Il y a 3j',
        mediaType: PostMediaType.image,
        mediaUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600',
        likes: 156,
        comments: 45,
      ),
    ];

    return Column(
      children: posts.map((post) => PostCard(post: post)).toList(),
    );
  }
}