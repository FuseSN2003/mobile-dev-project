part of 'assignment_detail_bloc.dart';

@immutable
class AssignmentDetailState {}

class AssignmentDetailInitial extends AssignmentDetailState {}

class AssignmentDetailLoading extends AssignmentDetailState {}

class AssignmentDetailLoaded extends AssignmentDetailState {
  final AssignmentDetail assignment;
  final List<Attachment>? submissionAttachments;

  AssignmentDetailLoaded({
    required this.assignment,
    this.submissionAttachments,
  });
}
