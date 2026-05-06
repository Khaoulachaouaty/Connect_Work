// lib/auth/presentation/views/widgets/forget_password.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.push('/reset-password');
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(50, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Mot de passe oublié ?',
        style: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}