import 'package:flutter/material.dart';

import '../component/navbar.dart';
import '../component/sidebar.dart';
import '../component/student_box.dart';

class ClassroomAssignment extends StatelessWidget {
  ClassroomAssignment({
    super.key,
    // required this.assignmentName,
    // required this.assignDesc,
    // required this.score,
  });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(backButton: true),
      drawer: Sidebar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            DefaultTextStyle(
              style: TextStyle(color: Colors.white, fontSize: 14),
              child: Column(children: [Text(assignmentName)]),
            ),
            StudentBox(label: "นักเรียน", itemList: studentNames),
          ],
        ),
      ),
    );
  }
}
