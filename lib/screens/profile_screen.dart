import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      drawer: const TodoDrawer(),
      body: const Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: CircleAvatar(
                radius: 80.0,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('images/ProfilePlaceholder.png'),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Your Name',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'your.email@example.com',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
