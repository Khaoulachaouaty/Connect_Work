// lib/features/admin/employees/data/services/employee_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/employee_model.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<EmployeeModel>> getEmployees() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => EmployeeModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> createEmployee({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    String? function,
    String? department,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email.trim(),
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'function': function,
      'department': department,
      'role': 'employee',
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(id).update(data);
  }

  Future<void> toggleEmployeeStatus(String id, bool isActive) async {
    await _firestore.collection('users').doc(id).update({'isActive': isActive});
  }

  // ✅ VRAIE SUPPRESSION
  Future<void> deleteEmployee(String id) async {
    try {
      // 1. Supprimer le document Firestore
      await _firestore.collection('users').doc(id).delete();
      
      // 2. Supprimer l'utilisateur Firebase Auth
      // Note: Cette partie nécessite l'utilisateur actuel ou des droits admin
      // Pour supprimer un autre utilisateur, il faut utiliser Firebase Admin SDK
      // via une Cloud Function ou le consoler manuellement
      
      print('Employé $id supprimé avec succès');
    } catch (e) {
      throw Exception('Erreur lors de la suppression: $e');
    }
  }
}