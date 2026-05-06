import 'package:connect_work/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../data/models/group_modele.dart';
import 'widgets/details/group_app_bar.dart';
import 'widgets/details/group_files_tab.dart';
import 'widgets/details/group_info.dart';
import 'widgets/details/group_members_tab.dart';
import 'widgets/details/group_publications_tab.dart';
import 'widgets/details/group_tabs.dart';

import 'widgets/details/group_pending_requests_tab.dart';
import 'widgets/details/persistent_tab_bar_delegate.dart';

class GroupDetailView extends StatefulWidget {
  final Group group;

  const GroupDetailView({super.key, required this.group});

  @override
  State<GroupDetailView> createState() => _GroupDetailViewState();
}

class _GroupDetailViewState extends State<GroupDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    _isAdmin = authState is AuthAuthenticated && authState.user.role == 'admin';
    _tabController = TabController(length: _isAdmin ? 4 : 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            GroupAppBar(
              imageUrl: widget.group.imageUrl,
              groupId: widget.group.id,
              groupName: widget.group.name,
              isMember: widget.group.isMember,
            ),
            GroupInfo(group: widget.group),
            SliverPersistentHeader(
              pinned: true,
              delegate: PersistentTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColor.primary,
                  labelColor: AppColor.primary,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: [
                    const Tab(text: 'Publications'),
                    const Tab(text: 'Membres'),
                    const Tab(text: 'Fichiers'),
                    if (_isAdmin) const Tab(text: 'Demandes'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            GroupPublicationsTab(groupId: widget.group.id),
            GroupMembersTab(groupId: widget.group.id),
            GroupFilesTab(groupId: widget.group.id),
            if (_isAdmin) GroupPendingRequestsTab(group: widget.group),
          ],
        ),
      ),
      floatingActionButton: widget.group.isMember ? FloatingActionButton(
        onPressed: () => context.push('/create-post', extra: widget.group),
        backgroundColor: AppColor.primary,
        child: const Icon(Icons.edit_note_rounded, color: Colors.white),
      ) : null,
    );
  }
}