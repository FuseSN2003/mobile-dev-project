import 'package:flutter/material.dart';
import '../component/bottombar.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';
import '../component/student_box.dart';

class ClassroomPersonPage extends StatefulWidget {
  const ClassroomPersonPage({super.key});

  @override
  State<ClassroomPersonPage> createState() => _ClassroomPersonPageState();
}

class _ClassroomPersonPageState extends State<ClassroomPersonPage> {
  // Define the student list
  final List<String> studentNames = [
    "Rati Maneengam",
    "John Doe",
    "Jane Smith",
    "Bob White",
  ];
  final List<String> teacherNames = ["Alice Brown"];
  final String className = "ชื่อ : Class room";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(backButton: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("$className", style: TextStyle(color: Colors.white)),
                  Text("รหัสคลาสรูม", style: TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                child: StudentBox(label: "อาจารย์", itemList: teacherNames),
              ),

              Container(
                child: StudentBox(label: "นักเรียน", itemList: studentNames),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bottombar(),
    );
  }
}
