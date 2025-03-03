import 'dart:io';

import 'package:classroom_app/models/assignment.dart';
import 'package:classroom_app/utills/jwt_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

part 'assignment_event.dart';
part 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  AssignmentBloc() : super(AssignmentInitial()) {
    on<AddAssignment>(_onAddAssignment);
    on<FetchAssignment>(_onFetchAssignment);
  }

  _onFetchAssignment(
    FetchAssignment event,
    Emitter<AssignmentState> emit,
  ) async {
    final classroomId = event.classroomId;

    try {
      final token = await getToken();

      final res = await http.get(
        Uri.parse(
          "${dotenv.get("BACKEND_URL")}/classroom/$classroomId/assignment",
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = assignmentListResponseFromJSON(res.body);

      if (res.statusCode == 200) {
        emit(AssignmentLoaded(assignments: jsonData.assignments));
      }
    } catch (e) {
      debugPrint("Error on Fetch Assignment ${e.toString()}");
    }
  }

  _onAddAssignment(AddAssignment event, Emitter<AssignmentState> emit) async {
    final classroomId = event.classroomId;

    try {
      final token = await getToken();

      final req = http.MultipartRequest(
        "POST",
        Uri.parse(
          "${dotenv.get("BACKEND_URL")}/classroom/$classroomId/assignment",
        ),
      );
      req.headers['Authorization'] = 'Bearer $token';
      req.fields.addAll({
        'title': event.title,
        'description': event.description,
        'dueDate': event.dueDate,
        'maxScore': event.score.toString(),
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
        return add(FetchAssignment(classroomId: classroomId));
      }
    } catch (e) {
      debugPrint("Error on Add Assignment ${e.toString()}");
    }
  }
}
