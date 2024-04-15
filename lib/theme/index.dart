import 'package:flutter/material.dart';

extension TextColors on ThemeData {
  Color get successGreen {
    return const Color.fromRGBO(91, 215, 0, 1);
  }
}

final ThemeData themeData = ThemeData(
  useMaterial3: true,
  primaryColorDark: Colors.black,
  dividerColor: const Color.fromRGBO(200, 199, 204, 1),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.lightGreenAccent,
    secondary: Colors.grey,
    brightness: Brightness.dark,
    error: Colors.redAccent,
  ),
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
