import 'package:flutter/material.dart';
import 'package:connect_work/features/auth/data/models/user_model.dart';

class ProfileAboutSection extends StatelessWidget {
  final UserModel user;
  const ProfileAboutSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Expérience & Rôle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildAboutItem(Icons.work_outline, 'Rôle', user.role.toUpperCase()),
        _buildAboutItem(Icons.business_center_outlined, 'Poste', user.function ?? 'Non renseigné'),
        _buildAboutItem(Icons.email_outlined, 'Email', user.email),
        const SizedBox(height: 32),
        const Text('À propos de moi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text(
          user.bio ?? 'Cet utilisateur n\'a pas encore ajouté de biographie.',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildAboutItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
