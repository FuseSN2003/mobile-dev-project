import 'package:flutter/material.dart';

class StudentBox extends StatelessWidget {
  final String label;
  final List<String> itemList;
  final Function(String)? onItemPress; // Optional callback for item actions

  const StudentBox({
    super.key,
    required this.label,
    required this.itemList,
    this.onItemPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
              return StudentCard(
                name: itemList[index],
                onPress:
                    onItemPress != null
                        ? () => onItemPress!(itemList[index])
                        : null,
              );
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
