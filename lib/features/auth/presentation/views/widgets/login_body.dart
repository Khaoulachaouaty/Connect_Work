import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_state.dart';
import 'auth_section_utils.dart';
import 'forget_passowrd.dart';
import 'login_button.dart';
import 'login_footer_text.dart';
import 'login_header.dart';
import 'login_text_field.dart';

class LoginBody extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;

  const LoginBody({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 60)),
        const SliverToBoxAdapter(child: LoginHeaderWidget()),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
        
        const SliverToBoxAdapter(child: AuthSectionLabel(text: "Email")),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverToBoxAdapter(
          child: AuthSectionPadding(
            child: CustomTextField(
              controller: emailController,
              hintText: "nom@entreprise.com",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        
        const SliverToBoxAdapter(child: AuthSectionLabel(text: "Mot de passe")),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverToBoxAdapter(
          child: AuthSectionPadding(
            child: CustomTextField(
              controller: passwordController,
              hintText: "••••••••",
              icon: Icons.lock_outlined,
              obscureText: true,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        const SliverToBoxAdapter(
          child: AuthSectionPadding(
            child: Align(
              alignment: Alignment.centerRight,
              child: ForgetPassword(),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        
        SliverToBoxAdapter(
          child: AuthSectionPadding(
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return LoginButton(
                  onPressed: onLoginPressed,
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
    );
  }
}
