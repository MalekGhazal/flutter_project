// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DatePickerWidget({super.key, required this.onDateSelected});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ))!;
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateSelected(picked); // Notify the parent with the selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          selectedDate == null
              ? 'Select a Due Date'
              : 'Due Date: ${selectedDate!.toLocal()}'.split(' ')[0],
          style: const TextStyle(fontSize: 20),
        ),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: const Text('Select Due Date'),
        ),
      ],
    );
  }
}
