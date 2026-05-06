import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connect_work/core/utils/app_colors.dart';

import '../../../../core/utils/app_bar.dart';
import '../../../../core/utils/bottom_navbar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../data/models/group_modele.dart';
import '../../data/services/group_service.dart';
import '../cubit/groups_cubit.dart';
import 'widgets/group_card.dart';
import 'widgets/groups_search_field.dart';
import '../../../../core/widgets/app_empty_state.dart';

import 'widgets/groups_list.dart';
import '../../../../core/widgets/sliver_app_bar_delegate.dart';

import 'widgets/create_group_dialog.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocProvider(
      create: (context) => GroupsCubit(GroupService(), userId)..loadGroups(),
      child: DefaultTabController(
        length: 4,
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final isAdmin = authState is AuthAuthenticated && authState.user.role == 'admin';
            
            return Scaffold(
              backgroundColor: const Color(0xFFF1F5F9),
              floatingActionButton: isAdmin ? _buildFAB(context) : null,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverCustomAppBar(
                    title: 'Groupes',
                    showSearch: true,
                    showNotifications: true,
                    showLogout: true,
                    onSearchTap: () {},
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: GroupSearchField(),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      minHeight: 48,
                      maxHeight: 48,
                      child: Container(
                        color: Colors.white,
                        child: TabBar(
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorPadding: const EdgeInsets.symmetric(vertical: 8),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF2563EB).withOpacity(0.1),
                          ),
                          labelColor: const Color(0xFF2563EB),
                          unselectedLabelColor: const Color(0xFF64748B),
                          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                          tabs: const [
                            Tab(text: 'Tous'),
                            Tab(text: 'Mes Groupes'),
                            Tab(text: 'Publics'),
                            Tab(text: 'Privés'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                body: const TabBarView(
                  children: [
                    GroupsList(filter: 'all'),
                    GroupsList(filter: 'mine'),
                    GroupsList(filter: 'public'),
                    GroupsList(filter: 'private'),
                  ],
                ),
              ),
              bottomNavigationBar: const BottomNavBar(currentIndex: 1),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => showCreateGroupDialog(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Créer un groupe',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}