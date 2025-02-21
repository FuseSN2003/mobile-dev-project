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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
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
                  Text(
                    "ไม่มีวันครบกำหนด",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildTask(
                    "DESIGN THINKING",
                    "(F) ส่งรายงาน Team Workshop (4 พ.ย. 2567)",
                    "4/11/2567 00:00 A.m ",
                    100,
                  ),
                ],
              ),
              Column(
                children: [
                  Text("ไม่มีวันครบกำหนด"),
                  _buildTask(
                    "DESIGN THINKINGdadadadadijooooooooooo",
                    "(F) ส่งรายงาน Team Workshop (4 พ.ย. 2567)",
                    "4/11/2567 00:00 A.m ",
                    100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTask(
    String classRoomName,
    String taskName,
    String time,
    int score,
  ) {
    return Container(
      width: double.infinity, // Makes it take full width
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // ✅ Ensures Row content doesn't overflow
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      // ✅ Expands classRoomName properly
                      child: Text(
                        classRoomName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            taskName,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis, // Show "..." if it overflows
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '$score คะแนน',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
