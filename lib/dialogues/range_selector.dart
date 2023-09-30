import 'package:daily_habit_tracker/db_ops/habit_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RangeSelector extends StatelessWidget {
  const RangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitDatabase>(builder: (context, value, Widget? child) {
      List<String> progressDisplayModes = value.getProgressPercModesList();

      return AlertDialog(
          title: const Text(
            "Select Range",
            style: TextStyle(fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: (MediaQuery.of(context).size.height * 0.3),
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.builder(
              itemCount: progressDisplayModes.length,
              itemBuilder: ((context, index) => ElevatedButton(
                    onPressed: () {
                      value.setProgressPercDispMode(
                          progressDisplayModes[index].toString());
                      // Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: progressDisplayModes[index] ==
                              value.progressPercDispMode
                          ? Colors.green[800]
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    child: Text(
                      progressDisplayModes[index].toString(),
                    ),
                  )),
            ),
          ));
    });
  }
}
