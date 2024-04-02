import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData(
  useMaterial3: true,

  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.lightGreenAccent,
    secondary: Colors.teal,
    brightness: Brightness.dark,
  ),

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 72,
      fontWeight: FontWeight.bold,
    ),
    // ···
    titleLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    displaySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
  ),
);
