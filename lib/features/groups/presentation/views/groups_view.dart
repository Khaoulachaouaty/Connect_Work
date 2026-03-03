import 'package:flutter/material.dart';

import '../../../../core/utils/app_bar.dart';
import '../../../../core/utils/bottom_navbar.dart';
import '../../data/models/group_modele.dart';
import 'widgets/group_card.dart';
import 'widgets/groups_search_field.dart';


class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = [
      Group(
        id: '1',
        name: 'Équipe Development',
        imageUrl: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600',
        memberCount: 45,
        isMember: true,
      ),
      Group(
        id: '2',
        name: 'Marketing & Communication',
        imageUrl: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=600',
        memberCount: 32,
        isMember: true,
      ),
      Group(
        id: '3',
        name: 'Design UX/UI',
        imageUrl: 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=600',
        memberCount: 18,
        isMember: false,
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppBar(
            title: 'Groupes',
            showSearch: true,
            showNotifications: true,
            onSearchTap: () {},
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const GroupSearchField(),
                  const SizedBox(height: 0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return GroupCard(group: groups[index]);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}