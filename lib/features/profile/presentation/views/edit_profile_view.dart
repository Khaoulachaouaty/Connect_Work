import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'widgets/edit_profile/edit_profile_app_bar.dart';
import 'widgets/edit_profile/edit_profile_avatar.dart';
import 'widgets/edit_profile/edit_profile_form.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EditProfileAppBar(),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const EditProfileAvatar(),
                  const SizedBox(height: 24),
                  EditProfileForm(user: state.user),
                ],
              ),
            );
          }
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Aucun utilisateur connecté.'));
        },
      ),
    );
  }
}
