// lib/features/admin/groups/presentation/views/widgets/group_search_bar.dart
import 'package:flutter/material.dart';

class GroupSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;

  const GroupSearchBar({
    super.key,
    required this.controller,
    required this.onClear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Rechercher...',
          prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade500),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, size: 18, color: Colors.grey.shade500),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}