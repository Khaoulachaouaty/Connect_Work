// lib/features/admin/employees/presentation/cubit/employee_state.dart
import '../../data/models/employee_model.dart';

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}
class EmployeeLoading extends EmployeeState {}
class EmployeeLoaded extends EmployeeState {
  final List<EmployeeModel> employees;
  EmployeeLoaded(this.employees);
}
class EmployeeSuccess extends EmployeeState {
  final String message;
  EmployeeSuccess(this.message);
}
class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}