import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? colors;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      child: Text(text, style: TextStyle(color: colors ?? null)),
    );
  }
}
