import 'package:flutter/material.dart';
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
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              ProfileAppBar(onEditTap: () {}),
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 60),
                  const ProfileHeader(),
                  const SizedBox(height: 20),
                  const ProfileStats(),
                  const SizedBox(height: 24),
                  ProfileRecentPosts(),
                  const SizedBox(height: 20),
                ]),
              ),
            ],
          ),
          // Avatar positionné
          Positioned(
            top: 100, // Aligné avec le bouton Modifier
            left: 16,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 46,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=5',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}