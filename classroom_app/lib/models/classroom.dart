import 'dart:convert';

ClassroomResponse classroomResponseFromJson(String str) =>
    ClassroomResponse.fromJson(json.decode(str));

String classroomResponseToJson(ClassroomResponse data) =>
    json.encode(data.toJson());

class Classroom {
  final String id;
  final String name;
  final String description;
  final String createdBy;

  Classroom({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
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
