part of 'classroom_detail_bloc.dart';

sealed class ClassroomDetailState {}

class ClassroomDetailInitial extends ClassroomDetailState {}

class ClassroomDetailLoading extends ClassroomDetailState {}

class ClassroomDetailLoaded extends ClassroomDetailState {
  final Classroom classroom;
  final List<User> students;
  final List<User> teachers;
  final List<Assignment> assignments;

  ClassroomDetailLoaded({
    required this.classroom,
    required this.students,
    required this.teachers,
    required this.assignments,
  });
}

class FetchClassroomDetailFailed extends ClassroomDetailState {
  final String errorMessage;

  FetchClassroomDetailFailed({required this.errorMessage});
}
