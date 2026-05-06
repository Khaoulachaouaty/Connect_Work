// lib/core/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/employees/presentation/views/admin_employee.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/reset_password_view.dart';
import '../../features/groups/data/models/group_modele.dart';
import '../../features/groups/presentation/views/group_detail_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/messages/presentations/views/messagesview.dart';
import '../../features/on_boarding/presentation/views/on_boarding_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/profile/presentation/views/edit_profile_view.dart';
import '../../features/notifications/presentation/views/notifications_view.dart';
import '../../features/admin/dashboard/presentation/views/admin_dashboard.dart';
import '../../features/admin/groups/presentation/views/admin_groups.dart';
import '../../features/create_post/presentation/views/create_post_view.dart';
import '../../features/groups/presentation/views/groups_view.dart';
import '../../features/messages/presentations/views/chat_room_view.dart';
import '../../features/messages/data/models/chat_room_model.dart';
import '../../features/posts/presentation/views/post_detail_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/posts/data/models/post_media.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final authCubit = context.read<AuthCubit>();
    final authState = authCubit.state;
    final isAuthenticated = authState is AuthAuthenticated;
    final isAdmin = isAuthenticated && (authState as AuthAuthenticated).user.role == 'admin';
    final location = state.matchedLocation;

    // Routes publiques
    const publicRoutes = ['/', '/login', '/reset-password', '/onboarding'];
    if (publicRoutes.contains(location)) return null;

    // Non authentifié -> login
    if (!isAuthenticated) return '/login';

    // Admin essayant d'accéder à une route non-admin
    if (isAdmin && !location.startsWith('/admin')) return '/admin';

    // Non-admin essayant d'accéder à /admin
    if (!isAdmin && location.startsWith('/admin')) return '/home';

    return null;
  },
  routes: [
    // Routes publiques
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/reset-password',
      name: 'reset-password',
      builder: (context, state) => const ResetPasswordView(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnBoardingView(),
    ),
    
    // Routes utilisateur
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/post-detail/:id',
      name: 'post-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final post = state.extra as Post?;
        return PostDetailView(postId: id, initialPost: post);
      },
    ),
    GoRoute(
      path: '/chat-room',
      name: 'chat-room',
      builder: (context, state) {
        final room = state.extra as ChatRoom;
        return ChatRoomView(room: room);
      },
    ),
    GoRoute(
      path: '/messages',
      name: 'messages',
      builder: (context, state) => const MessagesView(),
    ),
    GoRoute(
      path: '/create-post',
      name: 'create-post',
      builder: (context, state) {
        if (state.extra is Group) {
          return CreatePostView(initialGroup: state.extra as Group);
        }
        if (state.extra is Post) {
          return CreatePostView(existingPost: state.extra as Post);
        }
        return const CreatePostView();
      },
    ),
    GoRoute(
      path: '/groups',
      name: 'groups',
      builder: (context, state) => const GroupsView(),
    ),
    GoRoute(
      path: '/group/:id',
      name: 'group-detail',
      builder: (context, state) {
        final group = state.extra as Group?;
        if (group == null) {
          return const Scaffold(
            body: Center(child: Text('Groupe non trouvé')),
          );
        }
        return GroupDetailView(group: group);
      },
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: '/edit-profile',
      name: 'edit-profile',
      builder: (context, state) => const EditProfileView(),
    ),
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      builder: (context, state) => const NotificationsView(),
    ),
    
    // Routes Admin
    GoRoute(
      path: '/admin',
      name: 'admin',
      builder: (context, state) => const AdminDashboard(),
    ),
    GoRoute(
      path: '/admin/employees',
      name: 'admin-employees',
      builder: (context, state) => const AdminEmployees(),
    ),
    GoRoute(
      path: '/admin/groups',
      name: 'admin-groups',
      builder: (context, state) => const AdminGroups(),
    ),
  ],
);