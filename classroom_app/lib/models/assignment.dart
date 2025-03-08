import 'dart:convert';

import 'package:classroom_app/models/file.dart';

class Assignment {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final String createdAt;
  final String? dueDate;
  final int? maxScore;
  final int? scoreReceived;
  final bool? isSubmitted;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    this.scoreReceived,
    this.dueDate,
    this.maxScore,
    this.isSubmitted,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    dueDate: json['dueDate'],
    maxScore: json['maxScore'],
    createdBy: json['createdBy'],
    createdAt: json['createdAt'],
    isSubmitted: json['isSubmitted'],
    scoreReceived: json['scoreReceived'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "dueDate": dueDate,
    "maxScore": maxScore,
    "createdBy": createdBy,
    "createdAt": createdAt,
    "isSubmitted": isSubmitted,
    "scoreReceived": scoreReceived,
  };
}

AssignmentListResponse assignmentListResponseFromJSON(String str) =>
    AssignmentListResponse.fromJson(json.decode(str));

class AssignmentListResponse {
  final List<Assignment> assignments;

  AssignmentListResponse({required this.assignments});

  factory AssignmentListResponse.fromJson(Map<String, dynamic> json) =>
      AssignmentListResponse(
        assignments: List<Assignment>.from(
          json["assignments"].map((x) => Assignment.fromJson(x)),
        ),
      );
}

class AssignmentDetail {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final String createdAt;
  final int? maxScore;
  final String? dueDate;
  final List<Attachment>? attachments;
  // teacher
  final List<String>? submittedStudents;
  final int? assigned;
  final String? submittedAt;
  // student
  final int? scoreReceived;
  final bool? isSubmitted;

  AssignmentDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    this.attachments,
    this.submittedStudents,
    this.scoreReceived,
    this.submittedAt,
    this.dueDate,
    this.maxScore,
    this.assigned,
    this.isSubmitted,
  });

  factory AssignmentDetail.fromJson(Map<String, dynamic> json) {
    return AssignmentDetail(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['dueDate'],
      maxScore: json['maxScore'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      scoreReceived: json['scoreReceived'],
      submittedAt: json['submittedAt'],
      attachments:
          json['attachments'] != null
              ? List<Attachment>.from(
                json['attachments'].map((x) => Attachment.fromJson(x)),
              )
              : null,
      submittedStudents:
          json['submittedStudents'] != null
              ? List<String>.from(json['submittedStudents'])
              : null,
      isSubmitted: json['isSubmitted'],
      assigned: json['assigned'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "dueDate": dueDate,
    "maxScore": maxScore,
    "createdBy": createdBy,
    "createdAt": createdAt,
    "submittedStudents": submittedStudents,
    "attachments": attachments,
    "isSubmitted": isSubmitted,
    "assigned": assigned,
    "scoreReceived": scoreReceived,
    "submittedAt": submittedAt,
  };
}

AssignmentDetailResponse assignmentDetailResponseFromJSON(String str) =>
    AssignmentDetailResponse.fromJson(json.decode(str));

class AssignmentDetailResponse {
  final AssignmentDetail assignment;

  AssignmentDetailResponse({required this.assignment});

  factory AssignmentDetailResponse.fromJson(Map<String, dynamic> json) =>
      AssignmentDetailResponse(
        assignment: AssignmentDetail.fromJson(json['assignment']),
      );
}
