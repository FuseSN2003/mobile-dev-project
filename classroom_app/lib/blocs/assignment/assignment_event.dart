part of 'assignment_bloc.dart';

sealed class AssignmentEvent {}

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
