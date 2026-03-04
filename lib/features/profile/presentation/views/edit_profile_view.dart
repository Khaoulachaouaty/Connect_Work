import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const EditProfileAvatar(),
            const SizedBox(height: 24),
            EditProfileForm(),
          ],
        ),
      ),
    );
  }
}