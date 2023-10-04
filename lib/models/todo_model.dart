import 'dart:convert';

// Define an enum to represent the status of a Todo
enum TodoStatus {
  open,
  closed,
}

// Define a class to represent a Todo item
class Todo {
  String? title;
  String? description;
  TodoStatus status;

  // Constructor for creating a Todo
  Todo({
    this.title,
    this.description,
    required this.status,
  });

  // Factory method to create a Todo object from JSON data
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json["title"],
      description: json["description"],
      // Map the "status" field from JSON to the TodoStatus enum
      status: json["status"] == "closed" ? TodoStatus.closed : TodoStatus.open,
    );
  }

  // Convert a Todo object to a JSON representation
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "title": title,
      "description": description,
      // Map the TodoStatus enum to a string for JSON
      "status": status == TodoStatus.closed ? "closed" : "open",
    };
    return data;
  }
}

// Convert a JSON string to a list of Todo objects
List<Todo> todoListFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Todo>.from(jsonData.map((x) => Todo.fromJson(x)));
}

// Convert a list of Todo objects to a JSON string
String todoListToJson(List<Todo> data) {
  final List<dynamic> jsonData = data.map((x) => x.toJson()).toList();
  return json.encode(jsonData);
}
