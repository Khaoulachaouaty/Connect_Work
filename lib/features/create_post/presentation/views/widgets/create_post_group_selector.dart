import 'package:flutter/material.dart';
import 'package:connect_work/core/utils/app_colors.dart';
import 'package:connect_work/features/groups/data/models/group_modele.dart';

class CreatePostGroupSelector extends StatelessWidget {
  final String? selectedGroupId;
  final List<Group> userGroups;
  final ValueChanged<String?> onChanged;

  const CreatePostGroupSelector({
    super.key,
    required this.selectedGroupId,
    required this.userGroups,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedGroupId,
          hint: const Text('Sélectionner un groupe (Optionnel)', style: TextStyle(fontSize: 12)),
          icon: const Icon(Icons.arrow_drop_down, size: 18),
          onChanged: onChanged,
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('Fil d\'actualité public', style: TextStyle(fontSize: 12)),
            ),
            ...userGroups.map((Group group) {
              return DropdownMenuItem<String?>(
                value: group.id,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.groups_rounded, size: 16, color: AppColor.primary),
                    const SizedBox(width: 8),
                    Text(group.name, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
