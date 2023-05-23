import 'package:daily_habit_tracker/db_ops/habit_database.dart';
import 'package:daily_habit_tracker/dialogues/add_habit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageHabits extends StatefulWidget {
  const ManageHabits({super.key});

  @override
  State<ManageHabits> createState() => _ManageHabitsState();
}

class _ManageHabitsState extends State<ManageHabits> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Manage Habits",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Consumer<HabitDatabase>(
        builder: (BuildContext context, value, Widget? child) {
          return SizedBox(
            height: 380,
            width: 200,
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  width: 200,
                  child: ListView.builder(
                    itemCount: value.habitList.length,
                    itemBuilder: (context, index) => HabitTile(
                      habitName: value.habitList[index],
                      habitCount: value.habitList.length,
                      onDelete: () {
                        value.removeHabit(value.habitList[index]);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AddHabit(),
                  ),
                  child: const SizedBox(
                    child: SizedBox(
                      height: 60,
                      width: 180,
                      child: Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habitName,
    required this.onDelete,
    required this.habitCount,
  });

  final String habitName;
  final void Function()? onDelete;
  final int habitCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 200,
        height: 60,
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  habitName,
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
              ),
              habitCount > 1
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                                "Are you sure you want to delete the habbit $habitName? This action is irreversable."),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  onDelete!();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Yes"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("No"),
                              )
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
