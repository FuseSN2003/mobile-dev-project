import 'package:classroom_app/blocs/classroom_list_bloc/classroom_list_bloc.dart';
import 'package:classroom_app/widgets/appbar.dart';
import 'package:classroom_app/widgets/classroom_card.dart';
import 'package:classroom_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClassroomListBloc>().add(FetchClassroomList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isHomeScreen: true),
      drawer: CustomDrawer(),
      body: DefaultTabController(
        length: 2,
        child: BlocListener<ClassroomListBloc, ClassroomListState>(
          listener: (context, state) {},
          child: SafeArea(
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: "ชั้นเรียนที่เข้าร่วม", icon: Icon(Icons.group)),
                    Tab(text: "ชั้นเรียนที่สร้าง", icon: Icon(Icons.create)),
                  ],
                ),
                Expanded(
                  child: BlocBuilder<ClassroomListBloc, ClassroomListState>(
                    builder: (context, state) {
                      if (state is ClassroomListLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ClassroomListLoaded) {
                        final teachingClassrooms = state.teachingClassrooms;
                        final studyingClassrooms = state.studyingClassrooms;
                        return TabBarView(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: ListView.builder(
                                itemCount: studyingClassrooms.length,
                                itemBuilder: (context, index) {
                                  final classroom = studyingClassrooms[index];
                                  return ClassroomCard(
                                    classroomId: classroom.id,
                                    classroomName: classroom.name,
                                    description: classroom.description,
                                    teacherName: classroom.createdBy,
                                    studentCount: classroom.studentCount,
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: ListView.builder(
                                itemCount: teachingClassrooms.length,
                                itemBuilder: (context, index) {
                                  final classroom = teachingClassrooms[index];
                                  return ClassroomCard(
                                    classroomId: classroom.id,
                                    classroomName: classroom.name,
                                    description: classroom.description,
                                    teacherName: classroom.createdBy,
                                    studentCount: classroom.studentCount,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else if (state is FetchClassroomListFailed) {
                        return Center(child: Text(state.message));
                      } else {
                        return const Center(child: Text("Unknown state"));
                      }
                    },
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
