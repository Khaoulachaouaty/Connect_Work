// lib/features/admin/dashboard/data/services/dashboard_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getStats() async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();
      final employees = usersSnapshot.docs.where((doc) => doc['role'] == 'employee').toList();
      int activeEmployees = employees.where((emp) => emp['isActive'] == true).length;
      
      final groupsSnapshot = await _firestore.collection('groups').get();
      final groups = groupsSnapshot.docs;
      int privateGroups = groups.where((g) => g['isPrivate'] == true).length;
      
      final postsSnapshot = await _firestore.collection('posts').get();
      final totalPosts = postsSnapshot.size;
      
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      int todayPosts = 0;
      
      for (var post in postsSnapshot.docs) {
        final createdAt = post['createdAt'];
        if (createdAt != null) {
          try {
            DateTime postDate = (createdAt is Timestamp) ? createdAt.toDate() : createdAt as DateTime;
            if (postDate.isAfter(startOfDay)) todayPosts++;
          } catch (e) { continue; }
        }
      }

      return {
        'totalEmployees': employees.length,
        'activeEmployees': activeEmployees,
        'totalGroups': groups.length,
        'privateGroups': privateGroups,
        'totalPosts': totalPosts,
        'todayPosts': todayPosts,
      };
    } catch (e) {
      return {'totalEmployees': 0, 'activeEmployees': 0, 'totalGroups': 0, 'privateGroups': 0, 'totalPosts': 0, 'todayPosts': 0};
    }
  }
}