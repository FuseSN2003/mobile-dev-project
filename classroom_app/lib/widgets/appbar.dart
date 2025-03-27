import 'package:classroom_app/core/constant.dart';
import 'package:classroom_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHomeScreen;

  const CustomAppBar({super.key, this.isHomeScreen = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextButton(
        onPressed:
            isHomeScreen
                ? null
                : () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
        child: Text(
          AppConstant.appName,
          style: GoogleFonts.kaushanScript(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [IconButton(icon: Icon(Icons.person), onPressed: () {})],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
