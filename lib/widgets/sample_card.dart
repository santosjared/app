import 'package:flutter/material.dart';

class SampleCard extends StatelessWidget {
  const SampleCard({super.key, required this.cardName});
  final String cardName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Center(
        child: Text(
          cardName,
          style: TextStyle(
            color: const Color.fromARGB(255, 225, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
