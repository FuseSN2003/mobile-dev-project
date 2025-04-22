import 'package:flutter/widgets.dart';

class ForumScreen extends StatefulWidget {
  final String classroomId;
  const ForumScreen({super.key, required this.classroomId});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Forum Screen'));
  }
}
