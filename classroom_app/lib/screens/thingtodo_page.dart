import 'package:classroom_app/blocs/assignment_list/assignment_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';
import '../component/assignment_box.dart';

class ThingtodoPage extends StatefulWidget {
  const ThingtodoPage({super.key});

  @override
  State<ThingtodoPage> createState() => _ThingtodoPageState();
}

enum AssignmentStatus { assigned, overdue, submitted }

class _ThingtodoPageState extends State<ThingtodoPage> {
  @override
  initState() {
    context.read<AssignmentListBloc>().add(FetchAssignmentList());
    super.initState();
  }

  String selectedTap = "มอบหมายแล้ว";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(backButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTapButton("มอบหมายแล้ว"),
                  _buildTapButton("เลยกำหนด"),
                  _buildTapButton("เสร็จสิ้น"),
                ],
              ),
              BlocBuilder<AssignmentListBloc, AssignmentListState>(
                builder: (context, state) {
                  if (state is AssignmentListLoaded) {
                    if (selectedTap == "มอบหมายแล้ว") {
                      return Column(
                        children:
                            state.assignedAssignments
                                .map(
                                  (e) => AssignmentBox(
                                    classRoomName: e.classroomName,
                                    taskName: e.title,
                                    time:
                                        e.dueDate == null
                                            ? "ไม่มีกำหนด"
                                            : DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(e.dueDate!),
                                            ),
                                    score: e.maxScore.toString(),
                                    onPress: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/assignment',
                                        arguments: e.id,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      );
                    } else if (selectedTap == "เลยกำหนด") {
                      return Column(
                        children:
                            state.overdueAssignments
                                .map(
                                  (e) => AssignmentBox(
                                    classRoomName: e.classroomName,
                                    taskName: e.title,
                                    time:
                                        e.dueDate == null
                                            ? "ไม่มีกำหนด"
                                            : DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(e.dueDate!),
                                            ),
                                    score: e.maxScore.toString(),
                                    onPress: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/assignment',
                                        arguments: e.id,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      );
                    } else {
                      return Column(
                        children:
                            state.submittedAssignments
                                .map(
                                  (e) => AssignmentBox(
                                    classRoomName: e.classroomName,
                                    taskName: e.title,
                                    time:
                                        e.dueDate == null
                                            ? "ไม่มีกำหนด"
                                            : DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(e.dueDate!),
                                            ),
                                    score: e.maxScore.toString(),
                                    onPress: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/assignment',
                                        arguments: e.id,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTapButton(String title) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedTap = title;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontFamily: "Inder",
          fontWeight: selectedTap == title ? FontWeight.bold : FontWeight.w100,
        ),
      ),
    );
  }
}
