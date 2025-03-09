import 'package:classroom_app/models/assignment.dart';
import 'package:classroom_app/models/file.dart';
import 'package:classroom_app/utills/jwt_token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

part 'assignment_detail_event.dart';
part 'assignment_detail_state.dart';

class AssignmentDetailBloc
    extends Bloc<AssignmentDetailEvent, AssignmentDetailState> {
  AssignmentDetailBloc() : super(AssignmentDetailInitial()) {
    on<FetchAssignmentDetail>(_onFetchAssignmentDetail);
  }

  _onFetchAssignmentDetail(
    FetchAssignmentDetail event,
    Emitter<AssignmentDetailState> emit,
  ) async {
    emit(AssignmentDetailLoading());
    final assignmentId = event.assignmentId;
    final classroomId = event.classroomId;
    debugPrint("Assignment ID: $assignmentId");
    debugPrint("Classroom ID: $classroomId");

    try {
      final token = await getToken();

      final res = await http.get(
        Uri.parse(
          "${dotenv.get("BACKEND_URL")}/classroom/$classroomId/assignment/$assignmentId",
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = assignmentDetailResponseFromJSON(res.body);

      if (res.statusCode == 200) {
        emit(
          AssignmentDetailLoaded(
            assignment: jsonData.assignment,
            submissionAttachments: jsonData.submissionAttachments,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error on Fetch Assignment Detail ${e.toString()}");
    }
  }
}
