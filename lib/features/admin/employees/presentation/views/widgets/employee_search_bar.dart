// lib/features/admin/employees/presentation/views/widgets/employee_search_bar.dart
import 'package:flutter/material.dart';

class EmployeeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;

  const EmployeeSearchBar({
    super.key,
    required this.controller,
    this.focusNode,
    required this.onClear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Rechercher un employé...',
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(icon: Icon(Icons.clear, color: Colors.grey.shade500), onPressed: onClear)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}