import 'package:classroom_app/component/sidebar.dart';
import 'package:flutter/material.dart';
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
  final String className = "ชื่อ : Class room";
  final TextEditingController assignmentName = TextEditingController();
  final TextEditingController assignmentDesc = TextEditingController();
  final TextEditingController score = TextEditingController();
  List<File> _selectedFiles = [];

  DateTime? selectedDate; // Store selected date
  String date = "";
  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Allow multiple file selection
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.files.map((file) => File(file.path!)).toList();
      });
    } else {
      print("No files selected");
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
            // accentColor: Colors.blueAccent,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            textTheme: TextTheme(
              // bodyText2: TextStyle(color: Colors.white), // Change text color
            ),
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("$className", style: TextStyle()),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("ชื่องาน :", style: TextStyle()),
                  SizedBox(width: 10),

                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      controller: assignmentName,
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
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("รายละเอียดงาน :"),
                  SizedBox(height: 15),
                  TextField(
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    maxLines: 4,
                    controller: assignmentDesc,
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
                      ? Container(
                        height: 150, // Set a fixed height for the file list
                        child: ListView.builder(
                          itemCount: _selectedFiles.length,
                          itemBuilder: (context, index) {
                            String filePath = _selectedFiles[index].path;
                            bool isImage = false;
                            // bool isImage =
                            //     filePath.toLowerCase().endsWith('.png') ||
                            //     filePath.toLowerCase().endsWith('.jpg') ||
                            //     filePath.toLowerCase().endsWith('.jpeg') ||
                            //     filePath.toLowerCase().endsWith('.gif');

                            return isImage
                                ? Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Image.file(
                                    _selectedFiles[index],
                                    height: 100, // Set a fixed image height
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
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("กำหนดส่ง : ${date}"),
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
                  Container(
                    width: 100,
                    child: Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white, fontSize: 12),
                        maxLines: 1,
                        controller: score,
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
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
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
                  CustomButton(text: "เพิ่มงาน", onPressed: () {}),
                  CustomButton(
                    text: "ยกเลิก",
                    onPressed: () {},
                    colors: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
