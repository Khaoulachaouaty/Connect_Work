import 'package:flutter/material.dart';
import '../../../../messages/data/models/conversation.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Conversation conversation;

  const ChatAppBar({super.key, required this.conversation});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
      title: conversation.isGroup
          ? _buildGroupTitle()
          : _buildPrivateTitle(),
      actions: [
        if (!conversation.isGroup) ...[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam, color: Colors.black),
          ),
        ],
      ],
    );
  }

  Widget _buildGroupTitle() {
    return Column(
      children: [
        Text(
          conversation.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          conversation.role,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPrivateTitle() {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(conversation.avatar),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              conversation.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'En ligne',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}