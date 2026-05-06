// lib/features/admin/groups/data/services/group_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/group_model.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Configuration Cloudinary (identique à vos posts)
  static const String _cloudinaryUploadUrl =
      'https://api.cloudinary.com/v1_1/db6pmpwhr/upload';
  static const String _cloudinaryPreset = 'group_preset';
  static const String _cloudinaryFolder = 'groups';

  // ==================== GROUPES ====================
  
  /// Récupérer tous les groupes en temps réel
  Stream<List<GroupModel>> getGroups() {
    return _firestore
        .collection('groups')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => GroupModel.fromMap(doc.data(), doc.id)).toList());
  }

  /// Créer un nouveau groupe
  Future<void> createGroup({
    required String name,
    required String description,
    required String createdBy,
    bool isPrivate = false,
    String? imageUrl,
  }) async {
    final data = {
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'isPrivate': isPrivate,
      'members': [createdBy],
      'pendingMembers': [],
      'createdAt': FieldValue.serverTimestamp(),
    };
    if (imageUrl != null && imageUrl.isNotEmpty) {
      data['imageUrl'] = imageUrl;
    }
    await _firestore.collection('groups').add(data);
  }

  /// Modifier un groupe
  Future<void> updateGroup(String groupId, Map<String, dynamic> data) async {
    await _firestore.collection('groups').doc(groupId).update(data);
  }

  /// Supprimer un groupe
  Future<void> deleteGroup(String groupId) async {
    await _firestore.collection('groups').doc(groupId).delete();
  }

  // ==================== GESTION DES MEMBRES ====================
  
  /// Ajouter un membre
  Future<void> addMember(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  /// Retirer un membre
  Future<void> removeMember(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayRemove([userId]),
    });
  }

  /// Demander à rejoindre (groupe privé)
  Future<void> requestToJoin(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'pendingMembers': FieldValue.arrayUnion([userId]),
    });
  }

  /// Approuver une demande
  Future<void> approveMember(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
      'pendingMembers': FieldValue.arrayRemove([userId]),
    });
  }

  /// Refuser une demande
  Future<void> rejectMember(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'pendingMembers': FieldValue.arrayRemove([userId]),
    });
  }

  // ==================== UPLOAD IMAGE ====================
  
  /// Uploader une image vers Cloudinary (identique à PostService)
  Future<String?> uploadGroupImage(File file) async {
    try {
      print('=== UPLOAD IMAGE GROUPE ===');
      print('Fichier: ${file.path}');
      print('Taille: ${await file.length()} bytes');
      
      final uri = Uri.parse(_cloudinaryUploadUrl);

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = _cloudinaryPreset
        ..fields['folder'] = _cloudinaryFolder
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      final body = await response.stream.bytesToString();

      print('Status code: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('❌ Cloudinary upload failed: $body');
        return null;
      }

      final jsonData = json.decode(body) as Map<String, dynamic>;
      
      if (jsonData['secure_url'] == null) {
        print('❌ Pas de secure_url dans la réponse');
        return null;
      }

      final imageUrl = jsonData['secure_url'] as String;
      print('✅ Image uploadée avec succès: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('❌ Exception lors de l\'upload: $e');
      return null;
    }
  }
}