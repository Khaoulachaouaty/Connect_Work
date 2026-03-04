import 'package:flutter/material.dart';
import '../../../messages/data/models/conversation.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/chat_message_list.dart';

class ChatView extends StatelessWidget {
  final Conversation conversation;

  const ChatView({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(conversation: conversation),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              isGroup: conversation.isGroup,
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}