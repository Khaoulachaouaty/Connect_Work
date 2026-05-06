// lib/features/admin/groups/presentation/views/widgets/group_member_dialog.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/group_model.dart';
import '../../cubit/group_cubit.dart';


class GroupMemberDialog extends StatefulWidget {
  final GroupModel group;

  const GroupMemberDialog({super.key, required this.group});

  @override
  State<GroupMemberDialog> createState() => _GroupMemberDialogState();
}

class _GroupMemberDialogState extends State<GroupMemberDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _availableUsers = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableUsers();
  }

  Future<void> _loadAvailableUsers() async {
    // Récupérer les utilisateurs depuis Firestore
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    _availableUsers = usersSnapshot.docs
        .where((doc) => !widget.group.members.contains(doc.id))
        .map((doc) => {
          'id': doc.id,
          'name': doc['fullName'] ?? doc['email']?.split('@').first ?? 'Utilisateur',
          'email': doc['email'],
        })
        .toList();
    setState(() {});
  }

  List<Map<String, dynamic>> _getFilteredUsers() {
    if (_searchQuery.isEmpty) return _availableUsers;
    return _availableUsers.where((user) =>
      user['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
      user['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, controller) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Membres (${widget.group.members.length})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () => _showAddMemberDialog(),
                  tooltip: 'Ajouter un membre',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Liste des membres
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: widget.group.members.length,
                itemBuilder: (context, index) {
                  final memberId = widget.group.members[index];
                  return FutureBuilder(
                    future: _getUserInfo(memberId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const ListTile(
                          leading: CircleAvatar(child: Icon(Icons.person)),
                          title: Text('Chargement...'),
                        );
                      }
                      final user = snapshot.data!;
                      final isCreator = memberId == widget.group.createdBy;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            user['name'][0].toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(user['name']),
                        subtitle: Text(user['email']),
                        trailing: isCreator
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('Créateur', style: TextStyle(fontSize: 10)),
                              )
                            : IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () => _removeMember(memberId),
                                tooltip: 'Retirer',
                              ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserInfo(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return {
      'name': doc['fullName'] ?? doc['email']?.split('@').first ?? 'Utilisateur',
      'email': doc['email'],
    };
  }

  void _showAddMemberDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ajouter un membre', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Rechercher...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: _getFilteredUsers().length,
                    itemBuilder: (context, index) {
                      final user = _getFilteredUsers()[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(user['name'][0].toUpperCase()),
                        ),
                        title: Text(user['name']),
                        subtitle: Text(user['email']),
                        trailing: ElevatedButton(
                          onPressed: () => _addMember(user['id']),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(80, 35),
                          ),
                          child: const Text('Ajouter'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addMember(String userId) {
    context.read<GroupCubit>().addMember(widget.group.id, userId);
    Navigator.pop(context); // Fermer le dialogue d'ajout
    Navigator.pop(context); // Fermer le dialogue des membres
  }

  void _removeMember(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirer un membre'),
        content: const Text('Voulez-vous vraiment retirer ce membre du groupe ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              context.read<GroupCubit>().removeMember(widget.group.id, userId);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Retirer'),
          ),
        ],
      ),
    );
  }
}