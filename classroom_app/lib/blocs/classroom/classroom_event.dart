part of 'classroom_bloc.dart';

@immutable
sealed class ClassroomEvent {}

class FetchClassroomList extends ClassroomEvent {}

class JoinClassroom extends ClassroomEvent {
  final String code;

  JoinClassroom({required this.code});
}

class FetchClassroomDetail extends ClassroomEvent {
  final String classroomId;

  FetchClassroomDetail({required this.classroomId});
}
