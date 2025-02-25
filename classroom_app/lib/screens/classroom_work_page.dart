import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../component/bottombar.dart';
import '../component/navbar.dart';
import '../component/assignment_box.dart';
import '../component/button.dart';
import '../component/sidebar.dart';

class ClassroomWorkPage extends StatefulWidget {
  const ClassroomWorkPage({super.key});

  @override
  State<ClassroomWorkPage> createState() => _ClassroomWorkPageState();
}

class _ClassroomWorkPageState extends State<ClassroomWorkPage> {
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
              Text("$className", style: TextStyle(color: Colors.white)),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  text: "เพิ่มงานใหม่",
                  onPressed: () {
                    Navigator.pushNamed(context, "/classroom_addassignment");
                  },
                ),
              ),
              AssignTask(
                classRoomName: "DESIGN THINKINGdadadadadijooooooooooo",
                taskName: "(F) ส่งรายงาน Team Workshop (4 พ.ย. 2567)",
                time: "5/11/2567 00:00 A.m",
                score: 100,
              ),
              AssignTask(
                classRoomName: "DESIGN THINKINGdadadadadijooooooooooo",
                taskName: "(F) ส่งรายงาน Team Workshop (4 พ.ย. 2567)",
                time: "5/11/2567 00:00 A.m",
                score: 100,
                onPress:
                    () => Navigator.pushNamed(context, "/classroom_assignment"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bottombar(),
    );
  }
}
