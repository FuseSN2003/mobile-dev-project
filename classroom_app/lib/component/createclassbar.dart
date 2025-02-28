import 'package:classroom_app/blocs/classroom/classroom_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ClassDialogType { create, join }

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
            _buildTextButton(context, ClassDialogType.create),
            _buildTextButton(context, ClassDialogType.join),
          ],
        ),
      ),
    );
  }

  _buildTextButton(BuildContext context, ClassDialogType type) {
    return TextButton(
      onPressed: () {
        if (type == ClassDialogType.create) {
          _showCreateClassDialog(context);
        } else {
          _showJoinClassroomDialog(context);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(width: 2, color: Colors.white54),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Text(
          type == ClassDialogType.create
              ? "สร้างชั้นเรียน"
              : "เข้าร่วมชั้นเรียน",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showCreateClassDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

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
                  "Enter Classroom Infomation :",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Classroom Name",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Type the classroom name",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    fillColor: Colors.grey[800],
                    filled: true,
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
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Classroom Description",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "e.g. sec. 1",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    fillColor: Colors.grey[800],
                    filled: true,
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
                      onPressed:
                          () => {
                            context.read<ClassroomBloc>().add(
                              CreateClassroom(
                                name: nameController.text,
                                description: descriptionController.text,
                              ),
                            ),
                            Navigator.of(context).pop(),
                          },
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

  void _showJoinClassroomDialog(BuildContext context) {
    final codeController = TextEditingController();

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
                  "Enter Classroom Code :",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: "Classroom Code",
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Type the classroom code",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    fillColor: Colors.grey[800],
                    filled: true,
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
                      onPressed:
                          () => {
                            context.read<ClassroomBloc>().add(
                              JoinClassroom(code: codeController.text),
                            ),
                            Navigator.of(context).pop(),
                          },
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
