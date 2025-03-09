part of 'student_assignment_bloc.dart';

@immutable
sealed class StudentAssignmentState {}

class StudentAssignmentInitial extends StudentAssignmentState {}

class StudentAssignmentLoading extends StudentAssignmentState {}

class StudentAssignmentLoaded extends StudentAssignmentState {
  final StudentAssignment studentAssignment;

  StudentAssignmentLoaded({required this.studentAssignment});
}
