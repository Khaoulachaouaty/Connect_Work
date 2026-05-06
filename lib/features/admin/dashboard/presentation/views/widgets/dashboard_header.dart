// lib/features/admin/dashboard/presentation/views/widgets/dashboard_header.dart
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onRefresh;

  const DashboardHeader({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aperçu général',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Statistiques et activités récentes',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        IconButton(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh),
          tooltip: 'Actualiser',
        ),
      ],
    );
  }
}