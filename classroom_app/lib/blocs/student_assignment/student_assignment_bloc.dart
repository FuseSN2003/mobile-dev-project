import 'dart:convert';

import 'package:classroom_app/models/assignment.dart';
import 'package:classroom_app/utills/jwt_token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

part 'student_assignment_event.dart';
part 'student_assignment_state.dart';

class StudentAssignmentBloc
    extends Bloc<StudentAssignmentEvent, StudentAssignmentState> {
  StudentAssignmentBloc() : super(StudentAssignmentInitial()) {
    on<FetchStudentAssignments>(_onFetchStudentAssignments);
    on<GiveScore>(_onGiveScore);
  }

  _onFetchStudentAssignments(
    FetchStudentAssignments event,
    Emitter<StudentAssignmentState> emit,
  ) async {
    final studentName = event.studentName;
    final assignmentId = event.assignmentId;

    try {
      final token = await getToken();

      final res = await http.get(
        Uri.parse(
          "${dotenv.get("BACKEND_URL")}/assignment/$assignmentId/student/$studentName",
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = studentAssignmentListResponseFromJSON(res.body);

      if (res.statusCode == 200) {
        return emit(
          StudentAssignmentLoaded(
            studentAssignment: jsonData.studentAssignment,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error on Fetch Student Assignment ${e.toString()}");
    }
  }

  _onGiveScore(GiveScore event, Emitter<StudentAssignmentState> emit) async {
    final studentName = event.studentName;
    final assignmentId = event.assignmentId;
    final score = event.score;

    try {
      final token = await getToken();

      final res = await http.patch(
        Uri.parse(
          "${dotenv.get("BACKEND_URL")}/assignment/$assignmentId/student/$studentName",
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'score': score}),
      );

      if (res.statusCode == 200) {
        return add(
          FetchStudentAssignments(
            studentName: studentName,
            assignmentId: assignmentId,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error on Give Score ${e.toString()}");
    }
  }
}
