import 'package:flutter/material.dart';
import 'widgets/forget_passowrd.dart';
import 'widgets/login_button.dart';
import 'widgets/login_footer_text.dart';
import 'widgets/login_header.dart';
import 'widgets/login_text_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 120)),

          const SliverToBoxAdapter(child: LoginHeaderWidget(),),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),

          // Email Label
          const SliverToBoxAdapter(child: _SectionLabel(text: "Email"),),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Email Field
          const SliverToBoxAdapter(
            child: _SectionPadding(
              child: CustomTextField(
                hintText: "nom@entreprise.com",
                icon: Icons.email_outlined,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Password Label
          const SliverToBoxAdapter(child: _SectionLabel(text: "Mot de passe"),),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Password Field
          const SliverToBoxAdapter(
            child: _SectionPadding(
              child: CustomTextField(
                hintText: "••••••••",
                icon: Icons.lock_outlined,
                obscureText: true,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Forgot Password
          const SliverToBoxAdapter(
            child: _SectionPadding(
              child: Align(
                alignment: Alignment.centerRight,
                child: ForgetPassword(),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Login Button
          const SliverToBoxAdapter(child: _SectionPadding(child: LoginButton(),),),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),

          // Footer Text
          const SliverToBoxAdapter(child: LoginFooterText(),),
        ],
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