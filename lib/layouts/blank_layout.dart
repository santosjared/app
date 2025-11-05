import 'package:app/layouts/background_layout.dart';
import 'package:app/theme/custom_color.dart';
import 'package:flutter/material.dart';

class BlankLayout extends StatelessWidget {
  final Widget child;
  const BlankLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = CustomColor.of(context);
    return CustomPaint(
      painter: BackgroundLayout(
        backgroundColor: colors.background,
        dotColor: colors.circularBg,
      ),
      child: Scaffold(body: child, backgroundColor: Colors.transparent),
    );
  }
}
