import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/group_modele.dart';
import '../../data/services/group_service.dart';

part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final GroupService _groupService;
  final String currentUserId;
  
  List<Group> _allPublicGroups = [];
  List<Group> _allUserGroups = [];

  GroupsCubit(this._groupService, this.currentUserId)
      : super(GroupsInitial());

  Future<void> loadGroups() async {
    emit(GroupsLoading());
    try {
      _allPublicGroups = await _groupService.getAllPublicGroups(currentUserId);
      _allUserGroups = await _groupService.getUserGroups(currentUserId);
      
      emit(GroupsLoaded(
        publicGroups: _allPublicGroups, 
        userGroups: _allUserGroups
      ));
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> createGroup({
    required String name,
    required String description,
    required String imageUrl,
    required bool isPrivate,
  }) async {
    try {
      await _groupService.createGroup(
        name: name,
        description: description,
        imageUrl: imageUrl,
        isPrivate: isPrivate,
        adminId: currentUserId,
      );
      await loadGroups();
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> joinGroup(String groupId) async {
    try {
      await _groupService.joinGroup(groupId, currentUserId);
      await loadGroups();
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> acceptMember(String groupId, String userId) async {
    try {
      await _groupService.acceptMember(groupId, userId);
      await loadGroups();
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> rejectMember(String groupId, String userId) async {
    try {
      await _groupService.rejectMember(groupId, userId);
      await loadGroups();
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  Future<void> leaveGroup(String groupId) async {
    try {
      await _groupService.leaveGroup(groupId, currentUserId);
      await loadGroups();
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }
}
