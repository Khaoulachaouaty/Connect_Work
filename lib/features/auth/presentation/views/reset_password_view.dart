// lib/auth/presentation/views/reset_password_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import 'widgets/login_button.dart';
import 'widgets/login_text_field.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Veuillez saisir votre email');
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _errorMessage = 'Email invalide');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final authCubit = context.read<AuthCubit>();
      await authCubit.resetPassword(email);
      
      if (mounted) {
        setState(() {
          _successMessage = 'Un email de réinitialisation a été envoyé à $email';
          _isLoading = false;
        });

        // Retour automatique après 3 secondes
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
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
                  
                  if (_successMessage != null) ...[
                    _AlertBox(message: _successMessage!, isSuccess: true),
                    const SizedBox(height: 24),
                  ],
                  
                  if (_errorMessage != null) ...[
                    _AlertBox(message: _errorMessage!, isSuccess: false),
                    const SizedBox(height: 24),
                  ],
                  
                  const _SectionLabel(text: "Email professionnel"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _emailController,
                    hintText: "nom@entreprise.com",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),
                  
                  LoginButton(
                    onPressed: _sendResetEmail,
                    isLoading: _isLoading,
                    text: "Envoyer le lien",
                  ),
                  
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Retour à la connexion',
                      style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}

class _AlertBox extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const _AlertBox({required this.message, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSuccess ? Colors.green.shade200 : Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle_outline : Icons.error_outline,
            color: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}