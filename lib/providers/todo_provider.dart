import 'package:flutter/material.dart';
import 'package:flutter_project/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  final bool _initialized = false;

  final List<Todo> _openTodos = [];
  final List<Todo> _closedTodos = [];

  bool get initialized => _initialized;
  List<Todo> get openTodos => _openTodos;
  List<Todo> get closedTodos => _closedTodos;

  Future<bool> toggleTodoStatus(Todo todo, TodoStatus statusModified) async {
    // Check if the task is already in the desired status, if yes, do nothing.
    if (todo.status == statusModified) {
      return false;
    }

    // Update the task status.
    todo.status = statusModified;

    // Move the task between open and closed lists.
    if (statusModified == TodoStatus.closed) {
      _openTodos.remove(todo);
      _closedTodos.add(todo);
    } else {
      _closedTodos.remove(todo);
      _openTodos.add(todo);
    }

    notifyListeners();
    return true;
  }

  Future<void> loadMore(String activeTab) async {
    // Simulate loading more data.
    await Future.delayed(const Duration(seconds: 1));

    notifyListeners();
  }

  Future<void> addTodo(
      String title, String description, DateTime? dueDate) async {
    // Simulate adding a new todo.
    Todo todo = Todo(
      title: title,
      description: description,
      status: TodoStatus.open,
      dueDate: dueDate,
    );
    _openTodos.insert(0, todo);
    notifyListeners();
  }

  Future<void> deleteTodo(Todo todo) async {
    // Remove the todo from the appropriate list (open or closed).
    if (todo.status == TodoStatus.open) {
      _openTodos.remove(todo);
    } else {
      _closedTodos.remove(todo);
    }
    notifyListeners();
  }
}
