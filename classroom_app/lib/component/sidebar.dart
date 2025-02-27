import 'package:classroom_app/blocs/auth/auth_bloc.dart';
import 'package:classroom_app/blocs/classroom/classroom_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
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
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2, color: Colors.white30),
                      top: BorderSide(width: 2, color: Colors.white30),
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
                          Navigator.pushNamed(context, '/thingtodo');
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
                BlocBuilder<ClassroomBloc, ClassroomState>(
                  builder: (context, state) {
                    if (state is ClassroomListLoaded) {
                      final teachingClassrooms = state.teachingClassrooms;
                      final studyingClassrooms = state.studyingClassrooms;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          teachingClassrooms.isNotEmpty
                              ? Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 2,
                                      color: Colors.white30,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Text(
                                        "กำลังสอน",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: teachingClassrooms.length,
                                      itemBuilder: (context, index) {
                                        final classroom =
                                            teachingClassrooms[index];
                                        return MyListtile(
                                          icon: Icons.folder,
                                          text: classroom.name,
                                          sec: classroom.description,
                                          onTap: () {},
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                              : Container(),
                          studyingClassrooms.isNotEmpty
                              ? Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 2,
                                      color: Colors.white30,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Text(
                                        "ลงทะเบียนเรียน",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: studyingClassrooms.length,
                                      itemBuilder: (context, index) {
                                        final classroom =
                                            studyingClassrooms[index];
                                        return MyListtile(
                                          icon: Icons.folder,
                                          text: classroom.name,
                                          sec: classroom.description,
                                          onTap: () {},
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                              : Container(),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: MyListtile(
                    icon: Icons.exit_to_app,
                    text: "Logout",
                    onTap: () {
                      context.read<AuthBloc>().add(LoggedOut());
                    },
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
