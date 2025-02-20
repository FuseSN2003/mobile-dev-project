import 'package:flutter_bloc/flutter_bloc.dart';
import 'classroom_event.dart';
import 'classroom_state.dart';
import 'classroom_model.dart';

// Define Bloc
class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  ClassroomBloc() : super(ClassroomState(classrooms: [])) {
    on<FetchStudent_Classrooms>((event, emit) async {
      print("Fetching classrooms...");
      emit(
        ClassroomState(
          classrooms: [
            Classroom(
              id: "1",
              name: "Math Class",
              teacher: "Mr. Smith",
              capacity: 30,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
            Classroom(
              id: "2",
              name: "Science Class",
              teacher: "Ms. Johnson",
              capacity: 25,
              students: [],
            ),
          ],
        ),
      );
      // final classrooms = await api.getClassrooms();
    });
  }
}
