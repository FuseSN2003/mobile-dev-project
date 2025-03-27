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
