import 'package:app/constants/mode.dart';
import 'package:app/theme/custom_color.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  ThemeData settingsTheme(Mode themeMode) {
    final colors = CustomColor(mode: themeMode);
    return (ThemeData(
      brightness:
          themeMode == Mode.lightMode ? Brightness.light : Brightness.dark,
      primaryColor: colors.primary.main,
      scaffoldBackgroundColor: colors.background,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary.main,
          foregroundColor: colors.primary.contrastText,
          iconColor: colors.primary.contrastText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary.main,
          iconColor: colors.primary.main,
          side: BorderSide(color: colors.primary.main),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colors.background,
        prefixIconColor: colors.primary.main,
        suffixIconColor: colors.primary.main,
        labelStyle: TextStyle(color: colors.primary.main),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colors.primary.main),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.primary.main),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.primary.main, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        hintStyle: TextStyle(color: Colors.grey),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.text,
        selectionColor: colors.text.withOpacity(0.5),
        selectionHandleColor: colors.text,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary.main,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: colors.text),
        bodyMedium: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: colors.text, fontStyle: FontStyle.italic),
      ),
    ));
  }
}
