import 'package:flutter/material.dart';
import 'package:flutter_project/theme/light_theme.dart';
import 'package:flutter_project/widgets/drawer.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const RedText('Weather Today'),
        centerTitle: true, // Setting the title of the app bar
      ),
      drawer: const TodoDrawer(), // Adding a drawer to the screen
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.cloud,
              size: 100.0,
              color: Colors.blue,
            ),
            SizedBox(height: 16.0),
            Text(
              'Current Weather',
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
