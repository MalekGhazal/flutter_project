import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget todoGoogleList(AsyncSnapshot snapshot, BuildContext context) {
  Icon icon;

  return Material(
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
                onTap: () {},
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
                      Icon(Icons.delete,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 25.0),
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
