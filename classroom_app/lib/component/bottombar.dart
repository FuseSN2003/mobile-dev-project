import 'package:flutter/material.dart';

class Bottombar extends StatelessWidget {
  const Bottombar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/classroom_form");
                  },
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
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/classroom_work");
                  },
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
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      "/classroom_person",
                    );
                  },
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
    );
  }
}
