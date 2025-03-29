part of 'classroom_bloc.dart';

@immutable
sealed class ClassroomEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class JoinClassroom extends ClassroomEvent {
  final String code;

  JoinClassroom({required this.code});

  @override
  List<Object> get props => [code];
}

class CreateClassroom extends ClassroomEvent {
  final String name;
  final String description;

  CreateClassroom({required this.name, required this.description});

  @override
  List<Object> get props => [name, description];
}
