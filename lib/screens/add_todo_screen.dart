import 'package:flutter/material.dart';
import 'package:flutter_project/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/providers/todo_provider.dart';
import 'package:flutter_project/widgets/drawer.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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
      drawer: const TodoDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Title",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18.0),
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
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Description",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18.0),
                Container(
                  constraints: const BoxConstraints(minHeight: 100),
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
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30.0,
            child: Center(
              child: SizedBox(
                width: 150.0,
                child: ElevatedButton(
                  onPressed: submitTodo,
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
                  child: Text('Submit',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ],
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
