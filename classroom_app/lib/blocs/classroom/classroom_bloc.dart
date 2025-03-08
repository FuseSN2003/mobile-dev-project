import 'dart:convert';

import 'package:classroom_app/models/classroom.dart';
import 'package:classroom_app/utills/jwt_token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

part 'classroom_event.dart';
part 'classroom_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  ClassroomBloc() : super(ClassroomInitial()) {
    on<FetchClassroomList>(_onFetchClassroomList);
    on<JoinClassroom>(_onJoinClassroom);
    on<CreateClassroom>(_onCreateClassroom);
  }

  _onFetchClassroomList(
    FetchClassroomList event,
    Emitter<ClassroomState> emit,
  ) async {
    try {
      emit(ClassroomListLoading());

      final token = await getToken();

      final res = await http.get(
        Uri.parse('${dotenv.get("BACKEND_URL")}/classroom/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = classroomResponseFromJson(res.body);

      if (res.statusCode == 200) {
        return emit(
          ClassroomListLoaded(
            teachingClassrooms: jsonData.teachingClassrooms,
            studyingClassrooms: jsonData.studyingClassrooms,
          ),
        );
      } else {
        final currentState = state;
        if (currentState is ClassroomListLoaded) {
          emit(
            FetchClassroomListFailed(
              errorMessage: "Failed to fetch classroom lists",
            ),
          );
          return emit(
            ClassroomListLoaded(
              teachingClassrooms: currentState.teachingClassrooms,
              studyingClassrooms: currentState.studyingClassrooms,
            ),
          );
        }
        return emit(
          FetchClassroomListFailed(
            errorMessage: "Failed to fetch classroom lists",
          ),
        );
      }
    } catch (e) {
      debugPrint("Error on Fetch Classroom List ${e.toString()}");
      return emit(
        FetchClassroomListFailed(
          errorMessage: "Failed to fetch classroom lists",
        ),
      );
    }
  }

  _onJoinClassroom(JoinClassroom event, Emitter<ClassroomState> emit) async {
    final code = event.code;

    try {
      final token = await getToken();

      final res = await http.post(
        Uri.parse('${dotenv.get("BACKEND_URL")}/classroom/join'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({'code': code}),
      );

      final jsonData = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return add(FetchClassroomList());
      } else {
        final currentState = state;
        if (currentState is ClassroomListLoaded) {
          emit(JoinClassroomFailed(errorMessage: jsonData['message']));
          return emit(
            ClassroomListLoaded(
              teachingClassrooms: currentState.teachingClassrooms,
              studyingClassrooms: currentState.studyingClassrooms,
            ),
          );
        }
        return emit(JoinClassroomFailed(errorMessage: jsonData['message']));
      }
    } catch (e) {
      debugPrint("Error on Join Classroom ${e.toString()}");
      return emit(
        JoinClassroomFailed(errorMessage: "Failed to join classroom"),
      );
    }
  }

  _onCreateClassroom(
    CreateClassroom event,
    Emitter<ClassroomState> emit,
  ) async {
    final name = event.name;
    final description = event.description;

    try {
      final token = await getToken();

      final res = await http.post(
        Uri.parse("${dotenv.get("BACKEND_URL")}/classroom/"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({'name': name, 'description': description}),
      );

      final jsonData = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return add(FetchClassroomList());
      } else {
        final currentState = state;
        if (currentState is ClassroomListLoaded) {
          emit(CreateClassroomFailed(errorMessage: jsonData['message']));
          return emit(
            ClassroomListLoaded(
              teachingClassrooms: currentState.teachingClassrooms,
              studyingClassrooms: currentState.studyingClassrooms,
            ),
          );
        }
        return emit(CreateClassroomFailed(errorMessage: jsonData['message']));
      }
    } catch (e) {
      debugPrint("Error on Create Classroom ${e.toString()}");
      return emit(
        CreateClassroomFailed(errorMessage: "Failed to create classroom"),
      );
    }
  }
}
