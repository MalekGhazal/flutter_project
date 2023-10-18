// Define an enum to represent the status of a Todo
enum TodoStatus {
  open,
  closed,
}

/// Represents a single todo item.
///
/// Each todo has a title, description, status, and due date. The `Todo` class provides
/// methods to serialize from and to JSON format, which can be useful for storing the data or
/// communicating with an API.
///
/// Attributes:
/// - `title`: Title of the todo.
/// - `description`: Description or details about the todo.
/// - `status`: Indicates whether the todo is open or closed.
/// - `dueDate`: Specifies when the todo is due.
///
/// Usage:
/// ```dart
/// Todo newTodo = Todo(
///   title: "Finish homework",
///   description: "Math homework chapter 5",
///   status: TodoStatus.open,
///   dueDate: DateTime.now().add(Duration(days: 2)),
/// );
/// String title = newTodo.title;  // Access the title of the todo
/// TodoStatus status = newTodo.status;  // Access the status of the todo
/// ```
/// For serialization and deserialization:
/// ```dart
/// Map<String, dynamic> json = newTodo.toJson();  // Serialize to JSON
/// Todo todoFromJson = Todo.fromJson(json);  // Deserialize from JSON
/// ```

// Define a class to represent a Todo item
class Todo {
  String? title;
  String? description;
  TodoStatus status;
  DateTime? dueDate;

  // Constructor for creating a Todo
  Todo({
    this.title,
    this.description,
    required this.status,
    this.dueDate,
  });

  // Factory method to create a Todo object from JSON data
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json["title"],
      description: json["description"],
      // Map the "status" field from JSON to the TodoStatus enum
      status: json["status"] == "closed" ? TodoStatus.closed : TodoStatus.open,
      dueDate: json["dueDate"] != null
          ? DateTime.parse(json["dueDate"])
          : null, // Parse dueDate from JSON
    );
  }

  // Convert a Todo object to a JSON representation
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "title": title,
      "description": description,
      // Map the TodoStatus enum to a string for JSON
      "status": status == TodoStatus.closed ? "closed" : "open",
      "dueDate": dueDate != null
          ? dueDate!.toIso8601String()
          : null, // Convert dueDate to ISO 8601 string
    };
    return data;
  }
}
