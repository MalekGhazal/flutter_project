import 'package:flutter/material.dart';
import 'package:flutter_project/login/login.dart';
import 'package:flutter_project/screens/todos_screen.dart';
import 'package:flutter_project/services/authentication.dart';

class LoginCheck extends StatelessWidget {
  const LoginCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (AuthService().user?.email != null) {
              return const TodosScreen(dataSource: TodoDataSource.google);
            } else {
              return const TodosScreen(dataSource: TodoDataSource.local);
            }
          } else {
            return const LoginScreen();
          }
        });
  }
}
