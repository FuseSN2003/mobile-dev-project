import 'package:classroom_app/blocs/classroom_detail_bloc/classroom_detail_bloc.dart';
import 'package:classroom_app/screens/assignment_screen.dart';
import 'package:classroom_app/screens/forum_screen.dart';
import 'package:classroom_app/screens/member_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomDetailScreen extends StatefulWidget {
  final String classroomId;
  const ClassroomDetailScreen({super.key, required this.classroomId});

  @override
  State<ClassroomDetailScreen> createState() => _ClassroomDetailScreenState();
}

class _ClassroomDetailScreenState extends State<ClassroomDetailScreen> {
  int _currentIndex = 0;
  List<Widget> get _screens => [
    ForumScreen(classroomId: widget.classroomId),
    AssignmentScreen(classroomId: widget.classroomId),
    MemberScreen(classroomId: widget.classroomId),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ClassroomDetailBloc()
                ..add(FetchClassroomDetail(classroomId: widget.classroomId)),
      child: BlocBuilder<ClassroomDetailBloc, ClassroomDetailState>(
        builder: (context, state) {
          if (state is ClassroomDetailLoaded) {
            return Scaffold(
              appBar: AppBar(title: Text(state.classroom.name)),
              body: _screens[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.forum),
                    label: 'Forum',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assignment),
                    label: 'Assignment',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.group),
                    label: 'Members',
                  ),
                ],
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            );
          } else if (state is ClassroomDetailLoading ||
              state is ClassroomDetailInitial) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text(
                  state is FetchClassroomDetailFailed
                      ? state.message
                      : 'Something went wrong',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
