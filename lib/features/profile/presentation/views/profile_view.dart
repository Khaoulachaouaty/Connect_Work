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
                        delegate: _SliverAppBarDelegate(
                          const TabBar(
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
                    ],
                    body: TabBarView(
                      children: [
                        ProfileRecentPosts(posts: userPosts),
                        _buildMediaGrid(userPosts),
                        _buildAboutSection(user),
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

  Widget _buildMediaGrid(List<Post> posts) {
    final mediaPosts = posts.where((p) => p.mediaType != PostMediaType.none).toList();
    if (mediaPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Aucun média partagé', style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: mediaPosts.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            mediaPosts[index].mediaUrl!,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget _buildAboutSection(UserModel user) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Expérience & Rôle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildAboutItem(Icons.work_outline, 'Rôle', user.role.toUpperCase()),
        _buildAboutItem(Icons.business_center_outlined, 'Poste', user.function ?? 'Non renseigné'),
        _buildAboutItem(Icons.email_outlined, 'Email', user.email),
        const SizedBox(height: 32),
        const Text('À propos de moi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text(
          user.bio ?? 'Cet utilisateur n\'a pas encore ajouté de biographie.',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildAboutItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 20, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
