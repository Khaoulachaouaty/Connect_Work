import 'package:flutter/material.dart';

import '../../../../core/utils/app_bar.dart';
import '../../../../core/utils/bottom_navbar.dart';
import '../../../posts/presentation/views/post_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Accueil',
        showSearch: true,
        showNotifications: true,
      ),
       body: const PostView(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}