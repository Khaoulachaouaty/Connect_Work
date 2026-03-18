import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.controller,
  });

  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: _borderStyle(),
        focusedBorder: _borderStyle(isFocused: true),
      ),
    );
  }
}


OutlineInputBorder _borderStyle({bool isFocused = false}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(
      color: isFocused ? Colors.blue : Colors.grey.shade300,
      width: 1.3,
    ),
  );
}