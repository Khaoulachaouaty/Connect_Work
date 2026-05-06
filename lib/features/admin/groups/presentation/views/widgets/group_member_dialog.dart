// lib/features/admin/groups/presentation/views/widgets/group_member_dialog.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/group_model.dart';
import '../../cubit/group_cubit.dart';


import 'add_member_bottom_sheet.dart';
import 'member_list_view.dart';

class GroupMemberDialog extends StatefulWidget {
  final GroupModel group;

  const GroupMemberDialog({super.key, required this.group});

  @override
  State<GroupMemberDialog> createState() => _GroupMemberDialogState();
}

class _GroupMemberDialogState extends State<GroupMemberDialog> {
  List<Map<String, dynamic>> _availableUsers = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableUsers();
  }

  Future<void> _loadAvailableUsers() async {
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    _availableUsers = usersSnapshot.docs
        .where((doc) => !widget.group.members.contains(doc.id))
        .map((doc) => {
          'id': doc.id,
          'name': doc['fullName'] ?? doc['email']?.split('@').first ?? 'Utilisateur',
          'email': doc['email'],
        })
        .toList();
    if (mounted) setState(() {});
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
            Expanded(
              child: MemberListView(
                group: widget.group,
                controller: controller,
                onRemoveMember: _removeMember,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddMemberBottomSheet(
        availableUsers: _availableUsers,
        onAddMember: _addMember,
      ),
    );
  }

  void _addMember(String userId) {
    context.read<GroupCubit>().addMember(widget.group.id, userId);
    Navigator.pop(context); 
    Navigator.pop(context); 
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