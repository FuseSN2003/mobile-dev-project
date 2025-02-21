import 'package:flutter/material.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';

class AssignmentPage extends StatefulWidget {
  AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  String selectedTap = "มอบหมายแล้ว";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(backButton: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTap = "มอบหมายแล้ว";
                    });
                  },
                  child: Text(
                    "มอบหมายแล้ว",
                    style: TextStyle(
                      fontFamily: "Inder",
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight:
                          selectedTap == "มอบหมายแล้ว"
                              ? FontWeight.bold
                              : FontWeight.w100,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTap = "เลยกำหนด";
                    });
                  },
                  child: Text(
                    "เลยกำหนด",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: "Inder",
                      fontWeight:
                          selectedTap == "เลยกำหนด"
                              ? FontWeight.bold
                              : FontWeight.w100,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTap = "เสร็จสิ้น";
                    });
                  },
                  child: Text(
                    "เสร็จสิ้น",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: "Inder",
                      fontWeight:
                          selectedTap == "เสร็จสิ้น"
                              ? FontWeight.bold
                              : FontWeight.w100,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
