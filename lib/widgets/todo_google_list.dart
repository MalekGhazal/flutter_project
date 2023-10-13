import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget todoGoogleList(AsyncSnapshot snapshot) {
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
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: GestureDetector(
            onTap: () {
            
            },
            child: icon,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                ),
                const SizedBox(height: 8),
            ],
          ),
          subtitle: Text(
            data['description'],
            style: const TextStyle(
              fontSize: 16,
            ),
            
            ),
            enabled: true,
          isThreeLine: true,
          trailing: PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Text(
                  'Edit',
                  style: TextStyle(fontSize: 13.0),
                ),
              )
            ];
          }),
        ),
      );
    }).toList(),
  ));
}
