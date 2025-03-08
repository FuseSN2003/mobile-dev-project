import 'package:classroom_app/blocs/assignment_detail/assignment_detail_bloc.dart';
import 'package:classroom_app/blocs/auth/auth_bloc.dart';
import 'package:classroom_app/blocs/classroom_detail/classroom_detail_bloc.dart';
import 'package:classroom_app/component/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../component/student_box.dart';
import '../component/sidebar.dart';
import '../component/navbar.dart';
import '../component/button.dart';

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

  final List<String> studentNames = [
    "Rati Maneengam",
    "John Doe",
    "Jane Smith",
    "Bob White",
  ];
  String assignmentName = "งาน “การทดสอบ User 2 ราย “";
  String assignDesc =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text";
  int score = 10;
  String dueDateString = "26/2/2568 00:00";
  List<String> imageUrls = [
    "http://10.0.2.2:3000/file/7222df8c-f951-4e03-85ba-62cedbd074a0.png",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdE6iZ0yrsi0mwiy3UUNuTLlRwVD6seXm0nQ&s",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(backButton: true),
      drawer: Sidebar(),
      body: BlocBuilder<ClassroomDetailBloc, ClassroomDetailState>(
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                  Text(assignmentDetailState.assignment.title),
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
                                        "ส่งวันที่ ${assignmentDetailState.assignment.submittedAt}",
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
                              ? StudentBox(
                                label:
                                    "นักเรียนที่ส่งงาน ${assignmentDetailState.assignment.submittedStudents!.length} / ${assignmentDetailState.assignment.assigned} คน",
                                itemList:
                                    assignmentDetailState
                                        .assignment
                                        .submittedStudents!,
                                onPress:
                                    () => Navigator.pushNamed(
                                      context,
                                      "/assignment_student",
                                    ),
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
    );
  }
}

// class Assignment extends StatelessWidget {
//   Assignment({
//     super.key,
//     // required this.assignmentName,
//     // required this.assignDesc,
//     // required this.score,
//   });
//   final List<String> studentNames = [
//     "Rati Maneengam",
//     "John Doe",
//     "Jane Smith",
//     "Bob White",
//   ];
//   String assignmentName = "งาน “การทดสอบ User 2 ราย “";
//   String assignDesc =
//       "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text";
//   int score = 10;
//   String dueDateString = "26/2/2568 00:00";
//   List<String> imageUrls = [
//     "http://10.0.2.2:3000/file/7222df8c-f951-4e03-85ba-62cedbd074a0.png",
//     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdE6iZ0yrsi0mwiy3UUNuTLlRwVD6seXm0nQ&s",
//   ];
//   // DateTime dueDate = parseThaiDate(dueDateString);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: NavBar(backButton: true),
//       drawer: Sidebar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: DefaultTextStyle(
//             style: TextStyle(color: Colors.white, fontSize: 14),
//             child: Column(
//               children: [
//                 Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(assignmentName),
//                           Text("${score} คะแนน"),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("ส่งวันที่ ${dueDateString}"),
//                           CustomButton(
//                             text: "แก้ไขงาน",
//                             onPressed: () {
//                               Navigator.pushNamed(context, "/addassignment");
//                             },
//                             colors: Colors.white,
//                             backGroundColors:
//                                 Theme.of(context).colorScheme.primary,
//                             paddingWidth: 8,
//                             paddingHeight: 10,
//                           ),
//                         ],
//                       ),
//                       Text("รายละเอียดงาน"),
//                       Text("${assignDesc}"),
//                       SizedBox(height: 20),
//                       Container(
//                         height: 150,
//                         child: GridView.builder(
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2, // 2 images per row
//                                 crossAxisSpacing: 8, // Space between columns
//                                 mainAxisSpacing: 8, // Space between rows
//                                 childAspectRatio:
//                                     1, // Adjust to control image size
//                               ),
//                           itemCount: imageUrls.length,
//                           itemBuilder: (context, index) {
//                             return ClipRRect(
//                               child: Container(
//                                 child: Image.network(
//                                   // width: 150,
//                                   // height: 100,
//                                   imageUrls[index],
//                                   fit:
//                                       BoxFit.cover, // Ensures image fits nicely
//                                   loadingBuilder: (
//                                     context,
//                                     child,
//                                     loadingProgress,
//                                   ) {
//                                     if (loadingProgress == null) return child;
//                                     return Center(
//                                       child: CircularProgressIndicator(),
//                                     );
//                                   },
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Center(
//                                       child: Icon(
//                                         Icons.error,
//                                         color: Colors.red,
//                                         size: 50,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 StudentBox(
//                   label: "นักเรียน",
//                   itemList: studentNames,
//                   onPress:
//                       () => Navigator.pushNamed(context, "/assignment_student"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
