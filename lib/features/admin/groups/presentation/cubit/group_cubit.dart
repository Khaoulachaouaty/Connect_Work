// lib/features/admin/groups/presentation/cubit/group_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/group_service.dart';
import '../../data/models/group_model.dart';
import 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupService _groupService;

  GroupCubit(this._groupService) : super(GroupInitial());

  // ==================== GROUPES ====================
  
  void loadGroups() {
    emit(GroupLoading());
    _groupService.getGroups().listen(
      (groups) => emit(GroupLoaded(groups)),
      onError: (error) => emit(GroupError(error.toString())),
    );
  }

  Future<void> createGroup({
    required String name,
    required String description,
    required String createdBy,
    bool isPrivate = false,
    String? imageUrl,
  }) async {
    try {
      print('=== CREATE GROUP CUBIT ===');
      print('Nom: $name');
      print('Image URL: $imageUrl');
      
      await _groupService.createGroup(
        name: name,
        description: description,
        createdBy: createdBy,
        isPrivate: isPrivate,
        imageUrl: imageUrl,
      );
      emit(GroupSuccess('Groupe créé avec succès'));
      await Future.delayed(const Duration(milliseconds: 500));
      loadGroups();
    } catch (e) {
      print('❌ Erreur createGroup: $e');
      emit(GroupError(e.toString()));
    }
  }

  Future<void> updateGroup(String groupId, Map<String, dynamic> data) async {
    try {
      await _groupService.updateGroup(groupId, data);
      emit(GroupSuccess('Groupe modifié avec succès'));
      loadGroups();
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      await _groupService.deleteGroup(groupId);
      emit(GroupSuccess('Groupe supprimé'));
      loadGroups();
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  // ==================== MEMBRES ====================
  
  Future<void> addMember(String groupId, String userId) async {
    try {
      await _groupService.addMember(groupId, userId);
      emit(GroupSuccess('Membre ajouté'));
      loadGroups();
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> removeMember(String groupId, String userId) async {
    try {
      await _groupService.removeMember(groupId, userId);
      emit(GroupSuccess('Membre retiré'));
      loadGroups();
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }
}