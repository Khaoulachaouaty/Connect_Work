import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widgets/user_avatar.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../data/models/chat_room_model.dart';

class ConversationTile extends StatelessWidget {
  final ChatRoom room;
  const ConversationTile({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final currentUserId = authState is AuthAuthenticated ? authState.user.uid : '';
    final displayName = room.getDisplayName(currentUserId);
    final displayAvatar = room.getDisplayAvatar(currentUserId);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          UserAvatar(
            imageUrl: displayAvatar,
            name: displayName,
            radius: 28,
            backgroundColor: room.isGroup ? Colors.blue.shade50 : Colors.grey.shade100,
            textColor: room.isGroup ? Colors.blue : Colors.grey,
          ),
          if (room.isGroup)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.groups, size: 10, color: Colors.white),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              displayName,
              style: const TextStyle(
                fontWeight: FontWeight.w700, 
                fontSize: 15,
                color: Color(0xFF1E293B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatTime(room.lastMessageTime),
            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                room.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: room.lastMessage == 'Démarrez la discussion !' ? Colors.blue.shade400 : const Color(0xFF64748B),
                  fontSize: 13,
                  fontStyle: room.lastMessage == 'Démarrez la discussion !' ? FontStyle.italic : FontStyle.normal,
                  fontWeight: room.lastMessage == 'Démarrez la discussion !' ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            if (room.lastMessage == 'Démarrez la discussion !')
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'NOUVEAU',
                  style: TextStyle(fontSize: 9, color: Colors.blue.shade700, fontWeight: FontWeight.w800),
                ),
              ),
          ],
        ),
      ),
      onTap: () {
        context.push('/chat-room', extra: room);
      },
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} j';
    }
    return '${date.day}/${date.month}';
  }
}
