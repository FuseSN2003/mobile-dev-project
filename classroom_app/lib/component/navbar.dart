import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key, this.backButton = false});
  final bool backButton;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white54,
              width: 2,
            ), // Bottom border only
          ),
        ),
        child: AppBar(
          backgroundColor:
              Theme.of(context).colorScheme.surface, // Dark background
          elevation: 0,
          leading:
              !backButton
                  ? IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 32,
                    ), // Hamburger menu
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                      ; // Open Sidebar Drawer
                    },
                  )
                  : IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 32),
                    onPressed: () => Navigator.pop(context), // Default: Go back
                  ),
          title: TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            },
            child: Text(
              'Your Classes',
              style: TextStyle(
                fontFamily: 'Cursive', // Custom font if available
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary, // Green text
              ),
            ),
          ),

          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 32,
              ), // User icon
              onPressed: () {
                // Handle user profile tap
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
