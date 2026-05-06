// lib/features/admin/employees/presentation/views/widgets/employee_form/form_handle_bar.dart
import 'package:flutter/material.dart';

class FormHandleBar extends StatelessWidget {
  const FormHandleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}