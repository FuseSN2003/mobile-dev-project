import 'package:flutter/material.dart';

import '../component/student_box.dart';
import '../component/sidebar.dart';
import '../component/navbar.dart';
import '../component/button.dart';

class Assignment extends StatelessWidget {
  Assignment({
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
  String dueDateString = "26/2/2568 00:00";
  List<String> imageUrls = [
    "http://10.0.2.2:3000/file/7222df8c-f951-4e03-85ba-62cedbd074a0.png",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdE6iZ0yrsi0mwiy3UUNuTLlRwVD6seXm0nQ&s",
  ];
  // DateTime dueDate = parseThaiDate(dueDateString);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(backButton: true),
      drawer: Sidebar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white, fontSize: 14),
            child: Column(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(assignmentName),
                          Text("${score} คะแนน"),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ส่งวันที่ ${dueDateString}"),
                          CustomButton(
                            text: "แก้ไขงาน",
                            onPressed: () {
                              Navigator.pushNamed(context, "/addassignment");
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
                      Text("${assignDesc}"),
                      SizedBox(height: 20),
                      Container(
                        height: 150,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 images per row
                                crossAxisSpacing: 8, // Space between columns
                                mainAxisSpacing: 8, // Space between rows
                                childAspectRatio:
                                    1, // Adjust to control image size
                              ),
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              child: Container(
                                child: Image.network(
                                  // width: 150,
                                  // height: 100,
                                  imageUrls[index],
                                  fit:
                                      BoxFit.cover, // Ensures image fits nicely
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
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
                      // Image.network(
                      //   "https://www.ieethailand.com/wp-content/uploads/2024/06/swt-2025.jpg",
                      // ),
                      // ListView.builder(
                      //   itemCount: imageUrls.length,
                      //   itemBuilder: (context, index) {
                      //     return Padding(
                      //       padding: const EdgeInsets.all(0),
                      //       child: ClipRRect(
                      //         borderRadius: BorderRadius.circular(
                      //           10,
                      //         ), // Rounded corners
                      //         child: Image.network(
                      //           imageUrls[index],
                      //           fit: BoxFit.cover,
                      //           loadingBuilder: (
                      //             context,
                      //             child,
                      //             loadingProgress,
                      //           ) {
                      //             if (loadingProgress == null) return child;
                      //             return Center(
                      //               child: CircularProgressIndicator(),
                      //             );
                      //           },
                      //           errorBuilder: (context, error, stackTrace) {
                      //             return Center(
                      //               child: Icon(
                      //                 Icons.error,
                      //                 color: Colors.red,
                      //                 size: 50,
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
                Container(
                  child: StudentBox(
                    label: "นักเรียน",
                    itemList: studentNames,
                    onPress:
                        () =>
                            Navigator.pushNamed(context, "/assignment_student"),
                  ),
                ),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
