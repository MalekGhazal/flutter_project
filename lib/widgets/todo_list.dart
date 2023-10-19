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
                    : Container(width: 1),
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
  DateTime? dueDate;

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

  @override
  void initState() {
    super.initState();
    titleController.text = widget.todo.title ?? '';
    descriptionController.text = widget.todo.description ?? '';
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
          Row(
            children: [
              Text(
                'Due date:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (dueDate != null 
                    ? dueDate!.toLocal().toString().split(' ')[0]
                    : widget.todo.dueDate!.toLocal().toString().split(' ')[0]),
                    style: TextStyle(
                      fontSize: 15,
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
                  size: 25,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
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
            validateAndSubmitTodo();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  //Function to validate text and date fields input and submit the edit
  void validateAndSubmitTodo() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please ensure the new title is not empty.'),
        ),
      );
      return;
    }

    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please ensure the new description is not empty.'),
        ),
      );
      return;
    }

    DateTime? newDate;
            dueDate != null
              ? newDate = dueDate
              : newDate = widget.todo.dueDate;
            widget.editTodo(
              titleController.text,
              descriptionController.text,
              newDate,
            );
  }

   //Dispose the controllers
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
