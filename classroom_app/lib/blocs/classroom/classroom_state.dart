import 'package:equatable/equatable.dart';
import 'classroom_model.dart'; // Assuming you have this model

class ClassroomState extends Equatable {
  final List<Classroom> classrooms;
  final String? error;

  ClassroomState({required this.classrooms, this.error});

  @override
  List<Object?> get props => [classrooms, error];
}
