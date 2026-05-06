// lib/features/admin/employees/presentation/views/widgets/employee_details_dialog.dart
import 'package:flutter/material.dart';
import '../../../data/models/employee_model.dart';
import 'employee_avatar.dart';

class EmployeeDetailsDialog extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const EmployeeDetailsDialog({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = employee.isActive;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, controller) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          children: [
            _buildHandleBar(),
            const SizedBox(height: 20),
            EmployeeAvatar(fullName: employee.fullName, isActive: isActive, radius: 50),
            const SizedBox(height: 20),
            _buildNameAndEmail(),
            const SizedBox(height: 20),
            Expanded(child: _buildDetails(controller)),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 12),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandleBar() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }

  Widget _buildNameAndEmail() {
    return Column(
      children: [
        Text(employee.fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
          child: Text(employee.email, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        ),
      ],
    );
  }

  Widget _buildDetails(ScrollController controller) {
    return SingleChildScrollView(
      controller: controller,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            _buildDetailRow(Icons.work_outline, 'Fonction', employee.function ?? 'Non défini'),
            const Divider(height: 1),
            _buildDetailRow(Icons.business_outlined, 'Département', employee.department ?? 'Non défini'),
            const Divider(height: 1),
            _buildDetailRow(Icons.phone_outlined, 'Téléphone', employee.phoneNumber ?? 'Non défini'),
            const Divider(height: 1),
            _buildDetailRow(Icons.calendar_today, 'Statut', employee.isActive ? 'Actif' : 'Inactif', valueColor: employee.isActive ? Colors.green : Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          SizedBox(width: 100, child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w500, color: valueColor ?? Colors.grey.shade800))),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Modifier'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onToggle,
            icon: Icon(employee.isActive ? Icons.visibility_off : Icons.visibility, size: 18),
            label: Text(employee.isActive ? 'Désactiver' : 'Activer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: employee.isActive ? Colors.orange : Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onDelete,
        icon: const Icon(Icons.delete_outline, size: 18),
        label: const Text('Supprimer'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red.shade300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}