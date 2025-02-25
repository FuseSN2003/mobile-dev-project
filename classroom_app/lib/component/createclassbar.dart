import 'package:flutter/material.dart';

class CreateClassbar extends StatelessWidget {
  const CreateClassbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 2, color: Colors.white)),
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      onPressed: () {
        _showEnterClassroomDialog(context, text);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(width: 2, color: Colors.white54),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Text(
          "$text",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showEnterClassroomDialog(BuildContext context, String? text) {
    TextEditingController _codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          child: Container(
            // width: 500, // 80% of screen width
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Shrink to fit content
              children: [
                Text(
                  text == "สร้างขั้นเรียน"
                      ? "Enter Classroom Name :"
                      : "Enter Classroom Code :",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText:
                        text == "สร้างขั้นเรียน"
                            ? "Classroom Name"
                            : "Classroom Code",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText:
                        text == "สร้างขั้นเรียน"
                            ? "Type the classroom name"
                            : "Type the classroom code",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      // Hint text color from theme
                    ),
                    // fillColor: Colors.white,
                    // filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Rounded corners for the border
                      borderSide: BorderSide(
                        color: Colors.white, // Border color
                        width: 2, // Border width
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Submit"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Close"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
