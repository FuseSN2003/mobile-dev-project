import 'package:classroom_app/blocs/classroom_detail/classroom_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../component/bottombar.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';
import '../model/post.dart';
import '../model/work.dart';

class ClassroomForumPage extends StatefulWidget {
  const ClassroomForumPage({super.key});

  @override
  State<ClassroomForumPage> createState() => _ClassroomFormPageState();
}

class _ClassroomFormPageState extends State<ClassroomForumPage> {
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
  ];
  List<dynamic> mergedData = []; // Merge lists
  TextEditingController postNamed = TextEditingController();
  TextEditingController postDesc = TextEditingController();
// Zfc3J5
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)!.settings.arguments.toString().isNotEmpty) {
        BlocProvider.of<ClassroomDetailBloc>(context).add(
          FetchClassroomDetail(
            classroomId: ModalRoute.of(context)!.settings.arguments as String,
          ),
        );
      }
    });

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
      body: BlocBuilder<ClassroomDetailBloc, ClassroomDetailState>(
        builder: (context, state) {
          if (state is ClassroomDetailLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ชื่อ : ${state.classroom.name}",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    _buildTextFiledPost(context),
                    SizedBox(height: 20),
                    SizedBox(
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
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: Bottombar(),
    );
  }

  Widget _buildTextFiledPost(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary, // Dark background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile & Post Info
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, right: 10),
                  width: 20,
                  child: Icon(
                    size: 28,
                    Icons.account_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  // Allows the Column to take up the available space
                  child: Container(
                    // height: 200,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align items to the left
                      children: [
                        Text(
                          "ชื่อโพสต์",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "ชื่อโพสต์",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            contentPadding: EdgeInsets.all(3),
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.onSecondary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "รายละเอียดโพสต์",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(height: 10),
                TextField(
                  maxLines: 4,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "โพสต์ ....",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onSecondary,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),

            // Post Button
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Post button color
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Text("โพสต์"),
                ),
              ),
            ),
          ],
        ),
      ),
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
