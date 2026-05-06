import 'package:connect_work/core/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/group_modele.dart';
import '../../cubit/groups_cubit.dart';
import '../group_detail_view.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final isPending = group.pendingMembers.contains(userId);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GroupDetailView(group: group),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: group.imageUrl.isNotEmpty
                      ? Image.network(
                          group.imageUrl,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 140,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.groups_rounded, size: 48, color: Colors.grey),
                        ),
                ),
                if (group.isPrivate)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.lock_rounded, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Privé',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    group.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.people_alt_rounded, size: 16, color: AppColor.primary.withOpacity(0.7)),
                      const SizedBox(width: 6),
                      Text(
                        '${group.memberCount} membres',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      _buildActionButton(context, isPending),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, bool isPending) {
    if (group.isMember) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              'Membre',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (isPending) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'En attente',
          style: TextStyle(color: Colors.orange.shade700, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ElevatedButton(
      onPressed: () => context.read<GroupsCubit>().joinGroup(group.id),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        group.isPrivate ? 'Demander' : 'Rejoindre',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}