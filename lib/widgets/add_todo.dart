// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  final Function(String, String, DateTime?) addTodo;
  final DateTime? dueDate;

  const AddTodo({
    required this.addTodo,
    required this.dueDate,
    Key? key,
  }) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: TextField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: 'Title'),
            controller: titleController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: null,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(hintText: 'Description'),
            controller: descriptionController,
          ),
        ),
        ButtonBar(
          children: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final title = titleController.text;
                final description = descriptionController.text;
                final dueDate = widget.dueDate; // Get the dueDate from widget
                widget.addTodo(
                  title,
                  description,
                  dueDate,
                ); // Call the 'addTodo' function
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
