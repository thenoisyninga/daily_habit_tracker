import 'package:flutter/material.dart';

ThemeData myDarkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    secondary: const Color.fromARGB(255, 21, 21, 21),
    surface: const Color.fromARGB(255, 36, 36, 36),
    primary: const Color.fromARGB(255, 21, 21, 21),
    onBackground: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.grey[200]!,
    onSurface: Colors.white,
  ),
  dialogBackgroundColor: Color.fromARGB(255, 33, 33, 33),
  dialogTheme: DialogTheme(
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 18,
      color: Colors.grey[100],
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[900],
    focusColor: Colors.grey[800],
    labelStyle: TextStyle(
      color: Colors.grey[400],
      fontWeight: FontWeight.w300,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 18, 18, 18),
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
