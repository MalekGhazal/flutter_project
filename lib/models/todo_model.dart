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
