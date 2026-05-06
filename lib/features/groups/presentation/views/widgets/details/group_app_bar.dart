import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/services/service_locator.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../../auth/presentation/cubit/auth_state.dart';
import '../../../../../messages/data/models/chat_room_model.dart';
import '../../../../../messages/data/services/chat_service.dart';
import '../../../../data/services/group_service.dart';

class GroupAppBar extends StatelessWidget {
  final String imageUrl;
  final String groupId;
  final String groupName;
  final bool isMember;

  const GroupAppBar({
    super.key,
    required this.imageUrl,
    required this.groupId,
    required this.groupName,
    this.isMember = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColor.primary,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        if (isMember) ...[
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () => _openGroupChat(context),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'leave') {
                _showLeaveDialog(context);
              }
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'leave',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Quitter le groupe', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: imageUrl.isNotEmpty && imageUrl.startsWith('http')
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  void _showLeaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter le groupe ?'),
        content: const Text('Êtes-vous sûr de vouloir quitter ce groupe ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              final authState = context.read<AuthCubit>().state;
              if (authState is AuthAuthenticated) {
                try {
                  await GroupService().leaveGroup(groupId, authState.user.uid);
                  if (context.mounted) {
                    Navigator.pop(context); // Fermer le dialogue
                    Navigator.pop(context); // Retourner à la liste des groupes
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              }
            },
            child: const Text('Quitter', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openGroupChat(BuildContext context) async {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      await getIt<ChatService>().joinGroupChat(
        groupId,
        groupName,
        imageUrl,
        authState.user.uid,
      );

      if (context.mounted) {
        context.push('/chat-room', extra: ChatRoom(
          id: 'group_$groupId',
          name: groupName,
          avatar: imageUrl,
          isGroup: true,
          participants: [authState.user.uid],
          lastMessageTime: DateTime.now(),
          groupId: groupId,
        ));
      }
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.blue.shade50,
      child: Center(
        child: Icon(
          Icons.groups_rounded,
          size: 80,
          color: Colors.blue.shade200,
        ),
      ),
    );
  }
}