import 'package:flutter/material.dart';
import '../../../../core/utils/app_bar.dart';
import '../../../../core/utils/bottom_navbar.dart';
import '../../data/models/conversation.dart';
import 'widgets/conversation_list.dart';
import 'widgets/message_serach_field.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = [
      Conversation(
        id: '1',
        name: 'Marc Dupont',
        avatar: 'https://i.pravatar.cc/150?img=11',
        role: 'Développeur Senior',
        lastMessage: 'Parfait, on fait ça demain alors !',
        time: 'Il y a 10min',
        unreadCount: 2,
        isGroup: false,
        memberCount: 5, // ← AJOUTER CECI
      ),
      Conversation(
        id: '2',
        name: 'Julie Bernard',
        avatar: 'https://i.pravatar.cc/150?img=5',
        role: 'Designer UX/UI',
        lastMessage: 'As-tu vu les nouveaux mockups ?',
        time: 'Il y a 1h',
        unreadCount: 0,
        isGroup: false,
        memberCount: 18, // ← AJOUTER CECI
      ),
      Conversation(
        id: '3',
        name: 'Thomas Laurent',
        avatar: 'https://i.pravatar.cc/150?img=3',
        role: 'Chef de Projet',
        lastMessage: 'Merci pour ton aide 👍',
        time: 'Hier',
        unreadCount: 0,
        isGroup: false,
        memberCount: 5, // ← AJOUTER CECI
      ),
      Conversation(
        id: '4',
        name: 'Équipe Development',
        avatar: 'https://i.pravatar.cc/150?img=8',
        role: 'Groupe • 12 membres',
        lastMessage: 'Nouvelle mise à jour déployée !',
        time: 'Il y a 2h',
        unreadCount: 5,
        isGroup: true,
        memberCount: 45, // ← AJOUTER CECI
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppBar(
            title: 'Messages',
            showSearch: false,
            showNotifications: true,
            onNotificationsTap: () {},
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const MessageSearchField(),
                  const SizedBox(height: 16),
                  ConversationList(conversations: conversations),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}
