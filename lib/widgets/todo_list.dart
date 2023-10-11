import 'package:flutter/material.dart';
import 'package:flutter_project/models/todo_model.dart';
import 'package:intl/intl.dart';

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

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: GestureDetector(
            onTap: () {
              toggleTodo(todo);
            },
            child: icon,
          ),
          title: Text(
            todo.title ?? 'Default Title',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Container(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              todo.description ?? 'Default Description',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          trailing: todo.dueDate != null
              ? Text(
                  'Due: ${DateFormat('MM/dd/yyyy').format(todo.dueDate!)}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                  ),
                )
              : null,
          enabled: true,
        ),
      );
    },
    separatorBuilder: (context, index) => const Divider(
      color: Colors.black38,
    ),
  );
}
