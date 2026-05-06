import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connect_work/core/services/service_locator.dart';
import 'package:connect_work/core/widgets/app_empty_state.dart';
import 'package:connect_work/core/widgets/user_avatar.dart';
import 'package:connect_work/features/auth/data/models/user_model.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_state.dart';
import 'package:connect_work/features/messages/data/models/chat_room_model.dart';
import 'package:connect_work/features/messages/data/services/chat_service.dart';

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
          return const AppEmptyState(
            title: 'Aucun utilisateur trouvé',
            subtitle: 'Vérifiez l\'orthographe ou essayez un autre nom.',
            icon: Icons.person_search_rounded,
          );
        }
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            if (user.uid == userId) return const SizedBox.shrink();
            return ListTile(
              leading: UserAvatar(
                imageUrl: user.photoUrl,
                name: user.fullName,
                radius: 20,
              ),
              title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
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
