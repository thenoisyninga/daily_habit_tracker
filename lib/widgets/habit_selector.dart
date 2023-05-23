import 'package:daily_habit_tracker/db_ops/habit_database.dart';
import 'package:daily_habit_tracker/dialogues/manage_habits.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HabitSelector extends StatefulWidget {
  const HabitSelector({super.key});

  @override
  State<HabitSelector> createState() => _HabitSelectorState();
}

class _HabitSelectorState extends State<HabitSelector> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HabitDatabase>(
      builder: (BuildContext context, value, Widget? child) {
        return Container(
          alignment: Alignment.center,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Choose Habit
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      padding: const EdgeInsets.all(8),
                      value: value.selectedHabit,
                      items: List.generate(
                        value.habitList.length,
                        (index) {
                          String habitName = value.habitList[index];
                          return DropdownMenuItem(
                            value: habitName,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.51,
                              child: Text(
                                habitName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      onChanged: (selectedHabit) {
                        if (selectedHabit != null) {
                          setState(() {
                            value.changeSelectedHabit(selectedHabit);
                          });
                        }
                      },
                    ),
                  ),

                  // Add Habit Button
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const ManageHabits(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
