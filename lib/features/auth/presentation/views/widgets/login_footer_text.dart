import 'package:flutter/material.dart';

class LoginFooterText extends StatelessWidget {
  const LoginFooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 44),
      child: Center(
        child: Text(
          "En vous connectant, vous acceptez nos conditions d'utilisation",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}