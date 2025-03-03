import 'dart:convert';

class Assignment {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final String createdAt;
  final String? dueDate;
  final int? maxScore;
  final bool? isSubmitted;
  final int? assigned;
  final int? submitted;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    this.dueDate,
    this.maxScore,
    this.submitted,
    this.assigned,
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
    assigned: json['assigned'],
    submitted: json['submitted'],
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
    "assigned": assigned,
    "submitted": submitted,
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
