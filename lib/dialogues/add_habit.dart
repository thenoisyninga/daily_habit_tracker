import 'package:daily_habit_tracker/db_ops/habit_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddHabit extends StatefulWidget {
  AddHabit({super.key});

  final TextEditingController _habitNameController = TextEditingController();
  String? habitNameError;

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Add New Habit",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Consumer<HabitDatabase>(
          builder: (BuildContext context, value, Widget? child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget._habitNameController,
              decoration: InputDecoration(
                errorText: widget.habitNameError,
                label: const Text("Habit Name"),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget._habitNameController.text.isEmpty) {
                  setState(() {
                    widget.habitNameError = "Can't be empty";
                  });
                } else if (value.habitList
                    .contains(widget._habitNameController.text)) {
                  setState(() {
                    widget.habitNameError = "Habit already exists";
                  });
                } else {
                  setState(() {
                    widget.habitNameError = null;
                  });
                }

                if (widget.habitNameError == null) {
                  value.addHabit(widget._habitNameController.text);
                  Navigator.of(context).pop(context);
                }
                // value.createDefaultData();
              },
              child: const Text("Add Habit"),
            ),
          ],
        );
      }),
    );
  }
}
