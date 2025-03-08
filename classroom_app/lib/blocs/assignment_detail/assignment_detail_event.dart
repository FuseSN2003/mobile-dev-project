part of 'assignment_detail_bloc.dart';

@immutable
class AssignmentDetailEvent {}

class FetchAssignmentDetail extends AssignmentDetailEvent {
  final String assignmentId;
  final String classroomId;

  FetchAssignmentDetail({
    required this.assignmentId,
    required this.classroomId,
  });
}
