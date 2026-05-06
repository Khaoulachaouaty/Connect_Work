import 'package:flutter/material.dart';
import '../../../../data/models/group_modele.dart';

class GroupPendingRequestsTab extends StatelessWidget {
  final Group group;
  const GroupPendingRequestsTab({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    if (group.pendingMembers.isEmpty) {
      return const Center(child: Text('Aucune demande en attente.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: group.pendingMembers.length,
      itemBuilder: (context, index) {
        final memberId = group.pendingMembers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text('Utilisateur ID: $memberId'), 
            subtitle: const Text('Souhaite rejoindre le groupe'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () {
                    // TODO: Implement accept logic
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () {
                    // TODO: Implement reject logic
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
