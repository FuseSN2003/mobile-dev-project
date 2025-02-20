import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ClassroomEvent {}

class AddClassroom extends ClassroomEvent {}

class RemoveClassroom extends ClassroomEvent {}

class LoadClassrooms extends ClassroomEvent {}

class FetchStudent_Classrooms extends ClassroomEvent {}
