import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
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
  //final TextEditingController _emailController = TextEditingController();
  //final TextEditingController _passwordController = TextEditingController();
  bool _loginPressed = false;
  String? _alertMessage;

  // Déclaration des controllers avec valeurs par défaut pour tester
  final TextEditingController _emailController = TextEditingController(
    text: 'employe@entreprise.com', // email pré-rempli
  );

  final TextEditingController _passwordController = TextEditingController(
    text: 'azerty', // mot de passe pré-rempli
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setAlert(String message) {
    setState(() {
      _alertMessage = message;
    });
  }

  void _clearAlert() {
    setState(() {
      _alertMessage = null;
    });
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _setAlert('Veuillez renseigner l\'email et le mot de passe.');
      return;
    }
    _clearAlert();
    _loginPressed = true;
    context.read<AuthCubit>().signIn(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (!_loginPressed) {
            // Ignore le flux d'état initial sur la page de connexion (login non encore cliquant)
            return;
          }
          if (state.user.role == 'employee') {
            context.go('/home');
          } else {
            _setAlert('Accès réservé aux employés uniquement.');
            context.read<AuthCubit>().signOut();
            context.go('/login');
          }
        } else if (state is AuthError) {
          _setAlert(state.message);
          _loginPressed = false;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
                const SliverToBoxAdapter(child: LoginHeaderWidget()),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),

                const SliverToBoxAdapter(child: _SectionLabel(text: "Email")),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverToBoxAdapter(
                  child: _SectionPadding(
                    child: CustomTextField(
                      controller: _emailController,
                      hintText: "nom@entreprise.com",

                      icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress,
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
                      obscureText: true, keyboardType: TextInputType.text,
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
                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                SliverToBoxAdapter(
                  child: _SectionPadding(
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return LoginButton(
                          onPressed: _login,
                          isLoading: state is AuthLoading,
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
                const SliverToBoxAdapter(child: LoginFooterText()),
              ],
            ),

            if (_alertMessage != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 120,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color.fromARGB(255, 179, 141, 148), const Color.fromARGB(255, 247, 87, 87)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.white, size: 26),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _alertMessage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                          onPressed: _clearAlert,
                        ),
                      ],
                    ),
                  ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}