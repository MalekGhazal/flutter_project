import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Montserrat',
  brightness: Brightness.light,
  appBarTheme:
      const AppBarTheme(backgroundColor: Color(0xFFEBE8E2), elevation: 0.0),
  colorScheme: const ColorScheme.light(
      background: Color(0xFFEBE8E2),
      primary: Color(0xFF203D4E),
      secondary: Color(0xFFBD5F5F)),
);
