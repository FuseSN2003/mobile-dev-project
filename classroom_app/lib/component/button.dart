import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? colors;
  final Color? backGroundColors;
  final double? paddingWidth;
  final double? paddingHeight;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.colors,
    this.backGroundColors,
    this.paddingWidth,
    this.paddingHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: paddingWidth ?? 20,
          vertical: paddingHeight ?? 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        backgroundColor: backGroundColors,
      ),
      child: Text(text, style: TextStyle(color: colors ?? null)),
    );
  }
}
