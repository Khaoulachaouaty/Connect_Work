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

import 'widgets/conversation_tile.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/user_avatar.dart';

import 'widgets/user_search_delegate.dart';

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
                icon: const Icon(Icons.search_rounded, color: Colors.blue),
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
                  return const AppEmptyState(
                    title: 'Aucune discussion',
                    subtitle: 'Recherchez un collègue pour commencer à discuter !',
                    icon: Icons.chat_bubble_outline_rounded,
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: rooms.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 80, color: Color(0xFFF1F5F9)),
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return ConversationTile(room: room);
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
