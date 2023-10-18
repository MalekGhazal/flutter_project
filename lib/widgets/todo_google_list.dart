import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/services/firestore.dart';

void updateTodoStatus(DocumentReference reference, String newStatus) async {
  await reference.update({
    "status": newStatus,
  });
}

Widget todoGoogleList(AsyncSnapshot snapshot, BuildContext context) {
  Icon icon;

  Future deleteTask(id) async {
  db.collection('tasks').doc(id).delete(); 
}

  Future<void> confirmDelete(id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Text(
                'Confirm Delete',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFBD5F5F)),
              ),
            ],
          ),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteTask(id);// Call the deleteTodo function
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  return Material(
      color: Theme.of(context).colorScheme.background,
      child: ListView(
        children: snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          if (data['status'] == "open") {
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
                      String newStatus =
                          data['status'] == "open" ? "closed" : "open";
                      updateTodoStatus(document.reference, newStatus);
                    },
                    child: icon,
                  ),
                  title: Text(
                    data['title'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      data['description'],
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
                      Text(
                        'Due: ${data['dueDate']}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit,
                              color: Theme.of(context).colorScheme.background,
                              size: 25.0),
                          const SizedBox(width: 20.0),
                          GestureDetector(
                            onTap: () {
                              String taskId = data['id'];
                              confirmDelete(taskId); // Call the confirmDelete function
                            },
                            child: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 25.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  enabled: true,
                ),
              ));
        }).toList(),
      ));
}
