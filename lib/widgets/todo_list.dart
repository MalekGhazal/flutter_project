import 'package:flutter/material.dart';
import 'package:flutter_project/models/todo_model.dart';

Widget todoList(
  BuildContext context,
  List<Todo> todos,
  Function(Todo) toggleTodo,
  Function() loadMore,
  TodoStatus status, // Add status parameter
) {
  ScrollController scrollController = ScrollController();

  scrollController.addListener(() {
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      loadMore();
    }
  });

  // Filter todos based on status
  final filteredTodos = todos.where((todo) => todo.status == status).toList();

  return ListView.separated(
    controller: scrollController,
    itemCount: filteredTodos.length, // Use filtered todos
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.title ?? 'Default Title',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          subtitle: Text(
            todo.description ?? 'Default Description',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          enabled: true,
        ),
      );
    },
    separatorBuilder: (context, index) => const Divider(
      color: Colors.black38,
    ),
  );
}
