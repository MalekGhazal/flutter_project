// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_project/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/theme/light_theme.dart';
import 'package:flutter_project/widgets/drawer.dart';
import 'package:flutter_project/screens/add_todo_screen.dart';
import 'package:flutter_project/widgets/todo_google_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/models/todo_model.dart';
import 'package:flutter_project/providers/todo_provider.dart';
import 'package:flutter_project/widgets/add_todo.dart';
import 'package:flutter_project/widgets/todo_list.dart';

enum TodoDataSource { local, google }

class TodosScreen extends StatefulWidget {
  final TodoDataSource dataSource;

  const TodosScreen({Key? key, this.dataSource = TodoDataSource.local})
      : super(key: key);

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  String activeTab = 'open';
  String? email;
  Stream<QuerySnapshot>? _openTasksStream;
  Stream<QuerySnapshot>? _closedTasksStream;
  bool loading = false;

  Future<void> toggleOpenTodo(Todo todo) async {
    // Determine the status change
    TodoStatus statusModified =
        todo.status == TodoStatus.open ? TodoStatus.closed : TodoStatus.open;

    // Update the todo status and check if it was successful
    bool updated = await Provider.of<TodoProvider>(context, listen: false)
        .toggleTodoStatus(todo, statusModified);

    // Default status message.
    String statusMessage = 'Error has occurred.';

    if (true == updated) {
      if (statusModified == TodoStatus.open) {
        statusMessage = 'Task opened.';
      }

      if (statusModified == TodoStatus.closed) {
        statusMessage = 'Task closed.';
      }

      // Reload both open and closed todos after the status change
      await Provider.of<TodoProvider>(context, listen: false).loadMore('open');
      await Provider.of<TodoProvider>(context, listen: false)
          .loadMore('closed');
    }

    // Display a Snackbar to show the status message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(statusMessage),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> toggleClosedTodo(Todo todo) async {
    TodoStatus statusModified =
        todo.status == TodoStatus.open ? TodoStatus.closed : TodoStatus.open;

    bool updated = await Provider.of<TodoProvider>(context, listen: false)
        .toggleTodoStatus(todo, statusModified);

    // Default status message.
    String statusMessage = 'Error has occurred.';

    if (true == updated) {
      if (statusModified == TodoStatus.open) {
        statusMessage = 'Task opened.';
      }

      if (statusModified == TodoStatus.closed) {
        statusMessage = 'Task closed.';
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(statusMessage),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void loadMore() async {
    // If we're already loading return early.
    if (loading) {
      return;
    }

    setState(() {
      loading = true;
    });

    // Loads more items in the activeTab.
    await Provider.of<TodoProvider>(context, listen: false).loadMore(activeTab);

    // If auth token has expired, widget is disposed and state is not set.
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  void showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddTodo(
          addTodo: (String title, String description, DateTime? dueDate) {
            // Call the addTodo method with the provided description.
            Provider.of<TodoProvider>(context, listen: false)
                .addTodo(title, description, dueDate);
          },
          dueDate: null,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.dataSource == TodoDataSource.google) {
      email = FirebaseAuth.instance.currentUser?.email;
      _openTasksStream = db
          .collection('tasks')
          .where("status", isEqualTo: "open")
          .where("user", isEqualTo: email)
          .snapshots();
      _closedTasksStream = db
          .collection('tasks')
          .where("status", isEqualTo: "closed")
          .where("user", isEqualTo: email)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dataSource == TodoDataSource.google) {
      return StreamBuilder<QuerySnapshot>(
        stream: _openTasksStream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
          return StreamBuilder<QuerySnapshot>(
            stream: _closedTasksStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
              if (snapshot1.connectionState == ConnectionState.waiting ||
                  snapshot2.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildUI(context, snapshot1, snapshot2);
            },
          );
        },
      );
    } else {
      final openTodos = Provider.of<TodoProvider>(context).openTodos;
      final closedTodos = Provider.of<TodoProvider>(context).closedTodos;
      return _buildUI(context, openTodos, closedTodos);
    }
  }

  Widget _buildUI(
      BuildContext context, dynamic openTodosData, dynamic closedTodosData) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const RedText('TODO List'),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Open'),
              Tab(text: 'Closed'),
            ],
            onTap: (int index) {
              setState(() {
                activeTab = index == 1 ? 'closed' : 'open';
              });
            },
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
          ),
        ),
        drawer: TodoDrawer(),
        body: TabBarView(
          children: [
            widget.dataSource == TodoDataSource.local
                ? todoList(context, openTodosData, toggleOpenTodo, loadMore,
                    TodoStatus.open)
                : todoGoogleList(openTodosData, context),
            widget.dataSource == TodoDataSource.local
                ? todoList(context, closedTodosData, toggleClosedTodo, loadMore,
                    TodoStatus.closed)
                : todoGoogleList(closedTodosData, context),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddTodoScreen(),
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
  }
}
