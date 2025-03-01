import 'package:classroom_app/blocs/classroom_detail/classroom_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: BlocBuilder<ClassroomDetailBloc, ClassroomDetailState>(
        builder: (context, state) {
          if (state is ClassroomDetailLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ชื่อ : ${state.classroom.name}",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          state.classroom.code!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    StudentBox(
                      label: "อาจารย์",
                      itemList: state.students.map((e) => e.username).toList(),
                    ),
                    StudentBox(
                      label: "นักเรียน",
                      itemList: state.students.map((e) => e.username).toList(),
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
