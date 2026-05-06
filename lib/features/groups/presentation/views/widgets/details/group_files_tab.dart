import 'package:flutter/material.dart';

class GroupFilesTab extends StatelessWidget {
  final String groupId;
  const GroupFilesTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Fichiers du groupe'));
  }
}