// lib/features/admin/groups/data/models/group_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String description;
  final bool isPrivate;
  final List<String> members;
  final List<String> pendingMembers;
  final String createdBy;
  final DateTime createdAt;
  final String? imageUrl;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isPrivate,
    required this.members,
    this.pendingMembers = const [],
    required this.createdBy,
    required this.createdAt,
    this.imageUrl,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map, String id) {
    // Gestion sécurisée de la date
    DateTime createdAt;
    if (map['createdAt'] == null) {
      createdAt = DateTime.now();
    } else if (map['createdAt'] is Timestamp) {
      createdAt = (map['createdAt'] as Timestamp).toDate();
    } else if (map['createdAt'] is DateTime) {
      createdAt = map['createdAt'] as DateTime;
    } else {
      createdAt = DateTime.now();
    }

    return GroupModel(
      id: id,
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      isPrivate: map['isPrivate'] ?? false,
      members: List<String>.from(map['members'] ?? []),
      pendingMembers: List<String>.from(map['pendingMembers'] ?? []),
      createdBy: map['createdBy']?.toString() ?? '',
      createdAt: createdAt,
      imageUrl: map['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'isPrivate': isPrivate,
      'members': members,
      'pendingMembers': pendingMembers,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrl': imageUrl,
    };
  }
}