import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TodoDrawer extends StatelessWidget {
  const TodoDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("your.email@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage("images/ProfilePlaceholder.png"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.check_box),
            title: const Text("To-Do List"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).pushReplacementNamed('/todos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: const Text("Weather"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).pushReplacementNamed('/weather');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.user),
            title: const Text("My Profile"),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).pushReplacementNamed('/profile');
            },
          ),
        ],
      ),
    );
  }
}
