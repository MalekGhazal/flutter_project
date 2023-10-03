import 'package:flutter/material.dart';
import 'package:flutter_project/services/authentication.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("Profile"),
        ),
        body: Center(
          child: ElevatedButton(
                  onPressed: () async {
                    await AuthService().signOut();
                  },
                  child: const Text("Sign out"))
        )
      );
  }
}