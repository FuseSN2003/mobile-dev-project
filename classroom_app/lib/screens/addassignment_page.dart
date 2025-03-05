import 'package:classroom_app/blocs/assignment/assignment_bloc.dart';
import 'package:classroom_app/blocs/classroom_detail/classroom_detail_bloc.dart';
import 'package:classroom_app/component/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../component/navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/button.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AddAssignmentPage extends StatefulWidget {
  const AddAssignmentPage({super.key});

  @override
  State<AddAssignmentPage> createState() => _AddAssignmentPageState();
}

class _AddAssignmentPageState extends State<AddAssignmentPage> {
  final _assignmentNameController = TextEditingController();
  final _assignmentDescController = TextEditingController();
  final _scoreController = TextEditingController();
  List<File> _selectedFiles = [];

  DateTime? selectedDate;
  String date = "";

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.files.map((file) => File(file.path!)).toList();
      });
    } else {
      debugPrint("No files selected");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(), // Default to today
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            textTheme: TextTheme(),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(backButton: true),
      drawer: Sidebar(),
      body: BlocListener<AssignmentBloc, AssignmentState>(
        listener: (context, state) {
          if (state is AddAssignmentSuccess) {
            final detailState = context.read<ClassroomDetailBloc>().state;
            if (detailState is ClassroomDetailLoaded) {
              context.read<ClassroomDetailBloc>().add(
                FetchClassroomDetail(classroomId: detailState.classroom.id),
              );
              Navigator.pop(context);
            }
          }
        },
        child: BlocBuilder<ClassroomDetailBloc, ClassroomDetailState>(
          builder: (context, state) {
            if (state is ClassroomDetailLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: DefaultTextStyle(
                    style: TextStyle(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Classroom : ${state.classroom.name}",
                          style: TextStyle(),
                        ),
                        SizedBox(height: 10),
                        Text("ชื่องาน :"),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          controller: _assignmentNameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "ชื่องาน",
                            hintStyle: GoogleFonts.inder(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("รายละเอียดงาน :"),
                            SizedBox(height: 15),
                            TextField(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              maxLines: 7,
                              controller: _assignmentDescController,
                              decoration: InputDecoration(
                                hintText: "รายละเอียด",
                                hintStyle: GoogleFonts.inder(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: pickFiles,
                              child: Text("Pick a File"),
                            ),
                            SizedBox(height: 20), 
                            _selectedFiles.isNotEmpty
                                ? SizedBox(
                                  height:
                                      150, // Set a fixed height for the file list
                                  child: ListView.builder(
                                    itemCount: _selectedFiles.length,
                                    itemBuilder: (context, index) {
                                      String filePath =
                                          _selectedFiles[index].path;
                                      // bool isImage = false;
                                      bool isImage =
                                          filePath.toLowerCase().endsWith(
                                            '.png',
                                          ) ||
                                          filePath.toLowerCase().endsWith(
                                            '.jpg',
                                          ) ||
                                          filePath.toLowerCase().endsWith(
                                            '.jpeg',
                                          ) ||
                                          filePath.toLowerCase().endsWith(
                                            '.gif',
                                          );

                                      return isImage
                                          ? Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Image.file(
                                              _selectedFiles[index],
                                              height:
                                                  100, // Set a fixed image height
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                          : ListTile(
                                            leading: Icon(
                                              Icons.insert_drive_file,
                                              color: Colors.white,
                                            ),
                                            title: Text(
                                              filePath.split('/').last,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                    },
                                  ),
                                )
                                : Text(
                                  "No files selected",
                                  style: TextStyle(color: Colors.white),
                                ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("กำหนดส่ง : $date"),
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: const Text("Pick a Date"),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("คะแนน :"),
                            SizedBox(width: 20),
                            SizedBox(
                              width: 100,
                              child: Expanded(
                                child: TextField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  controller: _scoreController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "คะแนน",
                                    hintStyle: GoogleFonts.inder(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                        width: 2,
                                      ), // Border color when focused
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              text: "เพิ่มงาน",
                              onPressed: () {
                                context.read<AssignmentBloc>().add(
                                  AddAssignment(
                                    classroomId: state.classroom.id,
                                    title: _assignmentNameController.text,
                                    description: _assignmentDescController.text,
                                    dueDate: selectedDate.toString(),
                                    score: int.parse(_scoreController.text),
                                    files: _selectedFiles,
                                  ),
                                );
                              },
                            ),
                            CustomButton(
                              text: "ยกเลิก",
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              colors: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
