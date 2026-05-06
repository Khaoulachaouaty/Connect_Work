// lib/auth/presentation/views/login_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/user_model.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'widgets/alert_message.dart';
import 'widgets/forget_passowrd.dart';
import 'widgets/login_button.dart';
import 'widgets/login_footer_text.dart';
import 'widgets/login_header.dart';
import 'widgets/login_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginAttempt = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Veuillez renseigner email et mot de passe');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _errorMessage = 'Email invalide');
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoginAttempt = true;
    });

    context.read<AuthCubit>().signIn(email, password);
  }

  void _navigateBasedOnRole(UserModel user) {
    if (user.role == 'admin') {
      context.go('/admin');
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated && _isLoginAttempt) {
          _navigateBasedOnRole(state.user);
        } else if (state is AuthError) {
          setState(() {
            _errorMessage = state.message;
            _isLoginAttempt = false;
          });
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 60)),
                const SliverToBoxAdapter(child: LoginHeaderWidget()),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
                
                const SliverToBoxAdapter(child: _SectionLabel(text: "Email")),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverToBoxAdapter(
                  child: _SectionPadding(
                    child: CustomTextField(
                      controller: _emailController,
                      hintText: "nom@entreprise.com",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                
                const SliverToBoxAdapter(child: _SectionLabel(text: "Mot de passe")),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverToBoxAdapter(
                  child: _SectionPadding(
                    child: CustomTextField(
                      controller: _passwordController,
                      hintText: "••••••••",
                      icon: Icons.lock_outlined,
                      obscureText: true,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                const SliverToBoxAdapter(
                  child: _SectionPadding(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ForgetPassword(),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                
                SliverToBoxAdapter(
                  child: _SectionPadding(
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return LoginButton(
                          onPressed: _handleLogin,
                          isLoading: state is AuthLoading,
                        );
                      },
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 60)),
                const SliverToBoxAdapter(child: LoginFooterText()),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
            
            if (_errorMessage != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 30,
                child: AlertMessageWidget(
                  message: _errorMessage!,
                  onDismiss: () => setState(() => _errorMessage = null),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionPadding extends StatelessWidget {
  const _SectionPadding({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: child);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}