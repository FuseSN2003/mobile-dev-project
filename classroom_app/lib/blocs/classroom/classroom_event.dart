part of 'classroom_bloc.dart';

@immutable
sealed class ClassroomEvent {}

class FetchClassroomList extends ClassroomEvent {}

class FetchClassroomDetail extends ClassroomEvent {
  final String classroomId;

  FetchClassroomDetail({required this.classroomId});
}
