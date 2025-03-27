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
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                _showCreateClassroomDialog(context);
              },
              child: Text("สร้างชั้นเรียน"),
            ),
            ElevatedButton(
              onPressed: () {
                _showJoinClassroomDialog(context);
              },
              child: Text("เข้าร่วมชั้นเรียน"),
            ),
          ],
        ),
      ),
    );
  }

  _showCreateClassroomDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("สร้างชั้นเรียน"),
          content: Form(
            key: formKey,
            child: Column(
              spacing: 12,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อชั้นเรียน',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'กรุณากรอกชื่อชั้นเรียน'
                              : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'คำอธิบายชั้นเรียน',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ยกเลิก"),
            ),
            ElevatedButton(onPressed: () {}, child: Text("สร้าง")),
          ],
        );
      },
    );
  }

  _showJoinClassroomDialog(BuildContext context) {
    final codeController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("เข้าร่วมชั้นเรียน"),
          content: Form(
            key: formKey,
            child: Column(
              spacing: 12,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: 'รหัสชั้นเรียน',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'กรุณากรอกรหัสชั้นเรียน'
                              : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ยกเลิก"),
            ),
            ElevatedButton(onPressed: () {}, child: Text("เข้าร่วม")),
          ],
        );
      },
    );
  }
}
