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
      body: CustomScrollView(
        slivers: [
          ProfileAppBar(
            onEditTap: () {},
          ),
          SliverList(
            delegate: SliverChildListDelegate([
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
    );
  }
}