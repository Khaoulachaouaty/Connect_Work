import 'package:flutter/material.dart';

class AddMemberBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> availableUsers;
  final Function(String) onAddMember;

  const AddMemberBottomSheet({
    super.key,
    required this.availableUsers,
    required this.onAddMember,
  });

  @override
  State<AddMemberBottomSheet> createState() => _AddMemberBottomSheetState();
}

class _AddMemberBottomSheetState extends State<AddMemberBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> _getFilteredUsers() {
    if (_searchQuery.isEmpty) return widget.availableUsers;
    return widget.availableUsers.where((user) =>
      user['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
      user['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => widget.onAddMember(user['id']),
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
  }
}
