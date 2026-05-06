import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../data/services/chat_service.dart';
import '../../data/models/chat_room_model.dart';
import '../../data/models/message_model.dart';

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
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return const Scaffold();
    
    final currentUser = authState.user;
    final displayName = widget.room.getDisplayName(currentUser.uid);
    final displayAvatar = widget.room.getDisplayAvatar(currentUser.uid);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: displayAvatar.isNotEmpty ? NetworkImage(displayAvatar) : null,
              child: displayAvatar.isEmpty ? Text(displayName.isNotEmpty ? displayName[0].toUpperCase() : '?') : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Text('En ligne', style: TextStyle(fontSize: 12, color: Colors.green)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Colors.black),
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
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUser.uid;
                    
                    return _MessageBubble(message: message, isMe: isMe);
                  },
                );
              },
            ),
          ),
          _buildInput(currentUser.uid, currentUser.fullName, currentUser.photoUrl ?? ''),
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

  Widget _buildInput(String userId, String userName, String userAvatar) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.add, color: Colors.blue), onPressed: () {}),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Écrivez un message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: () => _sendMessage(userId, userName, userAvatar),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 2),
              child: Text(message.senderName, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 16),
              ),
            ),
            child: Text(
              message.content,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              _formatTime(message.createdAt),
              style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
