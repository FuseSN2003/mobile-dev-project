import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final ValueNotifier<bool>? visibilityNotifier;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.visibilityNotifier,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late ValueNotifier<bool> _visibilityNotifier;

  @override
  void initState() {
    super.initState();
    _visibilityNotifier =
        widget.visibilityNotifier ?? ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              "${widget.label} :",
              style: GoogleFonts.inder(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 14,
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _visibilityNotifier,
            builder: (context, isVisible, child) {
              return TextField(
                obscureText:
                    widget.visibilityNotifier != null ? isVisible : false,
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: widget.label,
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
                  suffixIcon:
                      widget.visibilityNotifier != null
                          ? IconButton(
                            onPressed: () {
                              _visibilityNotifier.value =
                                  !_visibilityNotifier.value;
                            },
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            color: Theme.of(context).colorScheme.onPrimary,
                          )
                          : null,
                ),
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _visibilityNotifier.dispose();
    super.dispose();
  }
}
