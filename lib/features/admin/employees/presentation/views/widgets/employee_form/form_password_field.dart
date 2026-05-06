// lib/features/admin/employees/presentation/views/widgets/employee_form/form_password_field.dart
import 'package:flutter/material.dart';

class FormPasswordField extends StatefulWidget {
  final TextEditingController controller;

  const FormPasswordField({super.key, required this.controller});

  @override
  State<FormPasswordField> createState() => _FormPasswordFieldState();
}

class _FormPasswordFieldState extends State<FormPasswordField> {
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _showPassword,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: 'Mot de passe',
          hintText: 'Minimum 6 caractères',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
          ),
          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade500,
            ),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Ce champ est requis';
          if (value!.length < 6) return 'Minimum 6 caractères';
          return null;
        },
      ),
    );
  }
}