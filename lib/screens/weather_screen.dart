import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/drawer.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      drawer: const TodoDrawer(), // Use your existing TodoDrawer here
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