import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connect_work/core/widgets/app_empty_state.dart';
import 'package:connect_work/features/groups/data/models/group_modele.dart';
import 'package:connect_work/features/groups/presentation/cubit/groups_cubit.dart';
import 'group_card.dart';

class GroupsList extends StatelessWidget {
  final String filter;
  const GroupsList({super.key, required this.filter});

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
            return const AppEmptyState(
              title: 'Aucun groupe trouvé',
              subtitle: 'Rejoignez des groupes publics ou demandez à rejoindre des groupes privés.',
              icon: Icons.group_off_rounded,
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
