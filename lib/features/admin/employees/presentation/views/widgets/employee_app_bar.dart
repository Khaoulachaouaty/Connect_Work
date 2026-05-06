// lib/features/admin/employees/presentation/views/widgets/employee_app_bar.dart
import 'package:flutter/material.dart';
import 'employee_search_bar.dart';

class EmployeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Future<void> Function() onRefresh; // ✅ Changé de VoidCallback à Future<void> Function()
  final VoidCallback onAdd;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSearchChanged;

  const EmployeeAppBar({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.onRefresh,
    required this.onAdd,
    required this.onClearSearch,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Employés'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefresh, // ✅ Maintenant compatible
          tooltip: 'Actualiser',
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onAdd,
          tooltip: 'Ajouter un employé',
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: EmployeeSearchBar(
            controller: searchController,
            focusNode: searchFocusNode,
            onClear: onClearSearch,
            onChanged: onSearchChanged,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}