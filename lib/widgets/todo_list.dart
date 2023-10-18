// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_project/models/todo_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project/providers/todo_provider.dart';
import 'package:provider/provider.dart';

Widget todoList(
  BuildContext context,
  List<Todo> todos,
  Function(Todo) toggleTodo,
  Function() loadMore,
  TodoStatus status,
) {
  ScrollController scrollController = ScrollController();

  scrollController.addListener(() {
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      loadMore();
    }
  });

  final filteredTodos = todos.where((todo) => todo.status == status).toList();

  void deleteTodo(Todo todo) {
    Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo);
  }

  Future<void> confirmDelete(Todo todo) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Text(
                'Confirm Delete',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFBD5F5F)),
              ),
            ],
          ),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteTodo(todo); // Call the deleteTodo function
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context, Todo todo) async {
    await showDialog(
      context: context,
      builder: (context) {
        return EditTodoDialog(
          todo: todo,
          editTodo: (String title, String description, DateTime? dueDate) {
            Provider.of<TodoProvider>(context, listen: false).editTodo(
              todo,
              title,
              description,
              dueDate,
            );
          },
        );
      },
    );
  }

  return ListView.separated(
    controller: scrollController,
    itemCount: filteredTodos.length,
    itemBuilder: (BuildContext context, int index) {
      final todo = filteredTodos[index];
      Icon icon;

      if (todo.status == TodoStatus.open) {
        icon = const Icon(
          Icons.radio_button_off,
          color: Colors.grey,
        );
      } else {
        icon = const Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      }

      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 8.0,
              ),
            ],
          ),
          child: ListTile(
            leading: GestureDetector(
              onTap: () {
                toggleTodo(todo);
              },
              child: icon,
            ),
            title: Text(
              todo.title ?? 'Default Title',
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Container(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                todo.description ?? 'Default Description',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 16,
                ),
              ),
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                todo.dueDate != null
                    ? Text(
                        'Due: ${DateFormat('MM/dd/yyyy').format(todo.dueDate!)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 13,
                        ),
                      )
                    : Container(),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showEditDialog(
                            context, todo); // Call the _showEditDialog function
                      },
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.background,
                        size: 25.0,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    GestureDetector(
                      onTap: () {
                        confirmDelete(todo); // Call the confirmDelete function
                      },
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 25.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            enabled: true,
          ),
        ),
      );
    },
    separatorBuilder: (context, index) => const SizedBox(height: 8.0),
  );
}

class EditTodoDialog extends StatefulWidget {
  final Todo todo;
  final Function(String, String, DateTime?) editTodo;

  const EditTodoDialog({
    Key? key,
    required this.todo,
    required this.editTodo,
  }) : super(key: key);

  @override
  _EditTodoDialogState createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController = TextEditingController(); // Add this controller

  @override
  void initState() {
    super.initState();
    titleController.text = widget.todo.title ?? '';
    descriptionController.text = widget.todo.description ?? '';
    dueDateController.text = widget.todo.dueDate != null
        ? DateFormat('MM/dd/yyyy').format(widget.todo.dueDate!)
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Text(
            'Edit Todo',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF203D4E)),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: dueDateController, // Add this controller
            decoration:
                const InputDecoration(labelText: 'Due Date (MM/dd/yyyy)'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            DateTime? dueDate;
            final dueDateText = dueDateController.text;
            if (dueDateText.isNotEmpty) {
              dueDate = DateFormat('MM/dd/yyyy').parse(dueDateText);
            }

            widget.editTodo(
              titleController.text,
              descriptionController.text,
              dueDate,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
