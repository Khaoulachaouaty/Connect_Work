// lib/features/admin/employees/presentation/cubit/employee_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/employee_service.dart';
import '../../data/models/employee_model.dart';
import 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeService _employeeService;

  EmployeeCubit(this._employeeService) : super(EmployeeInitial());

  void loadEmployees() {
    emit(EmployeeLoading());
    _employeeService.getEmployees().listen(
      (employees) => emit(EmployeeLoaded(employees)),
      onError: (error) => emit(EmployeeError(error.toString())),
    );
  }

  Future<void> createEmployee({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    String? function,
    String? department,
  }) async {
    try {
      await _employeeService.createEmployee(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        function: function,
        department: department,
      );
      emit(EmployeeSuccess('Employé créé avec succès'));
      loadEmployees();
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> data) async {
    try {
      await _employeeService.updateEmployee(id, data);
      emit(EmployeeSuccess('Employé mis à jour'));
      loadEmployees();
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> toggleEmployeeStatus(String id, bool isActive) async {
    try {
      await _employeeService.toggleEmployeeStatus(id, isActive);
      emit(EmployeeSuccess(isActive ? 'Employé activé' : 'Employé désactivé'));
      loadEmployees();
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  // ✅ VRAIE SUPPRESSION
  Future<void> deleteEmployee(String id) async {
    try {
      await _employeeService.deleteEmployee(id);
      emit(EmployeeSuccess('Employé supprimé avec succès'));
      loadEmployees();
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }
}