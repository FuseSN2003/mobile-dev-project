import 'package:classroom_app/component/sidebar.dart';
import 'package:flutter/material.dart';
import '../component/navbar.dart';

class AddAssignmentPage extends StatefulWidget {
  const AddAssignmentPage({super.key});

  @override
  State<AddAssignmentPage> createState() => _AddAssignmentPageState();
}

class _AddAssignmentPageState extends State<AddAssignmentPage> {
  final String className = "ชื่อ : Class room";
  final TextEditingController workName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(backButton: true),
      drawer: Sidebar(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$className", style: TextStyle(color: Colors.white)),
            Row(
              children: [
                Text("ชื่องาน :", style: TextStyle(color: Colors.white)),
                TextField(controller: workName),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
