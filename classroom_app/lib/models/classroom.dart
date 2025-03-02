import 'dart:convert';

import 'package:classroom_app/models/assignment.dart';
import 'package:classroom_app/models/user.dart';

ClassroomResponse classroomResponseFromJson(String str) =>
    ClassroomResponse.fromJson(json.decode(str));

String classroomResponseToJson(ClassroomResponse data) =>
    json.encode(data.toJson());

ClassroomDetailResponse classroomDetailResponseFromJson(String str) =>
    ClassroomDetailResponse.fromJson(json.decode(str));

String classroomDetailResponseToJson(ClassroomDetailResponse data) =>
    json.encode(data.toJson());

class Classroom {
  final String id;
  final String name;
  final String description;
  final String? code;
  final String createdBy;

  Classroom({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    this.code,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    code: json["code"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "code": code,
    "createdBy": createdBy,
  };
}

class ClassroomResponse {
  final List<Classroom> teachingClassrooms;
  final List<Classroom> studyingClassrooms;

  ClassroomResponse({
    required this.teachingClassrooms,
    required this.studyingClassrooms,
  });

  factory ClassroomResponse.fromJson(Map<String, dynamic> json) =>
      ClassroomResponse(
        teachingClassrooms: List<Classroom>.from(
          json["teachingClassrooms"].map((x) => Classroom.fromJson(x)),
        ),
        studyingClassrooms: List<Classroom>.from(
          json["studyingClassrooms"].map((x) => Classroom.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "teachingClassrooms": List<dynamic>.from(
      teachingClassrooms.map((x) => x.toJson()),
    ),
    "studyingClassrooms": List<dynamic>.from(
      studyingClassrooms.map((x) => x.toJson()),
    ),
  };
}

class ClassroomDetailResponse {
  final Classroom classroom;
  final List<User> students;
  final List<User> teachers;
  final List<Assignment> assignments;

  ClassroomDetailResponse({
    required this.classroom,
    required this.students,
    required this.teachers,
    required this.assignments,
  });

  factory ClassroomDetailResponse.fromJson(
    Map<String, dynamic> json,
  ) => ClassroomDetailResponse(
    classroom: Classroom.fromJson(json["classroom"]),
    students: List<User>.from(json["students"].map((x) => User.fromJson(x))),
    teachers: List<User>.from(json["teachers"].map((x) => User.fromJson(x))),
    assignments: List<Assignment>.from(
      json["assignments"].map((x) => Assignment.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "classroom": classroom.toJson(),
    "students": List<dynamic>.from(students.map((x) => x.toJson())),
    "teachers": List<dynamic>.from(teachers.map((x) => x.toJson())),
    "assignments": List<dynamic>.from(assignments.map((x) => x.toJson())),
  };
}
