part of 'classroom_bloc.dart';

@immutable
sealed class ClassroomState extends Equatable {
  @override
  List<Object> get props => [];
}

class ClassroomInitial extends ClassroomState {}

class CreateClassroomLoading extends ClassroomState {}

class CreateClassroomSuccess extends ClassroomState {
  final String classroomId;
  final String message;

  CreateClassroomSuccess({required this.classroomId, required this.message});

  @override
  List<Object> get props => [classroomId, message];
}

class CreateClassroomFailed extends ClassroomState {
  final String message;

  CreateClassroomFailed({required this.message});

  @override
  List<Object> get props => [message];
}

class JoinClassroomLoading extends ClassroomState {}

class JoinClassroomSuccess extends ClassroomState {
  final String classroomId;
  final String message;

  JoinClassroomSuccess({required this.classroomId, required this.message});

  @override
  List<Object> get props => [classroomId, message];
}

class JoinClassroomFailed extends ClassroomState {
  final String message;

  JoinClassroomFailed({required this.message});

  @override
  List<Object> get props => [message];
}
