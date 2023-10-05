import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'Montserrat',
  brightness: Brightness.dark,
  appBarTheme:
      const AppBarTheme(backgroundColor: Color(0xFF203D4E), elevation: 0.0),
  colorScheme: const ColorScheme.dark(
      background: Color(0xFF203D4E),
      primary: Color(0xFFEBE8E2),
      secondary: Color(0xFFBD5F5F)),
);
