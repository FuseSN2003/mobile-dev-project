import 'package:flutter/widgets.dart';

class MemberScreen extends StatefulWidget {
  final String classroomId;
  const MemberScreen({super.key, required this.classroomId});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Member Screen'));
  }
}
