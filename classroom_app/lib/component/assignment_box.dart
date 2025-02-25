import 'package:flutter/material.dart';

class assignTask extends StatefulWidget {
  const assignTask({
    super.key,
    required this.classRoomName,
    required this.taskName,
    required this.time,
    required this.score,
    this.onPress,
  });

  final String classRoomName;
  final String taskName;
  final String time;
  final int score;
  final VoidCallback? onPress;

  @override
  State<assignTask> createState() => _assignTaskState();
}

class _assignTaskState extends State<assignTask> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        width: double.infinity, // Makes it take full width
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // ✅ Ensures Row content doesn't overflow
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        // ✅ Expands classRoomName properly
                        child: Text(
                          widget.classRoomName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  widget.time,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              widget.taskName,
              style: const TextStyle(fontSize: 14, color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // Show "..." if it overflows
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '${widget.score} คะแนน',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
