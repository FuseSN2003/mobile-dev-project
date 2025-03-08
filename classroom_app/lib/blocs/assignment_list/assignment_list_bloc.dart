import 'dart:convert';

import 'package:classroom_app/models/assignment.dart';
import 'package:classroom_app/utills/jwt_token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

part 'assignment_list_event.dart';
part 'assignment_list_state.dart';

class AssignmentListBloc
    extends Bloc<AssignmentListEvent, AssignmentListState> {
  AssignmentListBloc() : super(AssignmentListInitial()) {
    on<FetchAssignmentList>(_onFetchAssignment);
  }

  _onFetchAssignment(
    FetchAssignmentList event,
    Emitter<AssignmentListState> emit,
  ) async {
    emit(AssignmentListLoading());

    try {
      final token = await getToken();

      final res = await http.get(
        Uri.parse("${dotenv.get("BACKEND_URL")}/assignment/list"),
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = jsonDecode(res.body);

      final assignedAssignments =
          jsonData['assignedAssignments']
              .map<Assignment>((e) => Assignment.fromJson(e))
              .toList();
      final overdueAssignments =
          jsonData['overdueAssignments']
              .map<Assignment>((e) => Assignment.fromJson(e))
              .toList();
      final submittedAssignments =
          jsonData['submittedAssignments']
              .map<Assignment>((e) => Assignment.fromJson(e))
              .toList();

      emit(
        AssignmentListLoaded(
          assignedAssignments: assignedAssignments,
          overdueAssignments: overdueAssignments,
          submittedAssignments: submittedAssignments,
        ),
      );
    } catch (e) {
      debugPrint("Error on Fetch Assignment ${e.toString()}");
    }
  }
}
