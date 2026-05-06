// lib/auth/presentation/views/widgets/login_footer_text.dart
import 'package:flutter/material.dart';

class LoginFooterText extends StatelessWidget {
  const LoginFooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Application interne',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          '© 2026 - Tous droits réservés',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        ),
      ],
    );
  }
}