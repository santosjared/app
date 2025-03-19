

import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget{

  final String text;

  const CustomDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(thickness: 1, color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const Expanded(
          child: Divider(thickness: 1, color: Colors.grey),
        ),
      ],
    );
  }
}