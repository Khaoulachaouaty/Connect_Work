import 'package:flutter/material.dart';

class GroupMembersTab extends StatelessWidget {
  final String groupId;
  const GroupMembersTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Liste des membres'));
  }
}