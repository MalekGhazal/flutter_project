import 'package:flutter/material.dart';
import 'package:flutter_project/models/todo_model.dart';

/// `TodoProvider` is a state management class using the `ChangeNotifier` mixin from Flutter's Provider package.
///
/// The class manages a list of todos, separating them into two categories: open and closed. It provides methods
/// to add, modify, delete, toggle the status of, and simulate the loading of todos.
///
/// Attributes:
/// - `_initialized`: A flag indicating whether the provider has been initialized.
/// - `_openTodos`: A list of todos that are in the "open" status.
/// - `_closedTodos`: A list of todos that are in the "closed" status.
///
/// Key methods:
/// - `toggleTodoStatus`: Allows toggling the status of a todo between open and closed.
/// - `loadMore`: Simulates the loading of more todos (for pagination or infinite scroll scenarios).
/// - `addTodo`: Adds a new todo to the list of open todos.
/// - `editTodo`: Edits the details of an existing todo.
/// - `deleteTodo`: Removes a todo from the list.
///
/// Usage:
/// ```dart
/// TodoProvider todoProvider = TodoProvider();
/// todoProvider.addTodo("Go shopping", "Buy groceries", DateTime.now().add(Duration(days: 2)));
/// List<Todo> openTasks = todoProvider.openTodos;  // Access the list of open todos
/// ```
/// With the Provider package in Flutter:
/// ```dart
/// ChangeNotifierProvider(
///   create: (context) => TodoProvider(),
///   child: YourWidget(),
/// )
/// ```
/// In a widget to get the provider:
/// ```dart
/// TodoProvider todoProvider = Provider.of<TodoProvider>(context);
/// ```

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
