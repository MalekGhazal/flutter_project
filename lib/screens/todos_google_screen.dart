import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/theme/light_theme.dart';
import 'package:flutter_project/widgets/drawer.dart';
import 'package:flutter_project/screens/add_todo_screen.dart';
import 'package:flutter_project/widgets/todo_google_list.dart';

final email = FirebaseAuth.instance.currentUser?.email;

class TodosGoogleScreen extends StatefulWidget {
  const TodosGoogleScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodosGoogleScreen createState() => _TodosGoogleScreen();
}

class _TodosGoogleScreen extends State<TodosGoogleScreen> {
  bool loading = false; // Indicates whether data is loading
  String activeTab = 'open';

  final Stream<QuerySnapshot> _openTasksStream = db
      .collection('tasks')
      .where("status", isEqualTo: "open")
      .where("user", isEqualTo: email.toString())
      .snapshots();
  final Stream<QuerySnapshot> _closedTasksStream = db
      .collection('tasks')
      .where("status", isEqualTo: "closed")
      .where("user", isEqualTo: email.toString())
      .snapshots();
    

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _openTasksStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
        return StreamBuilder<QuerySnapshot>(
            stream: _closedTasksStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
              if (snapshot1.connectionState == ConnectionState.waiting || snapshot2.connectionState == ConnectionState.waiting) {
                return const Text("Loading", style: TextStyle(fontSize: 13.0));
              }
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  appBar: AppBar(
                    title: const RedText('TODO List'),
                    centerTitle: true,
                    bottom: TabBar(
                      labelColor: Theme.of(context).colorScheme.primary,
                      // Add the TabBar widget for switching tabs
                      tabs: const [
                        Tab(text: 'Open'),
                        Tab(text: 'Closed'),
                      ],
                      onTap: (int index) {
                        setState(() {
                          activeTab = index == 1 ? 'closed' : 'open';
                        });
                      },
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                      unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16.0),
                    ),
                  ),

                  drawer: TodoDrawer(), // Adding a drawer to the screen
                  body: TabBarView(
                    children: [
                      todoGoogleList(snapshot1),
                      todoGoogleList(snapshot2)
                    ],
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddTodoScreen(), // Navigating to the AddTodoScreen
                        ),
                      );
                    },
                    label: const WhiteText('Create Todo'),
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
