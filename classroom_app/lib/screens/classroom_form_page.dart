import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../component/bottombar.dart';
import '../component/navbar.dart';
import '../component/bottombar.dart';
import 'package:intl/intl.dart';
import '../component/sidebar.dart';
import '../model/post.dart';
import '../model/work.dart';

class ClassroomFormPage extends StatefulWidget {
  const ClassroomFormPage({super.key});

  @override
  State<ClassroomFormPage> createState() => _ClassroomFormPageState();
}

class _ClassroomFormPageState extends State<ClassroomFormPage> {
  List<Work> works = [
    Work(
      title: "Project Meeting",
      description: "Discuss project milestones",
      created_at: DateTime(2024, 2, 20),
      due_date: DateTime(2024, 2, 18),
      score: 10,
    ),
    Work(
      title: "Code Review",
      description: "Review team PRs",
      created_at: DateTime(2024, 2, 18),
      due_date: DateTime(2024, 2, 18),
      score: 20,
    ),
    Work(
      title: "Testing Phase",
      description: "Run app tests",
      created_at: DateTime(2024, 2, 22),
      due_date: DateTime(2024, 2, 22),
      score: 20,
    ),
  ];

  List<Post> posts = [
    Post(
      postName: "Exploring Mountains",
      postDes: "Hiking adventure!",
      username: "JohnDoe",
      created_at: DateTime(2024, 2, 21),
    ),
    Post(
      postName: "Pizza Recipe",
      postDes: "Best homemade pizza!",
      username: "FoodieQueen",
      created_at: DateTime(2024, 2, 17),
    ),
    Post(
      postName: "Sunset Beach",
      postDes: "Beautiful ocean view",
      username: "TravelerGuy",
      created_at: DateTime(2024, 2, 23),
    ),
    Post(
      postName: "Sunset Beach",
      postDes: "Beautiful ocean view",
      username: "TravelerGuy",
      created_at: DateTime(2024, 2, 23),
    ),
    Post(
      postName: "Sunset Beach",
      postDes: "Beautiful ocean view",
      username: "TravelerGuy",
      created_at: DateTime(2024, 2, 23),
    ),
    Post(
      postName: "Sunset Beach",
      postDes: "Beautiful ocean view",
      username: "TravelerGuy",
      created_at: DateTime(2024, 2, 23),
    ),
    Post(
      postName: "Sunset Beach",
      postDes: "Beautiful ocean view",
      username: "TravelerGuy",
      created_at: DateTime(2024, 2, 23),
    ),
    Post(
      postName: "Sunset Beach",
      postDes: "Beautiful ocean view",
      username: "TravelerGuy",
      created_at: DateTime(2024, 2, 23),
    ),
  ];
  List<dynamic> mergedData = []; // Merge lists
  // Sort by date
  @override
  void initState() {
    super.initState();

    // Initialize mergedData inside initState
    mergedData = [...works, ...posts];
    mergedData.sort(
      (a, b) => a.created_at.compareTo(b.created_at),
    ); // Sort by date
  }

  final String className = "ชื่อ : Class room";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(backButton: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$className", style: TextStyle(color: Colors.white)),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                // height: 500,
                child: ListView.builder(
                  itemCount: mergedData.length,
                  itemBuilder: (context, index) {
                    var item = mergedData[index];
                    if (item is Work) {
                      return _buildWork(context, item);
                    } else if (item is Post) {
                      return _buildPost(context, item);
                    }
                    return SizedBox.shrink(); // Fallback
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bottombar(),
    );
  }

  Widget _buildPost(BuildContext context, Post post) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2, color: Colors.white),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Icon(
                    Icons.account_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 10),
                  Text(post.username, style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.postName,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  post.postDes,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat('hh:mm a MM/dd/yy').format(post.created_at),
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWork(BuildContext context, Work work) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary, // Background color
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              work.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(work.description, style: TextStyle(color: Colors.white)),
            Text(
              "Due: ${work.due_date.toLocal()}",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
