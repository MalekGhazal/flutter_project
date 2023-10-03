import 'dart:convert';

enum TodoStatus {
  open,
  closed,
}

class Todo {
  String? title;
  String? description;
  TodoStatus status;

  Todo({
    this.title,
    this.description,
    required this.status,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json["title"],
      description: json["description"],
      status: json["status"] == "closed" ? TodoStatus.closed : TodoStatus.open,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "title": title,
      "description": description,
      "status": status == TodoStatus.closed ? "closed" : "open",
    };
    return data;
  }
}

List<Todo> todoListFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Todo>.from(jsonData.map((x) => Todo.fromJson(x)));
}

String todoListToJson(List<Todo> data) {
  final List<dynamic> jsonData = data.map((x) => x.toJson()).toList();
  return json.encode(jsonData);
}
