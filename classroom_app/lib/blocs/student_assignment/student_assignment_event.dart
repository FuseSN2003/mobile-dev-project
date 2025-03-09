part of 'student_assignment_bloc.dart';

@immutable
sealed class StudentAssignmentEvent {}

class FetchStudentAssignments extends StudentAssignmentEvent {
  final String studentName;
  final String assignmentId;

  FetchStudentAssignments({
    required this.studentName,
    required this.assignmentId,
  });
}

class GiveScore extends StudentAssignmentEvent {
  final String studentName;
  final String assignmentId;
  final int score;

  GiveScore({
    required this.studentName,
    required this.assignmentId,
    required this.score,
  });
}
