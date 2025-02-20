import 'package:flutter/material.dart';

class CreateClassbar extends StatelessWidget {
  const CreateClassbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 2, color: Colors.white)),
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildTextButton(context, "สร้างขั้นเรียน"),
            buildTextButton(context, "เข้าร่วมชั้นเรียน"),
          ],
        ),
      ),
    );
  }

  Widget buildTextButton(BuildContext context, String text) {
    return TextButton(
      onPressed: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(width: 2, color: Colors.white54),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Text(
          "$text",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
