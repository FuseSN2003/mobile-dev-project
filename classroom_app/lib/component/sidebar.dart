import 'package:classroom_app/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Corrected Sidebar class
class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> teachingClassroom = [
      {"name": "Science", "section": "sec2"},
      {"name": "Math", "section": "sec1"},
      {"name": "English", "section": "sec1"},
      {"name": "English", "section": "sec2"},
      {"name": "English", "section": "sec3"},
    ];
    List<Map<String, String>> joinClassroom = [
      {"name": "Physics", "section": "sec1"},
      {"name": "History", "section": "sec2"},
      {"name": "Biology", "section": "sec3"},
      // {"name": "Biology", "section": "sec3"},
    ];
    return Drawer(
      // width: 300,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2, color: Colors.white54),
                    ),
                  ),
                  height: 130,
                  width: double.infinity,
                  child: DrawerHeader(
                    // decoration: BoxDecoration(color: Colors.grey[300]),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Your Classes",
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: "KaushanScript",
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2, color: Colors.white30),
                    ),
                  ),
                  child: Column(
                    children: [
                      MyListtile(
                        icon: Icons.home,
                        text: "ชั้นเรียน",
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      MyListtile(
                        icon: Icons.work,
                        text: "สิ่งที่ต้องทำ",
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/assignment');
                        },
                      ),
                      MyListtile(
                        icon: Icons.settings,
                        text: "การตั้งค่า",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Container(
                  height: (teachingClassroom.length * 100),
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2, color: Colors.white30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "กำลังสอน",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      // SizedBox(height: 100,),
                      Expanded(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: teachingClassroom.length,
                          itemBuilder: (context, index) {
                            final classroom = teachingClassroom[index];
                            return Expanded(
                              child: MyListtile(
                                icon: Icons.folder,
                                text: "${classroom["name"]}",
                                sec: "${classroom["section"]}",
                                onTap: () {},
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: (joinClassroom.length * 100) + 30,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2, color: Colors.white30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "ลงทะเบียนเรียน",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      // SizedBox(height: 100,),
                      Expanded(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: joinClassroom.length,
                          itemBuilder: (context, index) {
                            final classroom = joinClassroom[index];
                            return Expanded(
                              child: MyListtile(
                                icon: Icons.folder,
                                text: "${classroom["name"]}",
                                sec: "${classroom["section"]}",
                                onTap: () {},
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40, bottom: 20),
                  child: MyListtile(
                    icon: Icons.exit_to_app,
                    text: "Logout",
                    onTap: () {
                      context.read<AuthBloc>().add(LoggedOut());
                    },
                  ),
                ),

                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Corrected ListTile Widget
class MyListtile extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? sec;
  final VoidCallback onTap;

  const MyListtile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.sec,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.white54),
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        margin: EdgeInsets.only(top: 10),
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          // iconColor: Theme.of(context).colorScheme.primary,
          // tileColor: Theme.of(context).colorScheme.onSecondary,
          title: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          subtitle:
              sec != null
                  ? Text(
                    "$sec",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )
                  : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
