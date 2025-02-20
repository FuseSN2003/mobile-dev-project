import 'package:equatable/equatable.dart';

class Classroom extends Equatable {
  final String id;
  final String name;
  final String teacher;
  final int capacity;
  final List<String> students; // List of student names or ids

  Classroom({
    required this.id,
    required this.name,
    required this.teacher,
    required this.capacity,
    required this.students,
  });

  @override
  List<Object?> get props => [id, name, teacher, capacity, students];
}
