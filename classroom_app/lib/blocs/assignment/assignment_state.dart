part of 'assignment_bloc.dart';

sealed class AssignmentState {}

class AssignmentInitial extends AssignmentState {}

class AssignmentLoading extends AssignmentState {}

class AssignmentLoaded extends AssignmentState {
  final List<Assignment> assignments;

  AssignmentLoaded({required this.assignments});
}

class AddAssignmentSuccess extends AssignmentState {}
