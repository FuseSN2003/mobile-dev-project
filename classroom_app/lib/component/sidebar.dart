import 'package:flutter/material.dart';

// Corrected Sidebar class
class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.grey[300]),
                child: Center(
                  child: Icon(
                    Icons.shopping_bag,
                    size: 72,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              MyListtile(
                icon: Icons.home,
                text: "Shop",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              MyListtile(
                icon: Icons.shopping_cart,
                text: "Cart",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/cartpage');
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MyListtile(
              icon: Icons.exit_to_app,
              text: "Exit",
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Corrected ListTile Widget
class MyListtile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MyListtile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}
