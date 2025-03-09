import 'package:classroom_app/blocs/classroom_detail/classroom_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../component/assignment_box.dart';
import '../component/bottombar.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';

class ClassroomForumPage extends StatefulWidget {
  const ClassroomForumPage({super.key});

  @override
  State<ClassroomForumPage> createState() => _ClassroomFormPageState();
}

class _ClassroomFormPageState extends State<ClassroomForumPage> {
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
}
