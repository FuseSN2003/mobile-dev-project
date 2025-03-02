import 'package:classroom_app/models/assignment.dart';
import 'package:classroom_app/models/classroom.dart';
import 'package:classroom_app/models/user.dart';
import 'package:classroom_app/utills/jwt_token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'classroom_detail_event.dart';
part 'classroom_detail_state.dart';

class ClassroomDetailBloc
    extends Bloc<ClassroomDetailEvent, ClassroomDetailState> {
  ClassroomDetailBloc() : super(ClassroomDetailInitial()) {
    on<FetchClassroomDetail>(_onFetchCLassroomDetail);
  }

  _onFetchCLassroomDetail(
    FetchClassroomDetail event,
    Emitter<ClassroomDetailState> emit,
  ) async {
    emit(ClassroomDetailLoading());
    final classroomId = event.classroomId;
    try {
      final token = await getToken();

      final res = await http.get(
        Uri.parse('http://10.0.2.2:3000/classroom/$classroomId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final result = classroomDetailResponseFromJson(res.body);

      if (res.statusCode == 200) {
        return emit(
          ClassroomDetailLoaded(
            classroom: result.classroom,
            students: result.students,
            teachers: result.teachers,
            assignments: result.assignments,
          ),
        );
      } else {
        return emit(
          FetchClassroomDetailFailed(
            errorMessage: "Failed to fetch classroom detail",
          ),
        );
      }
    } catch (e) {
      debugPrint("Error on Fetch Classroom Detail ${e.toString()}");
      return emit(
        FetchClassroomDetailFailed(
          errorMessage: "Failed to fetch classroom detail",
        ),
      );
    }
  }
}
