part of 'classroom_detail_bloc.dart';

@immutable
sealed class ClassroomDetailState {}

class ClassroomDetailInitial extends ClassroomDetailState {}

class FetchingPosts extends ClassroomDetailState {}

class PostsLoaded extends ClassroomDetailState {}

class FetchPostsFailed extends ClassroomDetailState {
  final String errorMessage;

  FetchPostsFailed({required this.errorMessage});
}

class FetchingAssignments extends ClassroomDetailState {}

class AssignmentsLoaded extends ClassroomDetailState {}

class FetchAssignmentsFailed extends ClassroomDetailState {
  final String errorMessage;

  FetchAssignmentsFailed({required this.errorMessage});
}

class FetchingMembers extends ClassroomDetailState {}

class MembersLoaded extends ClassroomDetailState {}

class FetchMembersFailed extends ClassroomDetailState {
  final String errorMessage;

  FetchMembersFailed({required this.errorMessage});
}