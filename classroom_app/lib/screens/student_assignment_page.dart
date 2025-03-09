import 'package:classroom_app/blocs/student_assignment/student_assignment_bloc.dart';
import 'package:classroom_app/component/pdf_view.dart';
import 'package:classroom_app/component/textinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../component/navbar.dart';
import '../component/sidebar.dart';

class AssignmentStudentArgs {
  final String studentName;
  final String assignmentId;

  AssignmentStudentArgs({
    required this.studentName,
    required this.assignmentId,
  });
}

class AssignmentStudent extends StatefulWidget {
  const AssignmentStudent({super.key});

  @override
  State<AssignmentStudent> createState() => _AssignmentStudentState();
}

class _AssignmentStudentState extends State<AssignmentStudent> {
  late String studentName = "";
  late String assignmentId = "";

  final _scoreController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as AssignmentStudentArgs;

      context.read<StudentAssignmentBloc>().add(
        FetchStudentAssignments(
          studentName: args.studentName,
          assignmentId: args.assignmentId,
        ),
      );

      setState(() {
        studentName = args.studentName;
        assignmentId = args.assignmentId;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(backButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: BlocBuilder<StudentAssignmentBloc, StudentAssignmentState>(
              builder: (context, state) {
                if (state is StudentAssignmentLoaded) {
                  final assignment = state.studentAssignment;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(assignment.title),
                          Text(
                            "ชื่อนักเรียน: ${assignment.studentName}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child:
                                assignment.dueDate != null
                                    ? Text(
                                      "กำหนดส่ง : ${DateTime.parse(assignment.dueDate!).toLocal()}",
                                    )
                                    : Text("กำหนดส่ง : ไม่มีกำหนด"),
                          ),
                          Expanded(
                            child: Text(
                              "ส่ง : ${DateTime.parse(assignment.submittedAt).toLocal()}",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        assignment.scoreReceived != null
                            ? "คะแนนที่ได้ : ${assignment.scoreReceived} / ${assignment.maxScore}"
                            : "ยังไม่ได้ให้คะแนน",
                      ),
                      SizedBox(height: 20),
                      Text("งานนักเรียน"),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 150,
                        child:
                            assignment.attachments != null
                                ? GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, // 2 images per row
                                        crossAxisSpacing:
                                            8, // Space between columns
                                        mainAxisSpacing:
                                            8, // Space between rows
                                        childAspectRatio:
                                            1, // Adjust to control image size
                                      ),
                                  itemCount: assignment.attachments!.length,
                                  itemBuilder: (context, index) {
                                    final attachment =
                                        assignment.attachments![index];
                                    if (attachment.fileType.split("/")[0] ==
                                        "image") {
                                      return ClipRRect(
                                        child: Image.network(
                                          '${dotenv.get("BACKEND_URL")}${attachment.url}',
                                          fit:
                                              BoxFit
                                                  .cover, // Ensures image fits nicely
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Center(
                                              child: Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: 50,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else if (attachment.fileType ==
                                        "application/pdf") {
                                      return ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => PDFView(
                                                    url:
                                                        '${dotenv.get("BACKEND_URL")}${attachment.url}',
                                                    fileName:
                                                        attachment.fileName,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Text(attachment.fileName),
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                )
                                : SizedBox(),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        label: "คะแนน",
                        controller: _scoreController,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<StudentAssignmentBloc>().add(
                            GiveScore(
                              studentName: studentName,
                              assignmentId: assignmentId,
                              score: int.parse(_scoreController.text),
                            ),
                          );
                        },
                        child: Text("บันทึกคะแนน"),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
