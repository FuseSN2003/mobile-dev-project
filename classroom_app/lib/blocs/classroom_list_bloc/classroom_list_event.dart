part of 'classroom_list_bloc.dart';

@immutable
sealed class ClassroomListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchClassroomList extends ClassroomListEvent {}
