import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_bar.dart';
import '../../../../core/utils/bottom_navbar.dart';
import '../../data/models/chat_room_model.dart';
import '../../data/services/chat_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class UserSearchDelegate extends SearchDelegate<ChatRoom?> {
  final String userId;
  UserSearchDelegate({required this.userId});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<UserModel>>(
      future: getIt<ChatService>().searchUsers(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return const Center(child: Text('Aucun utilisateur trouvé.'));
        }
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            if (user.uid == userId) return const SizedBox.shrink();
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child: user.photoUrl == null ? Text(user.fullName[0].toUpperCase()) : null,
              ),
              title: Text(user.fullName),
              subtitle: Text(user.function ?? 'Membre'),
              onTap: () async {
                try {
                  final authState = context.read<AuthCubit>().state;
                  final currentUserName = authState is AuthAuthenticated ? authState.user.fullName : 'Moi';
                  final currentUserAvatar = authState is AuthAuthenticated ? authState.user.photoUrl : '';

                  final roomId = await getIt<ChatService>().getOrCreateDirectChat(
                    userId,
                    user.uid,
                    currentUserName: currentUserName,
                    currentUserAvatar: currentUserAvatar,
                    otherUserName: user.fullName,
                    otherUserAvatar: user.photoUrl,
                  );
                  
                  if (context.mounted) {
                    final room = ChatRoom(
                      id: roomId,
                      name: user.fullName,
                      avatar: user.photoUrl ?? '',
                      participants: [userId, user.uid],
                      lastMessageTime: DateTime.now(),
                      userNames: {userId: currentUserName, user.uid: user.fullName},
                      userAvatars: {userId: currentUserAvatar ?? '', user.uid: user.photoUrl ?? ''},
                    );
                    
                    close(context, room);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur : $e')),
                    );
                  }
                }
              },
            );
          },
        );
      },
    );
  }
}

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return const Scaffold();
    
    final userId = authState.user.uid;
    final chatService = getIt<ChatService>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppBar(
            title: 'Messages',
            showSearch: false,
            showNotifications: true,
            showLogout: true,
            onNotificationsTap: () => context.push('/notifications'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.blue),
                onPressed: () async {
                  final ChatRoom? room = await showSearch<ChatRoom?>(
                    context: context,
                    delegate: UserSearchDelegate(userId: userId),
                  );
                  if (room != null && context.mounted) {
                    context.push('/chat-room', extra: room);
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<List<ChatRoom>>(
              stream: chatService.watchAllConversations(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ));
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text('Erreur : ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                    ),
                  );
                }

                final rooms = snapshot.data ?? [];

                if (rooms.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune discussion pour le moment.',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Recherchez un collègue pour commencer !',
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rooms.length,
                  separatorBuilder: (context, index) => Divider(height: 1, indent: 88, color: Colors.grey.shade100),
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return _ConversationTile(room: room);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ChatRoom room;
  const _ConversationTile({required this.room});

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
          CircleAvatar(
            radius: 28,
            backgroundColor: room.isGroup ? Colors.blue.shade50 : Colors.grey.shade100,
            backgroundImage: displayAvatar.isNotEmpty ? NetworkImage(displayAvatar) : null,
            child: displayAvatar.isEmpty 
                ? Text(displayName.isNotEmpty ? displayName[0].toUpperCase() : '?', 
                    style: TextStyle(color: room.isGroup ? Colors.blue : Colors.grey)) 
                : null,
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatTime(room.lastMessageTime),
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
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
                  color: room.lastMessage == 'Démarrez la discussion !' ? Colors.blue.shade300 : Colors.grey.shade600,
                  fontSize: 13,
                  fontStyle: room.lastMessage == 'Démarrez la discussion !' ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
            if (room.lastMessage == 'Démarrez la discussion !')
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'NOUVEAU',
                  style: TextStyle(fontSize: 9, color: Colors.blue.shade700, fontWeight: FontWeight.bold),
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
