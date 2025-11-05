import 'package:flutter/material.dart';
import 'package:app/constants/mode.dart';

class CustomColor {
  final Mode mode;
  final PrimaryColor primary = PrimaryColor();
  final ErrorColor error = ErrorColor();

  CustomColor({required this.mode});

  /// Constructor para obtener el modo desde el contexto
  factory CustomColor.of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return CustomColor(
      mode: brightness == Brightness.light ? Mode.lightMode : Mode.darkMode,
    );
  }

  Color get background =>
      mode == Mode.lightMode
          ? const Color(0xFFF2F2F2)
          : const Color(0xFF282A42);

  Color get text =>
      mode == Mode.lightMode
          ? const Color.fromRGBO(76, 78, 100, 0.87)
          : const Color.fromRGBO(255, 255, 255, 0.87);

  Color get circularBg =>
      mode == Mode.lightMode
          ? Colors.white.withValues(alpha: 0.35)
          : const Color.fromRGBO(15, 15, 15, 0.05);
}

class PrimaryColor {
  final Color main = const Color(0xFF5F7200);
  final Color dark = const Color(0xFF395500);
  final Color light = const Color(0xFFA4D055);
  final Color contrastText = const Color(0xFFFFFFFF);
}

class ErrorColor {
  final Color main = const Color(0xFFFF4D49);
  final Color dark = const Color(0xFFE04440);
  final Color light = const Color(0xFFFF625F);
  final Color contrastText = const Color(0xFFFFFFFF);
}
