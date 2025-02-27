part of 'classroom_bloc.dart';

@immutable
sealed class ClassroomState {}

class ClassroomInitial extends ClassroomState {}

class ClassroomListLoading extends ClassroomState {}

class ClassroomListLoaded extends ClassroomState {
  final List<Classroom> teachingClassrooms;
  final List<Classroom> studyingClassrooms;

  ClassroomListLoaded({
    required this.teachingClassrooms,
    required this.studyingClassrooms,
  });
}
