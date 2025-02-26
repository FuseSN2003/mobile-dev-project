import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Enjoy your ',
              style: TextStyle(color: Colors.white70),
            ),
            TextSpan(
              text: 'classes',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ), // Change color for "classes"
            ),
            const TextSpan(
              text: ' and make every ',
              style: TextStyle(color: Colors.white70),
            ),
            TextSpan(
              text: 'lesson',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ), // Change color for "lesson"
            ),
            const TextSpan(
              text: ' count!',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
