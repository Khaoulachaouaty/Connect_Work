part of 'groups_cubit.dart';

abstract class GroupsState {}

class GroupsInitial extends GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final List<Group> publicGroups;
  final List<Group> userGroups;

  GroupsLoaded({required this.publicGroups, required this.userGroups});
}

class GroupsError extends GroupsState {
  final String message;

  GroupsError(this.message);
}
