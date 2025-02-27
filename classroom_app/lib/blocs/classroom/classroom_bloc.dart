import 'package:classroom_app/models/classroom.dart';
import 'package:classroom_app/utills/jwt_token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'classroom_event.dart';
part 'classroom_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  ClassroomBloc() : super(ClassroomInitial()) {
    on<FetchClassroomList>(_onFetchClassroomList);
  }

  _onFetchClassroomList(
    FetchClassroomList event,
    Emitter<ClassroomState> emit,
  ) async {
    try {
      emit(ClassroomListLoading());

      final token = await getToken();

      final res = await http.get(
        Uri.parse('http://10.0.2.2:3000/classroom/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = classroomResponseFromJson(res.body);

      emit(
        ClassroomListLoaded(
          teachingClassrooms: jsonData.teachingClassrooms,
          studyingClassrooms: jsonData.studyingClassrooms,
        ),
      );
    } catch (e) {
      debugPrint("Error on Fetch Classroom List ${e.toString()}");
    }
  }
}
