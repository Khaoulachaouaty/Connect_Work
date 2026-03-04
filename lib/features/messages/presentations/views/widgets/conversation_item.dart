import 'package:flutter/material.dart';
import '../../../../chat/presentataions/views/chat_view.dart';
import '../../../data/models/conversation.dart';
import 'unread_badge.dart';

class ConversationItem extends StatelessWidget {
  final Conversation conversation;

  const ConversationItem({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(conversation.avatar),
          ),
          if (conversation.isGroup)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.group,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            conversation.time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conversation.role,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  conversation.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: conversation.unreadCount > 0
                        ? Colors.black
                        : Colors.grey.shade600,
                    fontWeight: conversation.unreadCount > 0
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (conversation.unreadCount > 0)
                UnreadBadge(count: conversation.unreadCount),
            ],
          ),
        ],
      ),
      onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatView(conversation: conversation),
        ),
      );
    },
    );
  }
}