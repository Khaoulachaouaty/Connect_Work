// lib/features/admin/employees/presentation/views/widgets/employee_list/employee_list_state.dart
import '../../../data/models/employee_model.dart';

class EmployeeListState {
  final List<EmployeeModel> employees;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  const EmployeeListState({
    this.employees = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });

  List<EmployeeModel> get filteredEmployees {
    if (searchQuery.isEmpty) return employees;
    return employees.where((e) =>
      e.fullName.toLowerCase().contains(searchQuery.toLowerCase()) ||
      e.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
      (e.function?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
    ).toList();
  }

  EmployeeListState copyWith({
    List<EmployeeModel>? employees,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return EmployeeListState(
      employees: employees ?? this.employees,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}