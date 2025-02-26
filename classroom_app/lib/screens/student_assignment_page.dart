import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';
import '../component/button.dart';

class AssignmentStudent extends StatelessWidget {
  AssignmentStudent({super.key});
  final String user = "teacher";
  final String studentNamed = "ferm";
  final List<String> studentNames = [
    "Rati Maneengam",
    "John Doe",
    "Jane Smith",
    "Bob White",
  ];
  String assignmentName = "งาน “การทดสอบ User 2 ราย “";
  int maxScore = 10;
  TextEditingController scoreController = TextEditingController();
  String dueDateString = "26/2/2568 00:00";
  List<String> imageUrls = [
    "https://img.salehere.co.th/p/1200x0/2021/06/18/8mx3mv3gk1mp.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdE6iZ0yrsi0mwiy3UUNuTLlRwVD6seXm0nQ&s",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(backButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(assignmentName),
                    Text(
                      "ชื่อนักเรียน :${studentNamed}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("กำหนด : ${dueDateString}"),
                    Text("ส่ง : ${dueDateString}"),
                  ],
                ),
                SizedBox(height: 20),
                Text("งานนักเรียน"),
                SizedBox(height: 20),
                Container(
                  height: 150,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 images per row
                      crossAxisSpacing: 8, // Space between columns
                      mainAxisSpacing: 8, // Space between rows
                      childAspectRatio: 1, // Adjust to control image size
                    ),
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        child: Container(
                          child: Image.network(
                            // width: 150,
                            // height: 100,
                            imageUrls[index],
                            fit: BoxFit.cover, // Ensures image fits nicely
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        keyboardType:
                            TextInputType.number, // Set keyboard to number
                        controller: scoreController,
                        decoration: InputDecoration(
                          labelText: 'Enter score : ',
                          hintText: '/${maxScore}',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Text("${maxScore} คะแนน"),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: CustomButton(
                    text: "ยืนยัน",
                    onPressed:
                        () => Navigator.pushNamed(context, "/assignment_page"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
