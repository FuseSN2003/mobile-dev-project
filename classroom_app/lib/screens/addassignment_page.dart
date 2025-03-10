import 'dart:io';

import 'package:classroom_app/blocs/assignment/assignment_bloc.dart';
import 'package:classroom_app/blocs/classroom_detail/classroom_detail_bloc.dart';
import 'package:classroom_app/component/sidebar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../component/button.dart';
import '../component/navbar.dart';

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
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
            final classroomDetailBloc = BlocProvider.of<ClassroomDetailBloc>(
              context,
            );
            final classroomDetailState = classroomDetailBloc.state;
            if (classroomDetailState is ClassroomDetailLoaded) {
              classroomDetailBloc.add(
                FetchClassroomDetail(
                  classroomId: classroomDetailState.classroom.id,
                ),
              );
            }
            Navigator.pop(context);
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
                      children: [
                        Text("Classroom : ${state.classroom.name}"),
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
                        Text("รายละเอียดงาน :"),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(color: Colors.white, fontSize: 12),
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
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: pickFiles,
                          child: Text("Pick a File"),
                        ),
                        SizedBox(height: 10),
                        _selectedFiles.isNotEmpty
                            ? SizedBox(
                              height: 150,
                              child: ListView.builder(
                                itemCount: _selectedFiles.length,
                                itemBuilder: (context, index) {
                                  String filePath = _selectedFiles[index].path;
                                  bool isImage =
                                      filePath.toLowerCase().endsWith('.png') ||
                                      filePath.toLowerCase().endsWith('.jpg') ||
                                      filePath.toLowerCase().endsWith(
                                        '.jpeg',
                                      ) ||
                                      filePath.toLowerCase().endsWith('.gif');

                                  return isImage
                                      ? Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Image.file(
                                          _selectedFiles[index],
                                          height: 100,
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                },
                              ),
                            )
                            : Text(
                              "No files selected",
                              style: TextStyle(color: Colors.white),
                            ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("กำหนดส่ง : $date"),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: Text("Pick a Date"),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("คะแนน :"),
                            SizedBox(width: 20),
                            Expanded(
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
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
                                    dueDate:
                                        selectedDate?.toLocal().toString() ??
                                        "",
                                    score:
                                        int.tryParse(_scoreController.text) ??
                                        0,
                                    files: _selectedFiles,
                                  ),
                                );
                              },
                            ),
                            CustomButton(
                              text: "ยกเลิก",
                              onPressed: () => Navigator.pop(context),
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
