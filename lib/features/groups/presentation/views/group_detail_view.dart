import 'package:flutter/material.dart';
import '../../data/models/group_modele.dart';
import 'widgets/details/group_app_bar.dart';
import 'widgets/details/group_files_tab.dart';
import 'widgets/details/group_info.dart';
import 'widgets/details/group_members_tab.dart';
import 'widgets/details/group_publications_tab.dart';
import 'widgets/details/group_tabs.dart';

class GroupDetailView extends StatefulWidget {
  final Group group;

  const GroupDetailView({super.key, required this.group});

  @override
  State<GroupDetailView> createState() => _GroupDetailViewState();
}

class _GroupDetailViewState extends State<GroupDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            GroupAppBar(imageUrl: widget.group.imageUrl),
            GroupInfo(group: widget.group),
            GroupTabs(controller: _tabController),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            GroupPublicationsTab(),
            GroupMembersTab(),
            GroupFilesTab(),
          ],
        ),
      ),
    );
  }
}