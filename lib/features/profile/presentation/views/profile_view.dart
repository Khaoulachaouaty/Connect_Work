import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/service_locator.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/data/models/user_model.dart';

import '../../../posts/data/models/post_media.dart';
import '../../../posts/data/services/post_service.dart';
import 'widgets/profile_app_bar.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_recent_posts.dart';
import 'widgets/profile_stats.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;
            return StreamBuilder<List<Post>>(
              stream: getIt<PostService>().watchPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allPosts = snapshot.data ?? [];
                final userPosts = allPosts
                    .where((post) => post.authorId == user.uid)
                    .toList();
                final totalLikes = userPosts.fold<int>(
                  0,
                  (sum, post) => sum + post.likes,
                );
                const userGroupsCount =
                    0; // à améliorer quand on a le modèle de groupes

                return Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        ProfileAppBar(onEditTap: () {}),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: 60),
                            ProfileHeader(user: user),
                            const SizedBox(height: 20),
                            ProfileStats(
                              publications: userPosts.length,
                              likes: totalLikes,
                              groups: userGroupsCount,
                            ),
                            const SizedBox(height: 24),
                            ProfileRecentPosts(posts: userPosts),
                            const SizedBox(height: 20),
                          ]),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 100,
                      left: 16,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 46,
                          backgroundImage: NetworkImage(
                            user.photoUrl != null && user.photoUrl!.isNotEmpty
                                ? user.photoUrl!
                                : 'https://i.pravatar.cc/150?img=5',
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }

          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Center(child: Text('Aucun utilisateur connecté.'));
        },
      ),
    );
  }
}
