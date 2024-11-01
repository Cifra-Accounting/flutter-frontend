import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF000000),
    onSurface: Color(0xFFFFFFFF),
    primary: Color(0xFFFF0000),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF333333),
    onSecondary: Color(0xFF5A5A5A),
    tertiary: Color(0xFFD9D9D9),
    onTertiary: Color(0xFF000000),
  ),
  scaffoldBackgroundColor: const Color(0xFF000000),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontFamily: "Montserrat",
      fontSize: 40,
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFFFFF),
    ),
    titleSmall: TextStyle(
      fontFamily: "Montserrat",
      fontSize: 15,
      fontWeight: FontWeight.w800,
      color: Color(0xFFFFFFFF),
    ),
  ),
);
