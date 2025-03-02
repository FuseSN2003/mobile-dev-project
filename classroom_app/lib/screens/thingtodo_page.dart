import 'package:flutter/material.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';
import '../component/assignment_box.dart';

class ThingtodoPage extends StatefulWidget {
  ThingtodoPage({super.key});

  @override
  State<ThingtodoPage> createState() => _ThingtodoPageState();
}

class _ThingtodoPageState extends State<ThingtodoPage> {
  String selectedTap = "มอบหมายแล้ว";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(backButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTapButton("มอบหมายแล้ว"),
                  _buildTapButton("เลยกำหนด"),
                  _buildTapButton("เสร็จสิ้น"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AssignmentBox(
                    classRoomName: "DESIGN THINKINGdadadadadijooooooooooo",
                    taskName: "(F) ส่งรายงาน Team Workshop (4 พ.ย. 2567)",
                    time: "5/11/2567 00:00 A.m",
                    score: 100,
                  ),
                ],
              ),
              Column(
                children: [
                  // Text("ไม่มีวันครบกำหนด"),
                  AssignmentBox(
                    classRoomName: "DESIGN THINKINGdadadadadijooooooooooo",
                    taskName: "(F) ส่งรายงาน Team Workshop (4 พ.ย. 2567)",
                    time: "5/11/2567 00:00 A.m",
                    score: 100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTapButton(String title) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedTap = title;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontFamily: "Inder",
          fontWeight: selectedTap == title ? FontWeight.bold : FontWeight.w100,
        ),
      ),
    );
  }
}
