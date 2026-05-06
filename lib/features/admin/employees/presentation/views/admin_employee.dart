// lib/features/admin/employees/presentation/views/admin_employees.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../admin_drawer.dart';
import '../cubit/employee_cubit.dart';
import '../cubit/employee_state.dart';
import 'widgets/employee_app_bar.dart';
import 'widgets/employee_dialog_handler.dart';
import 'widgets/employee_list_state.dart';
import 'widgets/employee_list_view.dart';
import 'widgets/employee_refresh_handler.dart';
import 'widgets/employee_search_handler.dart';

class AdminEmployees extends StatefulWidget {
  const AdminEmployees({super.key});

  @override
  State<AdminEmployees> createState() => _AdminEmployeesState();
}

class _AdminEmployeesState extends State<AdminEmployees> {
  late EmployeeListState _listState;
  late EmployeeSearchHandler _searchHandler;
  late EmployeeRefreshHandler _refreshHandler;
  late EmployeeDialogHandler _dialogHandler;

  @override
  void initState() {
    super.initState();
    _listState = const EmployeeListState();
    _searchHandler = EmployeeSearchHandler();
    _refreshHandler = EmployeeRefreshHandler(context);
    _dialogHandler = EmployeeDialogHandler(context, _loadEmployees);
    _loadEmployees();
  }

  void _loadEmployees() => context.read<EmployeeCubit>().loadEmployees();
  void _updateSearch(String query) => setState(() => _listState = _listState.copyWith(searchQuery: query));
  void _clearSearch() => _searchHandler.clearSearch(_updateSearch);

  @override
  void dispose() {
    _searchHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: EmployeeAppBar(
        searchController: _searchHandler.controller,
        searchFocusNode: _searchHandler.focusNode,
        onRefresh: _refreshHandler.refresh,
        onAdd: () => _dialogHandler.showForm(),
        onClearSearch: _clearSearch,
        onSearchChanged: (q) => _searchHandler.onSearchChanged(q, _updateSearch),
      ),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          _listState = _listState.copyWith(
            employees: state is EmployeeLoaded ? state.employees : [],
            isLoading: state is EmployeeLoading,
            error: state is EmployeeError ? state.message : null,
          );
          return EmployeeListView(
            listState: _listState,
            onRefresh: _refreshHandler.refresh,
            onAdd: () => _dialogHandler.showForm(),
            onClearSearch: _clearSearch,
            onTap: (e) => _dialogHandler.showDetails(e),
            onEdit: (e) => _dialogHandler.showForm(employee: e),
            onToggle: (e) => _dialogHandler.showStatusDialog(e.id, !e.isActive),
            onDelete: (e) => _dialogHandler.showDeleteDialog(e),
          );
        },
      ),
    );
  }
}