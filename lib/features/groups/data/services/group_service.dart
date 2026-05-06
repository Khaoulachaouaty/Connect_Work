import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_modele.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer tous les groupes publics
  Future<List<Group>> getAllPublicGroups(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('groups')
          .where('isPrivate', isEqualTo: false)
          .get();
      return snapshot.docs.map((doc) => _mapDocToGroup(doc, currentUserId: userId)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des groupes: $e');
    }
  }

  // Récupérer les groupes de l'utilisateur
  Future<List<Group>> getUserGroups(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('groups')
          .where('members', arrayContains: userId)
          .get();
      return snapshot.docs.map((doc) => _mapDocToGroup(doc, currentUserId: userId)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des groupes utilisateur: $e');
    }
  }

  // Surveiller les IDs des groupes auxquels l'utilisateur appartient
  Stream<List<String>> watchUserGroupIds(String userId) {
    return _firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // Créer un groupe (Admin uniquement)
  Future<void> createGroup({
    required String name,
    required String description,
    required String imageUrl,
    required bool isPrivate,
    required String adminId,
  }) async {
    try {
      await _firestore.collection('groups').add({
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'isPrivate': isPrivate,
        'adminId': adminId,
        'members': [adminId],
        'memberCount': 1,
        'pendingMembers': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la création du groupe: $e');
    }
  }

  // Rejoindre un groupe
  Future<void> joinGroup(String groupId, String userId) async {
    try {
      final groupRef = _firestore.collection('groups').doc(groupId);
      final groupDoc = await groupRef.get();

      if (!groupDoc.exists) throw Exception('Groupe introuvable');

      final data = groupDoc.data() as Map<String, dynamic>;
      final isPrivate = data['isPrivate'] ?? false;
      final members = List<String>.from(data['members'] ?? []);
      final pendingMembers = List<String>.from(data['pendingMembers'] ?? []);

      if (members.contains(userId)) throw Exception('Déjà membre');

      if (isPrivate) {
        if (!pendingMembers.contains(userId)) {
          await groupRef.update({
            'pendingMembers': FieldValue.arrayUnion([userId])
          });
        }
      } else {
        await groupRef.update({
          'members': FieldValue.arrayUnion([userId]),
          'memberCount': FieldValue.increment(1),
        });
      }
    } catch (e) {
      throw Exception('Erreur lors de la demande d\'adhésion: $e');
    }
  }

  // Accepter un membre (Admin uniquement)
  Future<void> acceptMember(String groupId, String userId) async {
    try {
      final groupRef = _firestore.collection('groups').doc(groupId);
      await _firestore.runTransaction((transaction) async {
        transaction.update(groupRef, {
          'members': FieldValue.arrayUnion([userId]),
          'memberCount': FieldValue.increment(1),
          'pendingMembers': FieldValue.arrayRemove([userId]),
        });
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'acceptation du membre: $e');
    }
  }

  // Refuser un membre (Admin uniquement)
  Future<void> rejectMember(String groupId, String userId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'pendingMembers': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw Exception('Erreur lors du refus du membre: $e');
    }
  }

  // Quitter un groupe
  Future<void> leaveGroup(String groupId, String userId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayRemove([userId]),
        'memberCount': FieldValue.increment(-1),
      });
    } catch (e) {
      throw Exception('Erreur lors de la sortie du groupe: $e');
    }
  }

  // Obtenir les détails d'un groupe
  Future<Group?> getGroupDetails(String groupId, {String? currentUserId}) async {
    try {
      final doc = await _firestore.collection('groups').doc(groupId).get();
      if (!doc.exists) return null;
      return _mapDocToGroup(doc, currentUserId: currentUserId);
    } catch (e) {
      throw Exception('Erreur lors de la récupération du groupe: $e');
    }
  }

  // Helper pour mapper le document Firestore vers le modèle Group
  Group _mapDocToGroup(DocumentSnapshot doc, {String? currentUserId}) {
    final data = doc.data() as Map<String, dynamic>;
    final members = List<String>.from(data['members'] ?? []);
    return Group(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      memberCount: (data['memberCount'] as num?)?.toInt() ?? 0,
      isMember: currentUserId != null ? members.contains(currentUserId) : false,
      isPrivate: data['isPrivate'] ?? false,
      adminId: data['adminId'] ?? '',
      members: members,
      pendingMembers: List<String>.from(data['pendingMembers'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
