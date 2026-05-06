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
              backgroundColor: const Color(0xFFF9FAFB),
              floatingActionButton: isAdmin ? FloatingActionButton.extended(
                onPressed: () => _showCreateGroupDialog(context),
                backgroundColor: AppColor.primary,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Créer un groupe', style: TextStyle(color: Colors.white)),
              ) : null,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverCustomAppBar(
                    title: 'Groupes',
                    showSearch: true,
                    showNotifications: true,
                    showLogout: true,
                    onSearchTap: () {},
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: const GroupSearchField(),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      const TabBar(
                        isScrollable: true,
                        indicatorColor: AppColor.primary,
                        labelColor: AppColor.primary,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        tabs: [
                          Tab(text: 'Tous'),
                          Tab(text: 'Mes Groupes'),
                          Tab(text: 'Publics'),
                          Tab(text: 'Privés'),
                        ],
                      ),
                    ),
                  ),
                ],
                body: TabBarView(
                  children: [
                    _GroupsList(filter: 'all'),
                    _GroupsList(filter: 'mine'),
                    _GroupsList(filter: 'public'),
                    _GroupsList(filter: 'private'),
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

  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Créer un nouveau groupe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nom du groupe'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Groupe privé'),
                  subtitle: const Text('Nécessite une approbation pour rejoindre'),
                  value: isPrivate,
                  onChanged: (val) => setState(() => isPrivate = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<GroupsCubit>().createGroup(
                  name: nameController.text,
                  description: descController.text,
                  imageUrl: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800', // Placeholder
                  isPrivate: isPrivate,
                );
                Navigator.pop(context);
              },
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupsList extends StatelessWidget {
  final String filter;
  const _GroupsList({required this.filter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsCubit, GroupsState>(
      builder: (context, state) {
        if (state is GroupsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GroupsLoaded) {
          List<Group> groups = [];
          if (filter == 'all') {
            groups = state.publicGroups;
          } else if (filter == 'mine') {
            groups = state.userGroups;
          } else if (filter == 'public') {
            groups = state.publicGroups.where((g) => !g.isPrivate).toList();
          } else if (filter == 'private') {
            groups = state.publicGroups.where((g) => g.isPrivate).toList();
          }

          if (groups.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_off_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun groupe trouvé',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return GroupCard(group: groups[index]);
            },
          );
        } else if (state is GroupsError) {
          return Center(child: Text('Erreur: ${state.message}'));
        }
        return const Center(child: Text('Chargement...'));
      },
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