import 'package:classroom_app/component/sidebar.dart';
import 'package:flutter/material.dart';
import '../component/navbar.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAssignmentPage extends StatefulWidget {
  const AddAssignmentPage({super.key});

  @override
  State<AddAssignmentPage> createState() => _AddAssignmentPageState();
}

class _AddAssignmentPageState extends State<AddAssignmentPage> {
  final String className = "ชื่อ : Class room";
  final TextEditingController workName = TextEditingController();
  DateTime? selectedDate; // Store selected date

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
            children: [
              Text("$className", style: TextStyle()),
              Row(
                children: [
                  Text("ชื่องาน :", style: TextStyle()),
                  Expanded(
                    child: TextField(
                      controller: workName,
                      decoration: InputDecoration(
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
              Text("รายละเอียดงาน :"),
              TextField(
                maxLines: 4,
                controller: workName,
                decoration: InputDecoration(
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
              Text("กำหนดส่ง :"),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text("Pick a Date"),
              ),
              Text("คะแนน"),
              TextField(
                maxLines: 4,
                controller: workName,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
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
            ],
          ),
        ),
      ),
    );
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
            // Change background color if needed
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
