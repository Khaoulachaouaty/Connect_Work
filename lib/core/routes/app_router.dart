import 'package:connect_work/features/auth/presentation/views/login_view.dart';
import 'package:connect_work/features/home/presentation/views/home_view.dart';
import 'package:connect_work/features/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:connect_work/features/profile/presentation/views/profile_view.dart';
import 'package:go_router/go_router.dart';

import '../../features/create_post/presentation/views/create_post_view.dart';
import '../../features/groups/data/models/group_modele.dart';
import '../../features/groups/presentation/views/group_detail_view.dart';
import '../../features/groups/presentation/views/groups_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) => const SplashView(),
  ),
  GoRoute(
    path: "/login",
    builder: (context, state) => const LoginView(),
  ),
  GoRoute(
    path: "/onboarding",
    builder: (context, state) => const OnBoardingView(),
  ),
    GoRoute(
    path: "/home",
    builder: (context, state) => const HomeView(),
  ),
   GoRoute(
    path: "/create-post",
    builder: (context, state) => const CreatePostView(),
  ),
  GoRoute(
    path: "/groups",
    builder: (context, state) => const GroupsView(),
  ),
  GoRoute(
  path: '/group/:id',
  builder: (context, state) {
    final group = state.extra as Group;
    return GroupDetailView(group: group);
  },
  ),
  GoRoute(
    path: "/profile",
    builder: (context, state) => const ProfileView(),
  ),

  
]);