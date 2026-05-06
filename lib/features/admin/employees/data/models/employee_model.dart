// lib/features/admin/employees/data/models/employee_model.dart
class EmployeeModel {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? function;
  final String? department;
  final bool isActive;

  EmployeeModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.function,
    this.department,
    this.isActive = true,
  });

  factory EmployeeModel.fromMap(Map<String, dynamic> map, String id) {
    return EmployeeModel(
      id: id,
      email: map['email']?.toString() ?? '',
      fullName: map['fullName']?.toString() ?? '',
      phoneNumber: map['phoneNumber']?.toString(),
      function: map['function']?.toString(),
      department: map['department']?.toString(),
      isActive: map['isActive'] ?? true,
    );
  }
}