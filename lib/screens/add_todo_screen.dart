// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_project/services/firestore.dart';
import 'package:flutter_project/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/providers/todo_provider.dart';
import 'package:flutter_project/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// `AddTodoScreen` is a stateful widget that provides an interface to add a new todo item.
///
/// Users can input the title, description, and select a due date for their todo. The widget offers
/// validation for each input, ensuring that they are not empty before submission. Upon successful
/// validation, the todo is either added to Firestore (for authenticated users with a Google account)
/// or stored locally (for anonymous users).
///
/// Key Functionalities:
/// 1. Input for todo's title and description.
/// 2. Date picker to select the todo's due date.
/// 3. Validation to ensure every input field is filled.
/// 4. Data submission to Firestore for authenticated users or local storage for anonymous users.
/// 5. Feedback to the user upon successful addition or error through snack bars.
///
/// Dependencies:
/// - `firestore.dart`: Service to interact with Firestore.
/// - `light_theme.dart`: For the app's light theme colors and styles.
/// - `todo_provider.dart`: Provider for CRUD operations on todos.
/// - `drawer.dart`: Represents the drawer widget used in this screen.
/// - `firebase_auth.dart`: Firebase authentication package.
///
/// Usage:
/// ```dart
/// AddTodoScreen()
/// ```
///
/// This widget enhances the user experience by ensuring data integrity and providing feedback, making
/// the todo addition process seamless.

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final email = FirebaseAuth.instance.currentUser?.email;
  DateTime? dueDate; // Store the selected due date

  //Function to assign the selected date to the "dueDate" variable
  Future<void> selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  //Function to validate text and date fields input
  void validateAndSubmitTodo() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title.'),
        ),
      );
      return;
    }

    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a description.'),
        ),
      );
      return;
    }

    if (dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a due date.'),
        ),
      );
      return;
    }

    if (email != null) {
      _submitUserTodoToFirestore();
    } else {
      _submitUserTodoLocally();
    }
  }

  void _submitUserTodoLocally() {
    Provider.of<TodoProvider>(context, listen: false).addTodo(
      titleController.text.trim(),
      descriptionController.text.trim(),
      dueDate,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todo added successfully.'),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> _submitUserTodoToFirestore() async {
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();
    final String user = email.toString();
    final String? due = dueDate?.toLocal().toString().split(' ')[0];

    final task = <String, dynamic>{
      "title": title,
      "description": description,
      "user": user,
      "dueDate": due,
      "status": "open"
    };

    try {
      DocumentReference docRef = await db.collection('tasks').add(task);
      String taskId = docRef.id;
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update(
        {'id': taskId},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todo added successfully.'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error adding todo. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const RedText('Add New TODO'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: TodoDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Text
              Text(
                "Title",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18.0),

              // Title TextField
              TextField(
                controller: titleController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 16.0,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Enter your title here',
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                cursorColor: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 16.0),

              // Description Text
              Text(
                "Description",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18.0),

              // Description TextField
              Container(
                constraints: const BoxConstraints(minHeight: 50),
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 16.0,
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Enter your description here',
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  cursorColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 35.0),
              Row(
                children: [
                  Text(
                    'Due date:',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  if (dueDate != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dueDate!.toLocal().toString().split(' ')[0],
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  VerticalDivider(
                    width: 5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  GestureDetector(
                    onTap: () {
                      selectDueDate(context);
                    },
                    child: Icon(
                      Icons.calendar_month_outlined,
                      size: 45,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50.0),

              // Submit Button
              Center(
                child: SizedBox(
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: validateAndSubmitTodo,
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
                        const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
