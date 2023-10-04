// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/models/todo_model.dart';
import 'package:flutter_project/providers/todo_provider.dart';
import 'package:flutter_project/widgets/add_todo.dart';
import 'package:flutter_project/widgets/drawer.dart';
import 'package:flutter_project/widgets/todo_list.dart';
import 'package:flutter_project/screens/add_todo_screen.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  TodosState createState() => TodosState();
}

class TodosState extends State<TodosScreen> {
  bool loading = false; // Indicates whether data is loading
  String activeTab = 'open'; // Tracks the active tab (open or closed)

  // Function to toggle the status of an open todo
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

  // Function to toggle the status of a closed todo
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

  // Function to load more todo items
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

  // Function to show the add task sheet
  void showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddTodo(
          addTodo: (String title, String description) {
            // Call the addTodo method with the provided description.
            Provider.of<TodoProvider>(context, listen: false)
                .addTodo(title, description);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final openTodos = Provider.of<TodoProvider>(context).openTodos;
    final closedTodos = Provider.of<TodoProvider>(context).closedTodos;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('To Do List'),
          bottom: TabBar(
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
          ),
        ),
        drawer: const TodoDrawer(), // Adding a drawer to the screen
        body: TabBarView(
          children: [
            todoList(context, openTodos, toggleOpenTodo, loadMore,
                TodoStatus.open), // Displaying the list of open todos
            todoList(context, closedTodos, toggleClosedTodo, loadMore,
                TodoStatus.closed), // Displaying the list of closed todos
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
          label: const Text('Create Todo'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
