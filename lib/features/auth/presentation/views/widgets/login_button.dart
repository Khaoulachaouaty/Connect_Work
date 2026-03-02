import 'package:flutter/material.dart';

import '../../../../../core/functions/navigation.dart';
import '../../../../../core/utils/app_colors.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          customReplacementNavigate(context, "/home");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        ),
        child: const Text(
          "Se connecter",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.white,
          ),
        ),
      ),
    );
  }
}
