import 'dart:convert';

import 'package:classroom_app/core/constant.dart';
import 'package:classroom_app/model/classroom_model.dart';
import 'package:classroom_app/utils/jwt_token.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'classroom_list_event.dart';
part 'classroom_list_state.dart';

class ClassroomListBloc extends Bloc<ClassroomListEvent, ClassroomListState> {
  ClassroomListBloc() : super(ClassroomListInitial()) {
    on<FetchClassroomList>(_onFetchClassroomList);
  }

  _onFetchClassroomList(
    FetchClassroomList event,
    Emitter<ClassroomListState> emit,
  ) async {
    final token = await getToken();
    try {
      emit(ClassroomListLoading());
      final response = await http.get(
        Uri.parse('${AppConstant.backendURL}/c'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'success') {
        final List<Classroom> teachingClassrooms = List<Classroom>.from(
          jsonData['teachingClassrooms'].map((x) => Classroom.fromJson(x)),
        );
        final List<Classroom> studyingClassrooms = List<Classroom>.from(
          jsonData['studyingClassrooms'].map((x) => Classroom.fromJson(x)),
        );
        return emit(
          ClassroomListLoaded(
            teachingClassrooms: teachingClassrooms,
            studyingClassrooms: studyingClassrooms,
          ),
        );
      } else {
        return emit(FetchClassroomListFailed(message: jsonData['message']));
      }
    } catch (e) {
      debugPrint(e.toString());
      return emit(FetchClassroomListFailed(message: "Something went wrong"));
    }
  }
}
