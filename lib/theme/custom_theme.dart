import 'package:app/constants/mode.dart';
import 'package:app/theme/color_scheme.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  ThemeData settingsTheme(Mode themeMode) {
    return (ThemeData(
      brightness:
          themeMode == Mode.lightMode ? Brightness.light : Brightness.dark,
      primaryColor: ColorsScheme.primary,
      scaffoldBackgroundColor:
          themeMode == Mode.lightMode
              ? ColorsScheme.lightBackground
              : ColorsScheme.darkBackground,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsScheme.primary,
          foregroundColor: Colors.white,
          iconColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorsScheme.primary,
          iconColor: ColorsScheme.primary,
          side: BorderSide(color: ColorsScheme.primary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor:
            themeMode == Mode.lightMode
                ? ColorsScheme.lightBackground
                : ColorsScheme.darkBackground,
        prefixIconColor: ColorsScheme.primary,
        suffixIconColor: ColorsScheme.primary,
        labelStyle: TextStyle(color: ColorsScheme.primary),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsScheme.primary, width: 2),
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
        cursorColor:
            themeMode == Mode.lightMode
                ? ColorsScheme.textLight
                : ColorsScheme.textDark,
        selectionColor:
            themeMode == Mode.lightMode
                ? ColorsScheme.textLight.withOpacity(0.5)
                : ColorsScheme.textDark.withOpacity(0.5),
        selectionHandleColor:
            themeMode == Mode.lightMode
                ? ColorsScheme.textLight
                : ColorsScheme.textDark,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ColorsScheme.primary,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color:
              themeMode == Mode.lightMode
                  ? ColorsScheme.textLight
                  : ColorsScheme.textDark,
        ),
        bodyMedium: TextStyle(
          color:
              themeMode == Mode.lightMode
                  ? ColorsScheme.textLight
                  : ColorsScheme.textDark,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color:
              themeMode == Mode.lightMode
                  ? ColorsScheme.textLight
                  : ColorsScheme.textDark,
          fontStyle: FontStyle.italic,
        ),
      ),
    ));
  }
}
