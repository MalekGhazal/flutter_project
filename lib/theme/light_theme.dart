import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Montserrat',
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFEBE8E2),
      elevation: 0.0,
      iconTheme: IconThemeData(color: Color(0xFF203D4E))),
  colorScheme: const ColorScheme.light(
      background: Color(0xFFEBE8E2),
      primary: Color(0xFF203D4E),
      secondary: Color(0xFFBD5F5F)),
);

class WhiteText extends StatelessWidget {
  final String data;

  const WhiteText(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
          color: Theme.of(context).colorScheme.background,
          fontWeight: FontWeight.w700),
    );
  }
}

class RedText extends StatelessWidget {
  final String data;

  const RedText(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w700),
    );
  }
}
