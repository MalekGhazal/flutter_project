// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/drawer.dart';
import 'package:flutter_project/services/authentication.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      drawer: const TodoDrawer(), // Adding a drawer to the screen
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
                backgroundImage: AssetImage(
                    'assets/images/ProfilePlaceholder.png'), // Displaying placeholder profile image
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Username',
              style: TextStyle(
                  fontSize: 26.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'user.email@example.com',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Text(
              "Joined 2DO On:",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 23,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
                "${user?.metadata.creationTime?.day}/${user?.metadata.creationTime?.month}/${user?.metadata.creationTime?.year}",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut(); // Triggering sign-out action
                Navigator.pushReplacementNamed(context,
                    '/'); // Navigating to the login screen after sign-out
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                ),
              ),
              child: Text(
                "Sign out",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
