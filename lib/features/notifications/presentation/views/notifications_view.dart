import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = getIt<NotificationService>();
    final authState = context.read<AuthCubit>().state;
    final userId = authState is AuthAuthenticated ? authState.user.uid : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Colors.black),
      ),
      body: userId.isEmpty
          ? const Center(child: Text('Veuillez vous connecter'))
            : StreamBuilder<List<NotificationModel>>(
              stream: notificationService.watchNotifications(userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur : ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final notifications = snapshot.data ?? [];
                
                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text('Aucune notification pour le moment', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifications[index];
                    return Container(
                      color: notif.isRead ? Colors.transparent : Colors.blue.withOpacity(0.03),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: notif.fromAvatar.isNotEmpty 
                                  ? NetworkImage(notif.fromAvatar) 
                                  : null,
                              child: notif.fromAvatar.isEmpty 
                                  ? Text(notif.fromName.isNotEmpty ? notif.fromName[0].toUpperCase() : '?') 
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: _getTypeColor(notif.type),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Icon(
                                  _getTypeIcon(notif.type),
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.4),
                            children: [
                              TextSpan(
                                text: notif.fromName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' ${notif.message}'),
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _formatTimeAgo(notif.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ),
                        trailing: !notif.isRead 
                            ? Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : null,
                        onTap: () async {
                          notificationService.markAsRead(notif.id);
                          if (notif.postId != null) {
                            context.push('/post-detail/${notif.postId}');
                          } else {
                            context.push('/home');
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.like: return Icons.favorite;
      case NotificationType.comment: return Icons.chat_bubble;
      case NotificationType.mention: return Icons.alternate_email;
      case NotificationType.system: return Icons.info;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.like: return Colors.red;
      case NotificationType.comment: return Colors.blue;
      case NotificationType.mention: return Colors.orange;
      case NotificationType.system: return Colors.grey;
    }
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    return 'Il y a ${diff.inDays} j';
  }
}
