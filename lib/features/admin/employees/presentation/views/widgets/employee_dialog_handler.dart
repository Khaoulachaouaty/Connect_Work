// lib/features/admin/employees/presentation/views/widgets/employee_list/employee_dialog_handler.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/employee_model.dart';
import '../../cubit/employee_cubit.dart';
import '../admin_emplyee_form.dart';
import 'employee_delete_dialog.dart';
import 'employee_details_dialog.dart';
import 'employee_status_dialog.dart';

class EmployeeDialogHandler {
  final BuildContext context;
  final VoidCallback onEmployeeChanged;

  EmployeeDialogHandler(this.context, this.onEmployeeChanged);

  void showForm({EmployeeModel? employee}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        builder: (_, controller) => AdminEmployeeForm(
          employee: employee,
          scrollController: controller,
        ),
      ),
    ).then((_) => onEmployeeChanged());
  }

  void showDetails(EmployeeModel employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => EmployeeDetailsDialog(
        employee: employee,
        onEdit: () => showForm(employee: employee),
        onToggle: () => showStatusDialog(employee.id, !employee.isActive),
        onDelete: () => showDeleteDialog(employee),
      ),
    );
  }

  void showStatusDialog(String id, bool isActive) {
    showDialog(
      context: context,
      builder: (ctx) => EmployeeStatusDialog(
        isActive: isActive,
        onConfirm: () => _onStatusChanged(id, isActive),
      ),
    );
  }

  void showDeleteDialog(EmployeeModel employee) {
    showDialog(
      context: context,
      builder: (ctx) => EmployeeDeleteDialog(
        employee: employee,
        onConfirm: () => _onDeleteConfirmed(employee.id),
      ),
    );
  }

  void _onStatusChanged(String id, bool isActive) {
    if (context.mounted) {
      context.read<EmployeeCubit>().toggleEmployeeStatus(id, isActive);
      onEmployeeChanged();
    }
  }

  void _onDeleteConfirmed(String id) {
    if (context.mounted) {
      context.read<EmployeeCubit>().deleteEmployee(id);
      onEmployeeChanged();
    }
  }
}