part of 'member_bloc.dart';

@immutable
sealed class MemberEvent {}

class FetchMembers extends MemberEvent {
  final String classroomId;

  FetchMembers({required this.classroomId});
}
