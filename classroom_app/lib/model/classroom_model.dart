class Classroom {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final int? studentCount;

  Classroom({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    this.studentCount,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    createdBy: json["createdBy"],
    studentCount: json["studentCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "createdBy": createdBy,
    "studentCount": studentCount,
  };
}
