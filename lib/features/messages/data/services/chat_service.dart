import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';
import '../../../auth/data/models/user_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer les discussions de l'utilisateur
  Stream<List<ChatRoom>> watchChatRooms(String userId) {
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoom.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Récupérer les messages d'une discussion
  Stream<List<Message>> watchMessages(String chatRoomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Envoyer un message
  Future<void> sendMessage(String chatRoomId, Message message) async {
    final batch = _firestore.batch();
    
    final messageRef = _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc();
        
    final roomRef = _firestore.collection('chat_rooms').doc(chatRoomId);

    batch.set(messageRef, message.toFirestore());
    
    batch.update(roomRef, {
      'lastMessage': message.type == MessageType.text ? message.content : 'Pièce jointe',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // Créer ou récupérer une discussion directe
  Future<String> getOrCreateDirectChat(String currentUserId, String otherUserId, {
    String? currentUserName, 
    String? currentUserAvatar,
    String? otherUserName, 
    String? otherUserAvatar,
  }) async {
    final participants = [currentUserId, otherUserId]..sort();
    final roomId = 'dm_${participants[0]}_${participants[1]}';
    
    final doc = await _firestore.collection('chat_rooms').doc(roomId).get();
    
    if (!doc.exists) {
      await _firestore.collection('chat_rooms').doc(roomId).set({
        'name': 'Direct Chat',
        'avatar': '',
        'isGroup': false,
        'participants': participants,
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCounts': {},
        'userNames': {
          currentUserId: currentUserName ?? 'Moi',
          otherUserId: otherUserName ?? 'Utilisateur',
        },
        'userAvatars': {
          currentUserId: currentUserAvatar ?? '',
          otherUserId: otherUserAvatar ?? '',
        },
      });
    } else {
      // Optionnel: Mettre à jour les noms si nécessaire
      await _firestore.collection('chat_rooms').doc(roomId).update({
        'userNames.$currentUserId': currentUserName ?? 'Moi',
        'userNames.$otherUserId': otherUserName ?? 'Utilisateur',
        if (currentUserAvatar != null) 'userAvatars.$currentUserId': currentUserAvatar,
        if (otherUserAvatar != null) 'userAvatars.$otherUserId': otherUserAvatar,
      });
    }
    
    return roomId;
  }

  // Rejoindre un chat de groupe
  Future<void> joinGroupChat(String groupId, String groupName, String groupAvatar, String userId) async {
    final roomId = 'group_$groupId';
    final roomRef = _firestore.collection('chat_rooms').doc(roomId);
    
    final doc = await roomRef.get();
    
    if (doc.exists) {
      await roomRef.update({
        'participants': FieldValue.arrayUnion([userId]),
      });
    } else {
      await roomRef.set({
        'name': groupName,
        'avatar': groupAvatar,
        'isGroup': true,
        'participants': [userId],
        'lastMessage': 'Bienvenue dans le groupe !',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCounts': {},
        'groupId': groupId,
      });
    }
  }

  // Rechercher des utilisateurs par nom
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.isEmpty) return [];
    
    final snapshot = await _firestore
        .collection('users')
        .where('fullName', isGreaterThanOrEqualTo: query)
        .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(10)
        .get();
        
    return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  // Liste de tous les utilisateurs (pour suggérer des contacts)
  Stream<List<UserModel>> watchAllUsers() {
    return _firestore
        .collection('users')
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList());
  }

  // Combiner les discussions réelles et les groupes rejoints (même vides)
  Stream<List<ChatRoom>> watchAllConversations(String userId) {
    // 1. Écouter les chat_rooms réels
    final chatRoomsStream = watchChatRooms(userId);
    
    // 2. Écouter les groupes rejoints
    final groupsStream = _firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return ChatRoom(
                id: 'group_${doc.id}',
                name: data['name'] ?? '',
                avatar: data['imageUrl'] ?? '',
                isGroup: true,
                participants: List<String>.from(data['members'] ?? []),
                lastMessage: 'Démarrez la discussion !',
                lastMessageTime: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
                groupId: doc.id,
              );
            }).toList());

    // Combiner les deux
    return Rx.combineLatest2<List<ChatRoom>, List<ChatRoom>, List<ChatRoom>>(
      chatRoomsStream,
      groupsStream,
      (rooms, groups) {
        final Map<String, ChatRoom> combined = {};
        
        // Ajouter les groupes d'abord (base des groupes rejoints)
        for (var g in groups) {
          combined[g.id] = g;
        }
        
        // Ajouter/Mettre à jour avec les vrais chat_rooms
        for (var r in rooms) {
          if (r.isGroup) {
            // Pour les groupes, on prend toujours la version de chat_rooms car elle a le dernier message réel
            combined[r.id] = r;
          } else {
            // Pour les DMs, on ne les ajoute QUE s'il y a un vrai message
            if (r.lastMessage.isNotEmpty) {
              combined[r.id] = r;
            }
          }
        }
        
        final list = combined.values.toList();
        // Trier par date du dernier message
        list.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
        return list;
      },
    );
  }
}
