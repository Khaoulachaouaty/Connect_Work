import 'package:flutter/material.dart';
import '../../../../../core/functions/navigation.dart';
import '../../../../../core/utils/app_colors.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        customReplacementNavigate(context, '/reset-password');
      },
      child: const Text(
        "Mot de passe oublié ?",
        style: TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}