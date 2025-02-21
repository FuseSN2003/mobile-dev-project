import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../component/bottombar.dart';
import '../component/navbar.dart';

class ClassroomPage extends StatefulWidget {
  const ClassroomPage({super.key});

  @override
  State<ClassroomPage> createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(backButton: true),
      body: Column(),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        child: Container(
          // height: 100,
          width: double.infinity,
          // padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.description,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    "ฟอร์ม",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.work,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    "งานชั้นเรียน",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    "บุคคล",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
