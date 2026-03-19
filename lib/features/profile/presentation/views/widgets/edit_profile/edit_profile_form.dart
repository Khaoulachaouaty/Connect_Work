import 'package:flutter/material.dart';
import '../../../../../auth/data/models/user_model.dart';

class EditProfileForm extends StatefulWidget {
  final UserModel user;

  const EditProfileForm({super.key, required this.user});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _functionController;
  late final TextEditingController _departmentController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _functionController = TextEditingController(
      text: widget.user.function ?? '',
    );
    _departmentController = TextEditingController(text: '');
    _bioController = TextEditingController(text: widget.user.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _functionController.dispose();
    _departmentController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField(label: 'Nom complet', controller: _nameController),
        const SizedBox(height: 16),
        _buildField(label: 'Fonction', controller: _functionController),
        const SizedBox(height: 16),
        _buildField(
          label: 'Département',
          controller: _departmentController,
          hintText: 'ex: Marketing, IT, RH...',
        ),
        const SizedBox(height: 16),
        _buildField(
          label: 'Bio',
          controller: _bioController,
          maxLines: 4,
          hintText: 'Parlez-nous de vous...',
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
