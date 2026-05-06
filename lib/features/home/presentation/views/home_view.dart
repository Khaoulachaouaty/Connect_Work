import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_bar.dart';
import '../../../../core/utils/bottom_navbar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../posts/presentation/views/post_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;
          return CustomScrollView(
            slivers: [
              SliverCustomAppBar(
                title: 'Accueil',
                showSearch: true,
                showNotifications: true,
                showLogout: true,
                onSearchTap: () {},
                onNotificationsTap: () => context.push('/notifications'),
              ),
              if (user != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () => context.push('/create-post'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.blue.shade50,
                              backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                                  ? NetworkImage(user.photoUrl!)
                                  : null,
                              child: user.photoUrl == null || user.photoUrl!.isEmpty
                                  ? Text(
                                      user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Quoi de neuf, ${user.fullName.split(' ').first} ?",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.image_outlined, color: Colors.blue.shade700, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: PostView(),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}