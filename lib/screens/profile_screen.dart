// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/drawer.dart';
import 'package:flutter_project/services/authentication.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      drawer: const TodoDrawer(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: CircleAvatar(
                radius: 80.0,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('images/ProfilePlaceholder.png'),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Your Name',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'your.email@example.com',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
