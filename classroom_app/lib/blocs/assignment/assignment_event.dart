part of 'assignment_bloc.dart';

sealed class AssignmentEvent {}

class FetchAssignment extends AssignmentEvent {
  final String classroomId;

  FetchAssignment({required this.classroomId});
}

class AddAssignment extends AssignmentEvent {
  final String classroomId;
  final String title;
  final String description;
  final String dueDate;
  final List<File> files;
  final int score;

  AddAssignment({
    required this.classroomId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.files,
    required this.score,
  });
}

class SubmitAssignment extends AssignmentEvent {
  final String classroomId;
  final String assignmentId;
  final List<File> files;

  SubmitAssignment({
    required this.classroomId,
    required this.assignmentId,
    required this.files,
  });
}

class CancelAssignment extends AssignmentEvent {
  final String classroomId;
  final String assignmentId;

  CancelAssignment({required this.classroomId, required this.assignmentId});
}
