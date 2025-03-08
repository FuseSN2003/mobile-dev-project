import 'package:classroom_app/blocs/assignment/assignment_bloc.dart';
import 'package:classroom_app/blocs/auth/auth_bloc.dart';
import 'package:classroom_app/blocs/classroom_detail/classroom_detail_bloc.dart';
import 'package:classroom_app/component/assignment_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../component/bottombar.dart';
import '../component/button.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';

class ClassroomWorkPage extends StatefulWidget {
  const ClassroomWorkPage({super.key});

  @override
  State<ClassroomWorkPage> createState() => _ClassroomWorkPageState();
}

class _ClassroomWorkPageState extends State<ClassroomWorkPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final assignmentBloc = BlocProvider.of<AssignmentBloc>(context);

      final classroomId = ModalRoute.of(context)!.settings.arguments as String;

      if (classroomId.isNotEmpty) {
        assignmentBloc.add(FetchAssignment(classroomId: classroomId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(backButton: false),
      body: BlocBuilder<ClassroomDetailBloc, ClassroomDetailState>(
        builder: (context, state) {
          if (state is ClassroomDetailLoaded) {
            final classroomName = state.classroom.name;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Classroom : ${state.classroom.name}",
                      style: TextStyle(color: Colors.white),
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        if (authState is Authenticated) {
                          final teacher = state.teachers.where(
                            (e) => e.id == authState.user.id,
                          );
                          if (teacher.isNotEmpty) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                text: "เพิ่มงานใหม่",
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/addassignment",
                                  );
                                },
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    BlocBuilder<AssignmentBloc, AssignmentState>(
                      builder: (context, state) {
                        if (state is AssignmentLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is AssignmentLoaded) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: ListView.builder(
                              itemCount: state.assignments.length,
                              itemBuilder: (context, index) {
                                final assignment = state.assignments[index];
                                if (assignment.dueDate == null) {
                                  return AssignmentBox(
                                    classRoomName:
                                        '$classroomName ${assignment.isSubmitted == true ? '✅' : ''}',
                                    taskName: assignment.title,
                                    score:
                                        assignment.isSubmitted == true &&
                                                assignment.scoreReceived != null
                                            ? '${assignment.scoreReceived}/${assignment.maxScore}'
                                            : null,
                                    onPress: () {
                                      Navigator.pushNamed(
                                        context,
                                        "/assignment",
                                        arguments: assignment.id,
                                      );
                                    },
                                  );
                                }

                                DateTime dateTime = DateTime.parse(
                                  assignment.dueDate!,
                                );

                                return AssignmentBox(
                                  classRoomName:
                                      '$classroomName ${assignment.isSubmitted == true ? '✅' : ''}',
                                  taskName: assignment.title,
                                  time: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(dateTime),
                                  score:
                                      assignment.isSubmitted == true &&
                                              assignment.scoreReceived != null
                                          ? '${assignment.scoreReceived}/${assignment.maxScore}'
                                          : '${assignment.maxScore}',
                                  onPress: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/assignment",
                                      arguments: assignment.id,
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: Bottombar(),
    );
  }
}
