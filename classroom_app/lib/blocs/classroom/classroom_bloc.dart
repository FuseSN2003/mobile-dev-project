import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'classroom_event.dart';
import 'classroom_state.dart';

// Define Bloc
class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  ClassroomBloc() : super(ClassroomState(classrooms: [])) {
    // on<AddClassroom>();
    on<LoadClassrooms>((event, emit) async {
      // try {
      //   emit(ClassroomState(classrooms: [])); // Show loading state
      //   final classrooms = await api.getClassrooms(); // Call API here
      //   emit(
      //     ClassroomState(classrooms: classrooms),
      //   ); // Emit new state after loading
      // } catch (e) {
      //   emit(
      //     ClassroomState(classrooms: [], error: e.toString()),
      //   ); // Handle error
      // }
    });
  }
}
