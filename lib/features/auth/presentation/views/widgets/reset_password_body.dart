import 'package:flutter/material.dart';
import 'auth_alert_box.dart';
import 'auth_section_utils.dart';
import 'login_button.dart';
import 'login_text_field.dart';

class ResetPasswordBody extends StatelessWidget {
  final TextEditingController emailController;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;
  final VoidCallback onSendResetEmail;
  final VoidCallback onBackToLogin;

  const ResetPasswordBody({
    super.key,
    required this.emailController,
    required this.isLoading,
    required this.successMessage,
    required this.errorMessage,
    required this.onSendResetEmail,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_reset, size: 60, color: Colors.blue.shade700),
          ),
          const SizedBox(height: 32),
          const Text(
            'Mot de passe oublié ?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D1D1D)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Entrez votre email professionnel pour recevoir un lien de réinitialisation.',
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          
          if (successMessage != null) ...[
            AuthAlertBox(message: successMessage!, isSuccess: true),
            const SizedBox(height: 24),
          ],
          
          if (errorMessage != null) ...[
            AuthAlertBox(message: errorMessage!, isSuccess: false),
            const SizedBox(height: 24),
          ],
          
          const AuthSectionLabel(text: "Email professionnel"),
          const SizedBox(height: 8),
          CustomTextField(
            controller: emailController,
            hintText: "nom@entreprise.com",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 32),
          
          LoginButton(
            onPressed: onSendResetEmail,
            isLoading: isLoading,
            text: "Envoyer le lien",
          ),
          
          const SizedBox(height: 24),
          TextButton(
            onPressed: onBackToLogin,
            child: Text(
              'Retour à la connexion',
              style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
