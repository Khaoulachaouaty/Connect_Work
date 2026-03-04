import 'package:flutter/material.dart';
import '../../../data/models/conversation.dart';
import 'conversation_item.dart';

class ConversationList extends StatelessWidget {
  final List<Conversation> conversations;

  const ConversationList({super.key, required this.conversations});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: conversations.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ConversationItem(conversation: conversations[index]);
      },
    );
  }
}