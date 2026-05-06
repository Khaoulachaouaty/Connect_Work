// lib/features/admin/dashboard/presentation/views/widgets/stats_grid.dart
import 'package:flutter/material.dart';
import 'stats_card.dart';

class StatsGrid extends StatelessWidget {
  final Map<String, dynamic> stats;

  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final totalEmployees = stats['totalEmployees'] ?? 0;
    final activeEmployees = stats['activeEmployees'] ?? 0;
    final totalGroups = stats['totalGroups'] ?? 0;
    final todayPosts = stats['todayPosts'] ?? 0;
    final activityRate = totalEmployees > 0
        ? ((activeEmployees / totalEmployees) * 100).toInt()
        : 0;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        StatsCard(
          title: 'Employés',
          value: '$totalEmployees',
          icon: Icons.people,
          color: Colors.blue,
          subtitle: '$activeEmployees actifs',
        ),
        StatsCard(
          title: 'Groupes',
          value: '$totalGroups',
          icon: Icons.group,
          color: Colors.purple,
          subtitle: 'créés',
        ),
        StatsCard(
          title: 'Activité',
          value: '$activityRate%',
          icon: Icons.trending_up,
          color: Colors.green,
          subtitle: 'taux d\'activité',
        ),
        StatsCard(
          title: 'Posts',
          value: '$todayPosts',
          icon: Icons.post_add,
          color: Colors.orange,
          subtitle: 'aujourd\'hui',
        ),
      ],
    );
  }
}