import 'package:flutter/material.dart';
import '../component/bottombar.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';

class ClassroomPersonPage extends StatefulWidget {
  const ClassroomPersonPage({super.key});

  @override
  State<ClassroomPersonPage> createState() => _ClassroomPersonPageState();
}

class _ClassroomPersonPageState extends State<ClassroomPersonPage> {
  // Define the student list
  final List<String> studentNames = [
    "Rati Maneengam",
    "John Doe",
    "Jane Smith",
    "Bob White",
  ];
  final List<String> teacherNames = ["Alice Brown"];
  final String className = "ชื่อ : Class room";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(backButton: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("$className", style: TextStyle(color: Colors.white)),
                  Text("รหัสคลาสรูม", style: TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 10),

              Container(child: _buildPerson("นักเรียน", teacherNames)),
              Container(child: _buildPerson("อาจารย์", studentNames)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bottombar(),
    );
  }

  // Function to build student grid
  Widget _buildPerson(String label, List<String> itemList) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              label, // "Students" in Thai
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              childAspectRatio: 3.5, // Adjust for UI balance
            ),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              if (label == "student") {
                return StudentCard(name: itemList[index], onPress: () {});
              } else {
                return StudentCard(name: itemList[index]);
              }
            },
          ),
        ],
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final String name;
  final Function? onPress;
  const StudentCard({super.key, required this.name, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54, // Dark background color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.account_circle, color: Colors.green, size: 24),
              const SizedBox(width: 4),
              SizedBox(
                width: 80, // ✅ Set a max width to prevent overflow
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  overflow: TextOverflow.ellipsis, // ✅ Cut off long names
                  maxLines: 1, // ✅ Ensure text stays in one line
                ),
              ),
            ],
          ),
          if (onPress != null) // ✅ Only show button if onPress is not null
            IconButton(
              onPressed: () => onPress!(), // ✅ Call the function safely
              icon: const Icon(Icons.remove, size: 12),
              color: Colors.white,
            ), // Minus button
        ],
      ),
    );
  }
}
