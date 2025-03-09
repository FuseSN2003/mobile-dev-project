import 'dart:io';

import 'package:classroom_app/blocs/assignment/assignment_bloc.dart';
import 'package:classroom_app/blocs/assignment_detail/assignment_detail_bloc.dart';
import 'package:classroom_app/blocs/auth/auth_bloc.dart';
import 'package:classroom_app/blocs/classroom_detail/classroom_detail_bloc.dart';
import 'package:classroom_app/component/pdf_view.dart';
import 'package:classroom_app/screens/student_assignment_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../component/button.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';
import '../component/student_box.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final assignmentDetailBloc = BlocProvider.of<AssignmentDetailBloc>(
        context,
      );

      final classroomDetailBloc = BlocProvider.of<ClassroomDetailBloc>(context);
      final classroomDetailState = classroomDetailBloc.state;
      final assignmentId = ModalRoute.of(context)!.settings.arguments as String;

      if (classroomDetailState is ClassroomDetailLoaded) {
        final classroomId = classroomDetailState.classroom.id;
        if (classroomId.isNotEmpty && assignmentId.isNotEmpty) {
          assignmentDetailBloc.add(
            FetchAssignmentDetail(
              classroomId: classroomId,
              assignmentId: assignmentId,
            ),
          );
        }
      }
    });
    super.initState();
  }

  List<File> _selectedFiles = [];
  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Allow multiple file selection
    );
    if (result != null) {
      setState(() {
        _selectedFiles = result.files.map((file) => File(file.path!)).toList();
      });
    } else {
      debugPrint("No files selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(backButton: true),
      drawer: Sidebar(),
      body: BlocListener<AssignmentBloc, AssignmentState>(
        listener: (context, state) {
          if (state is SubmitAssignmentSuccess ||
              state is CancelAssignmentSuccess) {
            final classroomDetailBloc = context.read<ClassroomDetailBloc>();
            final classroomDetailState = classroomDetailBloc.state;

            if (classroomDetailState is ClassroomDetailLoaded) {
              final classroomId = classroomDetailState.classroom.id;
              final assignmentId =
                  ModalRoute.of(context)!.settings.arguments as String;

              context.read<AssignmentDetailBloc>().add(
                FetchAssignmentDetail(
                  classroomId: classroomId,
                  assignmentId: assignmentId,
                ),
              );

              context.read<ClassroomDetailBloc>().add(
                FetchClassroomDetail(classroomId: classroomId),
              );
            }
          }
        },
        child: BlocBuilder<ClassroomDetailBloc, ClassroomDetailState>(
          builder: (context, classroomDetailState) {
            final authBloc = context.read<AuthBloc>();

            bool isTeacher = false;

            if (authBloc.state is Authenticated &&
                classroomDetailState is ClassroomDetailLoaded) {
              final teacher = classroomDetailState.teachers.where(
                (e) => e.id == (authBloc.state as Authenticated).user.id,
              );

              if (teacher.isNotEmpty) {
                isTeacher = true;
              }
            }
            return BlocBuilder<AssignmentDetailBloc, AssignmentDetailState>(
              builder: (context, assignmentDetailState) {
                if (assignmentDetailState is AssignmentDetailLoaded) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      assignmentDetailState.assignment.title,
                                    ),
                                    isTeacher
                                        ? Text(
                                          assignmentDetailState
                                                      .assignment
                                                      .dueDate !=
                                                  null
                                              ? "ส่งก่อน ${assignmentDetailState.assignment.dueDate}"
                                              : "ไม่มีกำหนด",
                                        )
                                        : Text(
                                          assignmentDetailState
                                                      .assignment
                                                      .isSubmitted ==
                                                  true
                                              ? 'ส่งแล้ว'
                                              : 'ยังไม่ส่ง',
                                          style: TextStyle(
                                            color:
                                                assignmentDetailState
                                                            .assignment
                                                            .isSubmitted ==
                                                        true
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    !isTeacher &&
                                            assignmentDetailState
                                                    .assignment
                                                    .submittedAt !=
                                                null
                                        ? Text(
                                          "ส่งวันที่ ${DateTime.parse(assignmentDetailState.assignment.submittedAt!).toLocal()}",
                                        )
                                        : SizedBox(),
                                    CustomButton(
                                      text: "แก้ไขงาน",
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          "/addassignment",
                                        );
                                      },
                                      colors: Colors.white,
                                      backGroundColors:
                                          Theme.of(context).colorScheme.primary,
                                      paddingWidth: 8,
                                      paddingHeight: 10,
                                    ),
                                  ],
                                ),
                                Text("รายละเอียดงาน"),
                                Text(
                                  assignmentDetailState.assignment.description,
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: 150,
                                  child:
                                      assignmentDetailState
                                                  .assignment
                                                  .attachments !=
                                              null
                                          ? GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      2, // 2 images per row
                                                  crossAxisSpacing:
                                                      8, // Space between columns
                                                  mainAxisSpacing:
                                                      8, // Space between rows
                                                  childAspectRatio:
                                                      1, // Adjust to control image size
                                                ),
                                            itemCount:
                                                assignmentDetailState
                                                    .assignment
                                                    .attachments!
                                                    .length,
                                            itemBuilder: (context, index) {
                                              final attachment =
                                                  assignmentDetailState
                                                      .assignment
                                                      .attachments![index];

                                              if (attachment.fileType.split(
                                                    "/",
                                                  )[0] ==
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
                                                      if (loadingProgress ==
                                                          null) {
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
                                                                  attachment
                                                                      .fileName,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    attachment.fileName,
                                                  ),
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            },
                                          )
                                          : SizedBox(),
                                ),
                              ],
                            ),
                            isTeacher == true &&
                                    assignmentDetailState
                                            .assignment
                                            .submittedStudents !=
                                        null
                                ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "นักเรียนที่ส่งงาน",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2, // 2 columns
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 20,
                                              childAspectRatio:
                                                  3.5, // Adjust for UI balance
                                            ),
                                        itemCount:
                                            assignmentDetailState
                                                .assignment
                                                .submittedStudents!
                                                .length,
                                        itemBuilder: (context, index) {
                                          return StudentCard(
                                            name:
                                                assignmentDetailState
                                                    .assignment
                                                    .submittedStudents![index],
                                            onPress: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/assignment_student',
                                                arguments: AssignmentStudentArgs(
                                                  studentName:
                                                      assignmentDetailState
                                                          .assignment
                                                          .submittedStudents![index],
                                                  assignmentId:
                                                      assignmentDetailState
                                                          .assignment
                                                          .id,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                                : SizedBox(),
                            !isTeacher &&
                                    assignmentDetailState
                                            .assignment
                                            .isSubmitted !=
                                        true
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 50),
                                    _selectedFiles.isNotEmpty
                                        ? SizedBox(
                                          height:
                                              150, // Set a fixed height for the file list
                                          child: ListView.builder(
                                            itemCount: _selectedFiles.length,
                                            itemBuilder: (context, index) {
                                              String filePath =
                                                  _selectedFiles[index].path;
                                              // bool isImage = false;
                                              bool isImage =
                                                  filePath
                                                      .toLowerCase()
                                                      .endsWith('.png') ||
                                                  filePath
                                                      .toLowerCase()
                                                      .endsWith('.jpg') ||
                                                  filePath
                                                      .toLowerCase()
                                                      .endsWith('.jpeg') ||
                                                  filePath
                                                      .toLowerCase()
                                                      .endsWith('.gif');

                                              return isImage
                                                  ? Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Image.file(
                                                      _selectedFiles[index],
                                                      height:
                                                          100, // Set a fixed image height
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                  : ListTile(
                                                    leading: Icon(
                                                      Icons.insert_drive_file,
                                                      color: Colors.white,
                                                    ),
                                                    title: Text(
                                                      filePath.split('/').last,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  );
                                            },
                                          ),
                                        )
                                        : Text(
                                          "เลือกไฟล์ที่ต้องการส่ง",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: pickFiles,
                                      child: Text("Pick a File"),
                                    ),
                                    SizedBox(height: 30),
                                    Align(
                                      alignment: Alignment.center,
                                      child: CustomButton(
                                        text: "ส่งงาน",
                                        colors: Colors.white,
                                        backGroundColors:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        onPressed: () {
                                          final classroomDetailBloc =
                                              context
                                                  .read<ClassroomDetailBloc>();
                                          final classroomDetailState =
                                              classroomDetailBloc.state;

                                          if (classroomDetailState
                                              is ClassroomDetailLoaded) {
                                            final classroomId =
                                                classroomDetailState
                                                    .classroom
                                                    .id;
                                            final assignmentId =
                                                assignmentDetailState
                                                    .assignment
                                                    .id;

                                            context.read<AssignmentBloc>().add(
                                              SubmitAssignment(
                                                classroomId: classroomId,
                                                assignmentId: assignmentId,
                                                files: _selectedFiles,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )
                                : SizedBox(),
                            SizedBox(height: 20),
                            assignmentDetailState.assignment.isSubmitted ==
                                        true &&
                                    assignmentDetailState
                                            .submissionAttachments !=
                                        null
                                ? Column(
                                  children: [
                                    Text("ไฟล์ที่ส่ง"),
                                    SizedBox(
                                      height: 150,
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                              childAspectRatio: 1,
                                            ),
                                        itemCount:
                                            assignmentDetailState
                                                .submissionAttachments!
                                                .length,
                                        itemBuilder: (context, index) {
                                          final attachment =
                                              assignmentDetailState
                                                  .submissionAttachments![index];

                                          if (attachment.fileType.split(
                                                "/",
                                              )[0] ==
                                              "image") {
                                            return ClipRRect(
                                              child: Image.network(
                                                '${dotenv.get("BACKEND_URL")}${attachment.url}',
                                                fit: BoxFit.cover,
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
                                                              attachment
                                                                  .fileName,
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
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        final classroomDetailBloc =
                                            context.read<ClassroomDetailBloc>();
                                        final classroomDetailState =
                                            classroomDetailBloc.state;

                                        if (classroomDetailState
                                            is ClassroomDetailLoaded) {
                                          final classroomId =
                                              classroomDetailState.classroom.id;
                                          final assignmentId =
                                              assignmentDetailState
                                                  .assignment
                                                  .id;

                                          context.read<AssignmentBloc>().add(
                                            CancelAssignment(
                                              classroomId: classroomId,
                                              assignmentId: assignmentId,
                                            ),
                                          );
                                        }
                                      },
                                      child: Text("ยกเลิกการส่ง"),
                                    ),
                                  ],
                                )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        ),
      ),
    );
  }
}
