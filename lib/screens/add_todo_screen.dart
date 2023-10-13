import 'package:flutter/material.dart';
import 'package:flutter_project/services/firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/providers/todo_provider.dart';
import 'package:flutter_project/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

///Class to handle how a ToDo is added, depending if the user is logged anonymously or with a Google account
class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final email = FirebaseAuth.instance.currentUser?.email;

  void submitTodo() {
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      // Only pass the description as a String
      Provider.of<TodoProvider>(context, listen: false).addTodo(
        title,
        description,
      );

      // Navigate back to the previous screen (TodosScreen)
      Navigator.pop(context);
    }
  }
  //Handle a ToDo added by a Google user
  void submitUserTodo(){
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();
    final String user = email.toString();
    
    final task = <String, dynamic>{
      "title" : title,
      "description": description,
      "user": user,
      "dueDate": "12/10/2023",
      "status": "open"
    };

    db.collection("tasks").add(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Add back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      drawer: TodoDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              
              onPressed: () => 
              (email != null ? submitUserTodo() :  submitTodo()),
              
              child: const Text('Submit'),
            ),
          ],
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
