import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/services/authentication.dart';
import 'package:flutter_project/theme/light_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/add_todo_screen.dart';

class TodoDrawer extends StatelessWidget {
  TodoDrawer({super.key});

  final user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser?.email;
  final name = FirebaseAuth.instance.currentUser?.displayName;
 
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              (name != null ? name.toString() : "Anonymous user"),
                style: const TextStyle(fontWeight: FontWeight.w700)),
            accountEmail: Text(
              (email != null ? email.toString() : ""),),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage:
                  AssetImage("assets/images/ProfilePlaceholder.png"),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.check_box,
              color: Theme.of(context).colorScheme.background,
            ),
            title: const WhiteText("To-Do List"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).pushReplacementNamed('/todos');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.cloud,
              color: Theme.of(context).colorScheme.background,
            ),
            title: const WhiteText("Weather"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).pushReplacementNamed('/weather');
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.user,
              color: Theme.of(context).colorScheme.background,
            ),
            title: const WhiteText("My Profile"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).pushReplacementNamed('/profile');

            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.plus,
              color: Theme.of(context).colorScheme.background,
            ),
            title: const WhiteText("New Item"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const AddTodoScreen(), // Navigating to the AddTodoScreen
                ),
              );
            },
          ),
          Divider(
            height: 20,
            color: Theme.of(context).colorScheme.background,
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.rightFromBracket,
              color: Theme.of(context).colorScheme.background,
            ),
            title: const WhiteText("Sign out"),
            onTap: () async {
              await AuthService().signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
