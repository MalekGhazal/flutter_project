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

  //Function to delete a task from Firestore
  Future deleteTask(id) async {
    db.collection('tasks').doc(id).delete();
  }

  //Function to display a confirmation dialog before deleting a task
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
                deleteTask(id); // Call the deleteTodo function
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
                          GestureDetector(
                            onTap: () {
                              String taskId = (data['id']);
                              String taskName = (data['title']);
                              String taskDesc = (data['description']);
                              String taskDueDate = (data['dueDate']);
                              Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                  context: context,
                                  builder: (context) => UpdateTaskAlertDialog(
                                      taskId: taskId,
                                      taskName: taskName,
                                      taskDesc: taskDesc,
                                      taskDueDate: taskDueDate),
                                ), // Call the showDialog function to display the edit task dialog box
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.background,
                              size: 25.0,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          GestureDetector(
                            onTap: () {
                              String taskId = data['id'];
                              confirmDelete(
                                  taskId); // Call the confirmDelete function
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

class UpdateTaskAlertDialog extends StatefulWidget {
  final String taskId, taskName, taskDesc, taskDueDate;

  const UpdateTaskAlertDialog(
      {Key? Key,
      required this.taskId,
      required this.taskName,
      required this.taskDesc,
      required this.taskDueDate})
      : super(key: Key);

  @override
  State<UpdateTaskAlertDialog> createState() => _UpdateTaskAlertDialogState();
}

class _UpdateTaskAlertDialogState extends State<UpdateTaskAlertDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? dueDate;

  //Function to assign the selected date to the "dueDate" variable
  Future<void> selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.taskName;
    descriptionController.text = widget.taskDesc;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Text(
            'Edit Todo',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF203D4E)),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          Row(
            children: [
              Text(
                'Due date:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (dueDate != null
                        ? dueDate!.toLocal().toString().split(' ')[0]
                        : widget.taskDueDate),
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              VerticalDivider(
                width: 5,
                color: Theme.of(context).colorScheme.primary,
              ),
              GestureDetector(
                onTap: () {
                  selectDueDate(context);
                },
                child: Icon(
                  Icons.calendar_month_outlined,
                  size: 25,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            validateAndSubmitTodo();
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }

  //Function to validate text and date fields input and submit the edit
  void validateAndSubmitTodo() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title.'),
        ),
      );
      return;
    }

    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a description.'),
        ),
      );
      return;
    }

    final taskName = titleController.text;
    final taskDesc = descriptionController.text;
    final String taskDueDate = dueDate != null
        ? dueDate!.toLocal().toString().split(' ')[0]
        : widget.taskDueDate;
    _updateTasks(taskName, taskDesc, taskDueDate);
  }

  //Function to update a task in Firestore
  Future _updateTasks(
      String taskName, String taskDesc, String taskDueDate) async {
    var collection = db.collection('tasks');
    collection.doc(widget.taskId).update(
        {'title': taskName, 'description': taskDesc, 'dueDate': taskDueDate});
  }

  //Dispose the controllers
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
