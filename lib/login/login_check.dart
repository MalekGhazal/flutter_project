import 'package:flutter/material.dart';
import 'package:flutter_project/login/login.dart';
import 'package:flutter_project/profile/profile.dart';
import 'package:flutter_project/services/authentication.dart';


class LoginCheck extends StatelessWidget {
  const LoginCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const ProfileScreen();
          } else {
            return const LoginScreen();
          }
        });
  }
}
