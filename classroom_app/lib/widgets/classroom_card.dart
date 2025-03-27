import 'package:flutter/material.dart';

class ClassroomCard extends StatelessWidget {
  final String classroomId;
  final String classroomName;
  final String description;
  final String teacherName;
  final int? studentCount;

  const ClassroomCard({
    super.key,
    required this.classroomId,
    required this.classroomName,
    required this.description,
    required this.teacherName,
    this.studentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: () {
          // navigate to classroom details by classroomId
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: Column(
              children: [
                Icon(
                  Icons.class_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            title: Text(
              classroomName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      teacherName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    studentCount != null
                        ? Text(
                          'นักเรียน $studentCount คน',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
