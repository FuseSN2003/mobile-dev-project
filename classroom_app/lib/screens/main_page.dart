import 'package:flutter/material.dart';
import '../component/navbar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(),
      body: Center(
        child: Text("Welcome to Your Classes", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
