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
    if (todo.status == statusModified) {
      return false;
    }

    todo.status = statusModified;

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
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  Future<void> addTodo(
    String title,
    String description,
    DateTime? dueDate,
  ) async {
    Todo todo = Todo(
      title: title,
      description: description,
      status: TodoStatus.open,
      dueDate: dueDate,
    );
    _openTodos.insert(0, todo);
    notifyListeners();
  }

  Future<void> editTodo(
    Todo todo,
    String newTitle,
    String newDescription,
    DateTime? newDueDate,
  ) async {
    if (todo.title == newTitle &&
        todo.description == newDescription &&
        todo.dueDate == newDueDate) {
      return;
    }

    todo.title = newTitle;
    todo.description = newDescription;
    todo.dueDate = newDueDate;

    notifyListeners();
  }

  Future<void> deleteTodo(Todo todo) async {
    if (todo.status == TodoStatus.open) {
      _openTodos.remove(todo);
    } else {
      _closedTodos.remove(todo);
    }
    notifyListeners();
  }
}
