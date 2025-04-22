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
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => ClassroomDetailBloc(),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Forum'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Members'),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
