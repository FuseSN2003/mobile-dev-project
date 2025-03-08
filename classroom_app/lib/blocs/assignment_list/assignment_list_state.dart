part of 'assignment_list_bloc.dart';

@immutable
sealed class AssignmentListState {}

class AssignmentListInitial extends AssignmentListState {}

class AssignmentListLoading extends AssignmentListState {}

class AssignmentListLoaded extends AssignmentListState {
  final List<Assignment> assignedAssignments;
  final List<Assignment> overdueAssignments;
  final List<Assignment> submittedAssignments;

  AssignmentListLoaded({
    required this.assignedAssignments,
    required this.overdueAssignments,
    required this.submittedAssignments,
  });
}
