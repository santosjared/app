import 'package:app/layouts/background_layout.dart';
import 'package:app/theme/custom_color.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class LayoutWithAppbar extends StatelessWidget {
  final Widget child;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final String title;
  const LayoutWithAppbar({
    super.key,
    required this.child,
    this.title = '',
    this.drawer,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final colors = CustomColor.of(context);
    return CustomPaint(
      painter: BackgroundLayout(
        backgroundColor: colors.background,
        dotColor: colors.circularBg,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppbar(title: title),
        drawer: drawer,
        bottomNavigationBar: bottomNavigationBar,
        body: child,
      ),
    );
  }
}
