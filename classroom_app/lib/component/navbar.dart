import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.background, // Dark background
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white), // Hamburger menu
          onPressed: () {
            // Handle menu tap
          },
        ),
        title: Text(
          'Your Classes',
          style: TextStyle(
            fontFamily: 'Cursive', // Custom font if available
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent, // Green text
          ),
        ),

        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white), // User icon
            onPressed: () {
              // Handle user profile tap
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70);
}
