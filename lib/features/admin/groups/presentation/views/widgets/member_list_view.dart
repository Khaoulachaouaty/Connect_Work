import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../data/models/group_model.dart';

class MemberListView extends StatelessWidget {
  final GroupModel group;
  final ScrollController? controller;
  final Function(String) onRemoveMember;

  const MemberListView({
    super.key,
    required this.group,
    this.controller,
    required this.onRemoveMember,
  });

  Future<Map<String, dynamic>> _getUserInfo(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return {
      'name': doc['fullName'] ?? doc['email']?.split('@').first ?? 'Utilisateur',
      'email': doc['email'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: group.members.length,
      itemBuilder: (context, index) {
        final memberId = group.members[index];
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
            final isCreator = memberId == group.createdBy;
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
                      onPressed: () => onRemoveMember(memberId),
                      tooltip: 'Retirer',
                    ),
            );
          },
        );
      },
    );
  }
}
