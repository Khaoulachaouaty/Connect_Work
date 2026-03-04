import 'package:flutter/material.dart';
import '../../../data/model/message.dart';
import 'message_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final bool isGroup;

  const ChatMessageList({super.key, required this.isGroup});

  @override
  Widget build(BuildContext context) {
    final messages = [
      Message(
        id: '1',
        senderName: 'Marc Dupont',
        senderAvatar: 'https://i.pravatar.cc/150?img=11',
        content: 'Salut ! Tu as le temps pour une réunion rapide ?',
        time: '10:30',
        isMe: false,
        showSender: true,
      ),
      Message(
        id: '2',
        senderName: 'Moi',
        senderAvatar: '',
        content: 'Oui bien sûr ! À quelle heure ?',
        time: '10:32',
        isMe: true,
      ),
      Message(
        id: '3',
        senderName: 'Marc Dupont',
        senderAvatar: 'https://i.pravatar.cc/150?img=11',
        content: 'Demain à 14h ça te va ?',
        time: '10:35',
        isMe: false,
        showSender: false,
      ),
      Message(
        id: '4',
        senderName: 'Moi',
        senderAvatar: '',
        content: 'Parfait, on fait ça demain alors !',
        time: '10:36',
        isMe: true,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageBubble(
          message: messages[index],
          isGroup: isGroup,
        );
      },
    );
  }
}