import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../data/services/chat_service.dart';
import '../../data/models/chat_room_model.dart';
import '../../data/models/message_model.dart';

import 'widgets/message_bubble.dart';
import '../../../../core/widgets/user_avatar.dart';

import 'widgets/chat_input_field.dart';

class ChatRoomView extends StatefulWidget {
  final ChatRoom room;

  const ChatRoomView({
    super.key,
    required this.room,
  });

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return const Scaffold();
    
    final currentUser = authState.user;
    final displayName = widget.room.getDisplayName(currentUser.uid);
    final displayAvatar = widget.room.getDisplayAvatar(currentUser.uid);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            UserAvatar(
              imageUrl: displayAvatar,
              name: displayName,
              radius: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName, 
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w800, 
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.5,
                    )
                  ),
                  const Text(
                    'En ligne', 
                    style: TextStyle(
                      fontSize: 11, 
                      color: Color(0xFF10B981), 
                      fontWeight: FontWeight.w600
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF64748B)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey.shade100),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: getIt<ChatService>().watchMessages(widget.room.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data ?? [];
                
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUser.uid;
                    
                    return MessageBubble(message: message, isMe: isMe);
                  },
                );
              },
            ),
          ),
          ChatInputField(
            controller: _messageController,
            onSend: () => _sendMessage(currentUser.uid, currentUser.fullName, currentUser.photoUrl ?? ''),
            onAdd: () {},
          ),
        ],
      ),
    );
  }

  void _sendMessage(String userId, String userName, String userAvatar) {
    if (_messageController.text.trim().isEmpty) return;

    final message = Message(
      id: '',
      senderId: userId,
      senderName: userName,
      senderAvatar: userAvatar,
      content: _messageController.text.trim(),
      createdAt: DateTime.now(),
    );

    getIt<ChatService>().sendMessage(widget.room.id, message);
    _messageController.clear();
  }
}
