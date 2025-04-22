part of 'classroom_detail_bloc.dart';

@immutable
sealed class ClassroomDetailState {}

class ClassroomDetailInitial extends ClassroomDetailState {}

class ClassroomDetailLoading extends ClassroomDetailState {}

class ClassroomDetailLoaded extends ClassroomDetailState {
  final Classroom classroom;

  ClassroomDetailLoaded({required this.classroom});
}

class FetchClassroomDetailFailed extends ClassroomDetailState {
  final String message;

  FetchClassroomDetailFailed({required this.message});
}
