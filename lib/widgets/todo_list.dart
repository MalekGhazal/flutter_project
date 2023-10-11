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
                    Icon(Icons.edit,
                        color: Theme.of(context).colorScheme.background,
                        size: 25.0),
                    const SizedBox(width: 20.0),
                    Icon(Icons.delete,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 25.0),
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
