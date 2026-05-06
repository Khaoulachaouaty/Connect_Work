import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import '../../../../core/services/service_locator.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/data/models/user_model.dart';

import '../../../posts/data/models/post_media.dart';
import '../../../posts/data/services/post_service.dart';
import '../../../groups/data/services/group_service.dart';
import 'widgets/profile_app_bar.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_recent_posts.dart';
import 'widgets/profile_stats.dart';
import '../../../../core/utils/bottom_navbar.dart';

import 'widgets/profile_media_grid.dart';
import 'widgets/profile_about_section.dart';
import '../../../../core/widgets/sliver_app_bar_delegate.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const BottomNavBar(currentIndex: 4),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final user = state.user;
              return FutureBuilder<List>(
                future: Future.wait([
                  getIt<PostService>().watchPosts().first,
                  getIt<GroupService>().getUserGroups(user.uid),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final List<Post> allPosts = snapshot.data?[0] as List<Post>? ?? [];
                  final List userGroups = snapshot.data?[1] as List? ?? [];
                  
                  final userPosts = allPosts
                      .where((post) => post.authorId == user.uid)
                      .toList();
                  
                  final totalLikes = userPosts.fold<int>(
                    0,
                    (sum, post) => sum + post.likesCount,
                  );
                  
                  final userGroupsCount = userGroups.length;

                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      ProfileAppBar(onEditTap: () {
                        context.push('/edit-profile');
                      }),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          ProfileHeader(user: user),
                          const SizedBox(height: 20),
                          ProfileStats(
                            publications: userPosts.length,
                            likes: totalLikes,
                            groups: userGroupsCount,
                          ),
                          const SizedBox(height: 24),
                        ]),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          minHeight: 48,
                          maxHeight: 48,
                          child: Container(
                            color: Colors.white,
                            child: const TabBar(
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.blue,
                              tabs: [
                                Tab(text: 'Publications'),
                                Tab(text: 'Média'),
                                Tab(text: 'À propos'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    body: TabBarView(
                      children: [
                        ProfileRecentPosts(posts: userPosts),
                        ProfileMediaGrid(posts: userPosts),
                        ProfileAboutSection(user: user),
                      ],
                    ),
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
      ),
    );
  }
}
