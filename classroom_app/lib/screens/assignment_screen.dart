import 'package:flutter/widgets.dart';

class AssignmentScreen extends StatefulWidget {
  final String classroomId;
  const AssignmentScreen({super.key, required this.classroomId});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Assignment Screen'));
  }
}
