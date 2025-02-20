import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ClassroomState extends Equatable {
  final List<Map<String, String>> classrooms;
  ClassroomState({required this.classrooms});

  @override
  List<Object> get props => [classrooms];
}
