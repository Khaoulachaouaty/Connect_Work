// lib/features/admin/employees/presentation/views/widgets/employee_list/employee_search_handler.dart
import 'package:flutter/material.dart';

class EmployeeSearchHandler {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  
  void onSearchChanged(String query, Function(String) onUpdate) {
    onUpdate(query);
  }
  
  void clearSearch(Function(String) onUpdate) {
    controller.clear();
    focusNode.unfocus();
    onUpdate('');
  }
  
  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}