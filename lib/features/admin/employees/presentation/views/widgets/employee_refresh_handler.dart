// lib/features/admin/employees/presentation/views/widgets/employee_list/employee_refresh_handler.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/employee_cubit.dart';

class EmployeeRefreshHandler {
  final BuildContext context;

  EmployeeRefreshHandler(this.context);

  // ✅ Retourne Future<void> pour RefreshCallback
  Future<void> refresh() async {
    if (context.mounted) {
      context.read<EmployeeCubit>().loadEmployees();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  // ✅ Pour les boutons (retourne void)
  void refreshSync() {
    if (context.mounted) {
      context.read<EmployeeCubit>().loadEmployees();
    }
  }
}