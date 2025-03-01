part of 'classroom_detail_bloc.dart';

@immutable
sealed class ClassroomDetailEvent {}

class FetchClassroomDetail extends ClassroomDetailEvent {
  final String classroomId;

  FetchClassroomDetail({required this.classroomId});
}
