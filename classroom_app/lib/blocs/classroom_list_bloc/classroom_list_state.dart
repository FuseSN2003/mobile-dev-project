part of 'classroom_list_bloc.dart';

@immutable
sealed class ClassroomListState extends Equatable {
  @override
  List<Object> get props => [];
}

class ClassroomListInitial extends ClassroomListState {}

class ClassroomListLoading extends ClassroomListState {}

class ClassroomListLoaded extends ClassroomListState {
  final List<Classroom> teachingClassrooms;
  final List<Classroom> studyingClassrooms;

  ClassroomListLoaded({
    required this.teachingClassrooms,
    required this.studyingClassrooms,
  });
}

class FetchClassroomListFailed extends ClassroomListState {
  final String message;

  FetchClassroomListFailed({required this.message});
}
