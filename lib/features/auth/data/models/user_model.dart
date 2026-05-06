// lib/auth/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String? photoUrl;
  final String? function;
  final String? bio;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String? phoneNumber;
  final String? gender;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    this.photoUrl,
    this.function,
    this.bio,
    this.role = 'employee',
    this.isActive = true,
    required this.createdAt,
    this.lastLoginAt,
    this.phoneNumber,
    this.gender,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? data['name'] ?? '',
      photoUrl: data['photoUrl'],
      function: data['function'],
      bio: data['bio'],
      role: data['role'] ?? 'employee',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate(),
      phoneNumber: data['phoneNumber'],
      gender: data['gender'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'function': function,
      'bio': bio,
      'role': role,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'phoneNumber': phoneNumber,
      'gender': gender,
    };
  }

  UserModel copyWith({
    String? fullName,
    String? photoUrl,
    String? function,
    String? bio,
    bool? isActive,
    DateTime? lastLoginAt,
    String? phoneNumber,
    String? gender,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      function: function ?? this.function,
      bio: bio ?? this.bio,
      role: role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
    );
  }
}