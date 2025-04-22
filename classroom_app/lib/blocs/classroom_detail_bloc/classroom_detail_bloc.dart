import 'dart:convert';

import 'package:classroom_app/core/constant.dart';
import 'package:classroom_app/model/classroom_model.dart';
import 'package:classroom_app/utils/jwt_token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'classroom_detail_event.dart';
part 'classroom_detail_state.dart';

class ClassroomDetailBloc
    extends Bloc<ClassroomDetailEvent, ClassroomDetailState> {
  ClassroomDetailBloc() : super(ClassroomDetailInitial()) {
    on<FetchClassroomDetail>(_onFetchClassroomDetail);
  }

  _onFetchClassroomDetail(
    FetchClassroomDetail event,
    Emitter<ClassroomDetailState> emit,
  ) async {
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse('${AppConstant.backendURL}/c/${event.classroomId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'success') {
        final classroom = Classroom.fromJson(jsonData['classroom']);
        emit(ClassroomDetailLoaded(classroom: classroom));
      } else {
        emit(FetchClassroomDetailFailed(message: jsonData['message']));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(FetchClassroomDetailFailed(message: "Something went wrong"));
    }
  }
}
