import 'package:classroom_app/blocs/auth/auth_bloc.dart';
import 'package:classroom_app/blocs/classroom_detail/classroom_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/assignment_box.dart';
import '../component/bottombar.dart';
import '../component/button.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';

class ClassroomWorkPage extends StatefulWidget {
  const ClassroomWorkPage({super.key});

  @override
  State<ClassroomWorkPage> createState() => _ClassroomWorkPageState();
}

class _ClassroomWorkPageState extends State<ClassroomWorkPage> {
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
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ชื่อ ${state.classroom.name}",
                      style: TextStyle(color: Colors.white),
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        if (authState is Authenticated) {
                          final teacher = state.teachers.where(
                            (e) => e.id == authState.user.id,
                          );
                          if (teacher.isNotEmpty) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                text: "เพิ่มงานใหม่",
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/addassignment",
                                  );
                                },
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        } else {
                          return SizedBox();
                        }
                      },
                    ),

                    assignTask(
                      classRoomName: "DESIGN THINKINGdadadadadijooooooooooo",
                      taskName: "(F) ส่งรายงาน Team Workshop (4 พ.ย. 2567)",
                      time: "5/11/2567 00:00 A.m",
                      score: 100,
                    ),
                    assignTask(
                      classRoomName: "DESIGN THINKINGdadadadadijooooooooooo",
                      taskName: "(F) ส่งรายงาน Team Workshop (4 พ.ย. 2567)",
                      time: "5/11/2567 00:00 A.m",
                      score: 100,
                      onPress:
                          () => Navigator.pushNamed(context, "/assignment"),
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
}
