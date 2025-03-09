import 'package:classroom_app/blocs/classroom_detail/classroom_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../component/assignment_box.dart';
import '../component/bottombar.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';
import '../model/work.dart';

class ClassroomForumPage extends StatefulWidget {
  const ClassroomForumPage({super.key});

  @override
  State<ClassroomForumPage> createState() => _ClassroomFormPageState();
}

class _ClassroomFormPageState extends State<ClassroomForumPage> {
  List<Work> works = [
    Work(
      title: "Project Meeting",
      description: "Discuss project milestones",
      createdAt: DateTime(2024, 2, 20),
      dueDate: DateTime(2024, 2, 18),
      score: 10,
    ),
    Work(
      title: "Code Review",
      description: "Review team PRs",
      createdAt: DateTime(2024, 2, 18),
      dueDate: DateTime(2024, 2, 18),
      score: 20,
    ),
  ];
  late String classroomId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)!.settings.arguments.toString().isNotEmpty) {
        final classroomDetailBloc = BlocProvider.of<ClassroomDetailBloc>(
          context,
        );
        final state = classroomDetailBloc.state;

        final classroomId =
            ModalRoute.of(context)!.settings.arguments as String;

        if (classroomId.isNotEmpty) {
          if (state is ClassroomDetailLoaded &&
              state.classroom.id != classroomId) {
            classroomDetailBloc.add(
              FetchClassroomDetail(classroomId: classroomId),
            );
          } else if (state is! ClassroomDetailLoaded) {
            classroomDetailBloc.add(
              FetchClassroomDetail(classroomId: classroomId),
            );
          }
        }
      }
    });
  }

  final String className = "ชื่อ : Class room";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(backButton: false),
      body: SingleChildScrollView(
        child: BlocBuilder<ClassroomDetailBloc, ClassroomDetailState>(
          builder: (context, state) {
            if (state is ClassroomDetailLoaded) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Classroom : ${state.classroom.name}",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      // height: 500,
                      child: ListView.builder(
                        itemCount: state.assignments.length,
                        itemBuilder: (context, index) {
                          var item = state.assignments[index];
                          return AssignmentBox(
                            classRoomName: item.title,
                            taskName: item.description,
                            score: item.maxScore.toString(),
                            time:
                                item.dueDate == null
                                    ? "ไม่มีกำหนด"
                                    : DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(item.dueDate!).toLocal(),
                                    ),
                            onPress: () {
                              Navigator.pushNamed(
                                context,
                                '/assignment',
                                arguments: item.id,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      bottomNavigationBar: Bottombar(),
    );
  }

  Widget _buildWork(BuildContext context, Work work) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary, // Background color
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              work.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(work.description, style: TextStyle(color: Colors.white)),
            Text(
              "Due: ${work.dueDate.toLocal()}",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
