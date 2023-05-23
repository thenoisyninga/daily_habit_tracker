import 'package:flutter/material.dart';

ThemeData myLightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: const Color.fromARGB(255, 212, 212, 212),
    secondary: const Color.fromARGB(255, 242, 242, 242),
    surface: const Color.fromARGB(255, 242, 242, 242),
    primary: Colors.white,
    onBackground: Colors.black,
    onPrimary: Colors.black,
    onSecondary: Colors.grey[800]!,
    onSurface: Colors.black,
  ),
  dialogBackgroundColor: const Color.fromARGB(255, 225, 225, 225),
  dialogTheme: DialogTheme(
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 18,
      color: Colors.grey[900],
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[100],
    focusColor: Colors.grey[200],
    labelStyle: TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w300,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 193, 193, 193),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(5),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.red.withAlpha(170),
      ),
      borderRadius: BorderRadius.circular(5),
    ),
  ),
);
