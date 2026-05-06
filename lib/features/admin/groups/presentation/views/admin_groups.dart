// lib/features/admin/groups/presentation/views/admin_groups.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../admin_drawer.dart';
import '../cubit/group_cubit.dart';
import '../cubit/group_state.dart';
import 'widgets/group_card.dart';
import 'widgets/group_dialog.dart';

class AdminGroups extends StatefulWidget {
  const AdminGroups({super.key});

  @override
  State<AdminGroups> createState() => _AdminGroupsState();
}

class _AdminGroupsState extends State<AdminGroups> {
  String _search = '';

  @override
  void initState() {
    super.initState();
    context.read<GroupCubit>().loadGroups();
  }

  String _getAdminId() {
    final state = context.read<AuthCubit>().state;
    return state is AuthAuthenticated ? state.user.uid : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text('Groupes'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => showDialog(
          context: context,
          builder: (c) => GroupDialog(onSave: (n, d, p, img) => context.read<GroupCubit>().createGroup(name: n, description: d, createdBy: _getAdminId(), isPrivate: p, imageUrl: img)),
        ))],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(hintText: 'Rechercher...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
            ),
          ),
        ),
      ),
      body: BlocConsumer<GroupCubit, GroupState>(
        listener: (c, s) {
          if (s is GroupSuccess) ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(s.message), backgroundColor: Colors.green));
          if (s is GroupError) ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(s.message), backgroundColor: Colors.red));
        },
        builder: (c, s) {
          if (s is GroupLoading) return const Center(child: CircularProgressIndicator());
          if (s is GroupLoaded) {
            final groups = s.groups.where((g) => g.name.toLowerCase().contains(_search)).toList();
            if (groups.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.group_off, size: 64), const SizedBox(height: 16), Text(_search.isEmpty ? 'Aucun groupe' : 'Aucun résultat'), ElevatedButton(onPressed: () => showDialog(context: c, builder: (_) => GroupDialog(onSave: (n, d, p, img) => context.read<GroupCubit>().createGroup(name: n, description: d, createdBy: _getAdminId(), isPrivate: p, imageUrl: img))), child: const Text('Créer'))]));
            return ListView.builder(padding: const EdgeInsets.all(12), itemCount: groups.length, itemBuilder: (_, i) => GroupCard(
              group: groups[i],
              onEdit: () => showDialog(context: c, builder: (_) => GroupDialog(group: groups[i], onSave: (n, d, p, img) {
                final data = {'name': n, 'description': d, 'isPrivate': p};
                if (img != null && img != groups[i].imageUrl) data['imageUrl'] = img;
                context.read<GroupCubit>().updateGroup(groups[i].id, data);
              })),
              onDelete: () => showDialog(context: c, builder: (_) => AlertDialog(
                title: const Text('Supprimer'),
                content: Text('Supprimer "${groups[i].name}" ?'),
                actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Annuler')), TextButton(onPressed: () { Navigator.pop(c); context.read<GroupCubit>().deleteGroup(groups[i].id); }, style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Supprimer'))],
              )),
            ));
          }
          if (s is GroupError) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error, size: 64), const SizedBox(height: 16), Text(s.message), ElevatedButton(onPressed: () => context.read<GroupCubit>().loadGroups(), child: const Text('Réessayer'))]));
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}