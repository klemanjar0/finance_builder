import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const lochmaraColor = const Color(0xff1F6AAC);
const darkLochmaraColor = const Color(0xff053C80);
const kellyGreenColor = const Color(0xff5BD700);
const dolphinColor = const Color(0xff74747B);
const ghostColor = const Color(0xffC8C7CC);
const pigmentGreenColor = const Color(0xff00B146);
const sunsetOrangeColor = const Color(0xffFF4A4A);
const whiteColor = const Color(0xffFFFFFF);
const snowColor = const Color(0xFFF9F9F9);
const blackColor = const Color(0xFF000000);
const lavenderColor = const Color(0xFFEFEFF4);

extension TextColors on ThemeData {
  Color get pigmentGreen => pigmentGreenColor;
  Color get lochmara => lochmaraColor;
  Color get darkLochmara => darkLochmaraColor;
  Color get kellyGreen => kellyGreenColor;
  Color get dolphin => dolphinColor;
  Color get ghost => ghostColor;
  Color get sunsetOrange => sunsetOrangeColor;
  Color get white => whiteColor;
  Color get snow => snowColor;
  Color get black => blackColor;
  Color get lavender => lavenderColor;
}

const cupertinoThemeData = CupertinoThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: CupertinoColors.secondarySystemBackground,
    primaryColor: CupertinoColors.activeBlue);

final ThemeData themeData = ThemeData(
  useMaterial3: true,
  primaryColorDark: Colors.black,
  dividerColor: const Color.fromRGBO(200, 199, 204, 1),
  colorScheme: ColorScheme.fromSeed(
    seedColor: lochmaraColor,
    secondary: Colors.grey,
    brightness: Brightness.dark,
    error: sunsetOrangeColor,
  ),
  buttonTheme: const ButtonThemeData(
      buttonColor: lochmaraColor, disabledColor: dolphinColor),
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
