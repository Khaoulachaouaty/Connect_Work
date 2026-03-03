import 'package:flutter/material.dart';
import '../../../../core/utils/app_bar.dart';
import '../../../../core/utils/bottom_navbar.dart';
import '../../../posts/presentation/views/post_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppBar(
            title: 'Accueil',
            showSearch: true,
            showNotifications: true,
            onSearchTap: () {},
            onNotificationsTap: () {},
          ),
          SliverToBoxAdapter(
            child: PostView(),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}