import 'package:flutter/material.dart';

class EditProfileForm extends StatelessWidget {
  final _nameController = TextEditingController(text: 'Sarah Martinez');
  final _roleController = TextEditingController(text: 'Product Manager');
  final _departmentController = TextEditingController(text: 'Product Management');
  final _bioController = TextEditingController();

  EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField(
          label: 'Nom complet',
          controller: _nameController,
        ),
        const SizedBox(height: 16),
        _buildField(
          label: 'Fonction',
          controller: _roleController,
        ),
        const SizedBox(height: 16),
        _buildField(
          label: 'Département',
          controller: _departmentController,
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