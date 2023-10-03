import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Primary",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              Text("Secondary",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ));
  }
}
