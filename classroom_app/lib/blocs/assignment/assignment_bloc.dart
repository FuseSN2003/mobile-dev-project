import 'dart:io';

import 'package:classroom_app/utills/jwt_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

part 'assignment_event.dart';
part 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  AssignmentBloc() : super(AssignmentInitial()) {
    on<AddAssignment>(_onAddAssignment);
  }

  _onAddAssignment(AddAssignment event, Emitter<AssignmentState> emit) async {
    final classroomId = event.classroomId;

    try {
      final token = await getToken();

      final req = http.MultipartRequest(
        "POST",
        Uri.parse("http://10.0.2.2:3000/classroom/$classroomId/assignment"),
      );
      req.headers['Authorization'] = 'Bearer $token';
      req.fields.addAll({
        'title': event.title,
        'description': event.description,
        'dueDate': event.dueDate,
      });
      for (var file in event.files) {
        String mimeType =
            lookupMimeType(file.path) ?? 'application/octet-stream';

        req.files.add(
          await http.MultipartFile.fromPath(
            'files',
            file.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final res = await req.send();

      if (res.statusCode == 200) {
        emit(AddAssignmentSuccess());
      }
    } catch (e) {
      debugPrint("Error on Add Assignment ${e.toString()}");
    }
  }
}
