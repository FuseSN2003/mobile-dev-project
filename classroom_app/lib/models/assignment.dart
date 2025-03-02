import 'dart:convert';

Assignment assignmentFromJSON(String str) =>
    Assignment.fromJson(json.decode(str));

String assignmentToJSON(Assignment data) => json.encode(data.toJson());

class Assignment {
  final String id;
  final String classroomId;
  final String title;
  final String description;
  final String? dueDate;
  final int? maxScore;
  final String createdBy;
  final String createdAt;

  Assignment({
    required this.id,
    required this.classroomId,
    required this.title,
    required this.description,
    this.dueDate,
    this.maxScore,
    required this.createdBy,
    required this.createdAt,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    id: json["id"],
    classroomId: json["classroomId"],
    title: json["title"],
    description: json["description"],
    dueDate: json["dueDate"],
    maxScore: json["maxScore"],
    createdBy: json["createdBy"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "classroomId": classroomId,
    "title": title,
    "description": description,
    "dueDate": dueDate,
    "maxScore": maxScore,
    "createdBy": createdBy,
    "createdAt": createdAt,
  };
}
