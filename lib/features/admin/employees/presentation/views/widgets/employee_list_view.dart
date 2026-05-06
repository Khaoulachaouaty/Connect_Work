// lib/features/admin/employees/presentation/views/widgets/employee_list/employee_list_view.dart
import 'package:flutter/material.dart';
import '../../../data/models/employee_model.dart';
import 'employee_card.dart';
import 'employee_empty_state.dart';
import 'employee_list_state.dart';

class EmployeeListView extends StatelessWidget {
  final EmployeeListState listState;
  final Future<void> Function() onRefresh;  // ✅ Changé de VoidCallback à Future<void> Function()
  final VoidCallback onAdd;
  final VoidCallback onClearSearch;
  final Function(EmployeeModel) onTap;
  final Function(EmployeeModel) onEdit;
  final Function(EmployeeModel) onToggle;
  final Function(EmployeeModel) onDelete;

  const EmployeeListView({
    super.key,
    required this.listState,
    required this.onRefresh,
    required this.onAdd,
    required this.onClearSearch,
    required this.onTap,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (listState.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Chargement...'),
          ],
        ),
      );
    }

    final employees = listState.filteredEmployees;
    
    if (employees.isEmpty) {
      return EmployeeEmptyState(
        query: listState.searchQuery,
        onClear: onClearSearch,
        onAdd: onAdd,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,  // ✅ Maintenant compatible
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: employees.length,
        itemBuilder: (_, i) => EmployeeCard(
          employee: employees[i],
          onTap: () => onTap(employees[i]),
          onEdit: () => onEdit(employees[i]),
          onToggle: () => onToggle(employees[i]),
          onDelete: () => onDelete(employees[i]),
        ),
      ),
    );
  }
}