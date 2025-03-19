// lib/widgets/custom_input_field.dart

import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon, prefixIcon;

  const CustomInputField({super.key, 
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon, 
        ),
      ),
    );
  }
}
