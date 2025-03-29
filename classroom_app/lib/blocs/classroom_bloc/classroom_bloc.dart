import 'dart:convert';

import 'package:classroom_app/core/constant.dart';
import 'package:classroom_app/utils/jwt_token.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'classroom_event.dart';
part 'classroom_state.dart';

class ClassroomBloc extends Bloc<ClassroomEvent, ClassroomState> {
  ClassroomBloc() : super(ClassroomInitial()) {
    on<JoinClassroom>(_onJoinClassroom);
    on<CreateClassroom>(_onCreateClassroom);
  }

  _onCreateClassroom(
    CreateClassroom event,
    Emitter<ClassroomState> emit,
  ) async {
    emit(CreateClassroomLoading());

    final token = await getToken();
    final name = event.name;
    final description = event.description;

    try {
      final response = await http.post(
        Uri.parse('${AppConstant.backendURL}/c'),
        headers: {'Authorization': 'Bearer $token'},
        body: {'name': name, 'description': description},
      );

      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'success') {
        return emit(
          CreateClassroomSuccess(
            classroomId: jsonData['classroomId'],
            message: jsonData['message'],
          ),
        );
      } else {
        return emit(CreateClassroomFailed(message: jsonData['message']));
      }
    } catch (e) {
      debugPrint(e.toString());
      return emit(CreateClassroomFailed(message: "Something went wrong"));
    }
  }

  _onJoinClassroom(JoinClassroom event, Emitter<ClassroomState> emit) async {
    emit(JoinClassroomLoading());

    final token = await getToken();
    final code = event.code;

    try {
      final response = await http.post(
        Uri.parse('${AppConstant.backendURL}/c/join'),
        headers: {'Authorization': 'Bearer $token'},
        body: {'code': code},
      );

      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'success') {
        return emit(
          JoinClassroomSuccess(
            classroomId: jsonData['classroomId'],
            message: jsonData['message'],
          ),
        );
      } else {
        return emit(JoinClassroomFailed(message: jsonData['message']));
      }
    } catch (e) {
      debugPrint(e.toString());
      return emit(JoinClassroomFailed(message: "Something went wrong"));
    }
  }
}
