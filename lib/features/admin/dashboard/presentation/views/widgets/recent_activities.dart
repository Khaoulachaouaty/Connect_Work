// lib/features/admin/dashboard/presentation/views/widgets/recent_activities.dart
import 'package:flutter/material.dart';

class RecentActivities extends StatelessWidget {
  const RecentActivities({super.key});

  final List<Map<String, dynamic>> activities = const [
    {'title': 'Nouvel employé ajouté', 'subtitle': 'Jean Dupont - Développeur', 'time': 'Il y a 5 min', 'icon': Icons.person_add, 'color': Colors.green},
    {'title': 'Groupe créé', 'subtitle': 'Équipe Marketing', 'time': 'Il y a 1 heure', 'icon': Icons.group_add, 'color': Colors.blue},
    {'title': 'Publication signalée', 'subtitle': 'Contenu inapproprié', 'time': 'Il y a 3 heures', 'icon': Icons.flag, 'color': Colors.red},
    {'title': 'Nouveau commentaire', 'subtitle': 'Sur le post de Marie', 'time': 'Il y a 5 heures', 'icon': Icons.comment, 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Activités récentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Voir tout', style: TextStyle(fontSize: 12, color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (activity['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(activity['icon'], color: activity['color'], size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(activity['subtitle'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Text(activity['time'], style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}