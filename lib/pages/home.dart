import 'package:daily_habit_tracker/db_ops/habit_database.dart';
import 'package:daily_habit_tracker/helper/date_parse.dart';
import 'package:daily_habit_tracker/widgets/habit_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    var _habitDatabase = Hive.box("HABIT_DATABASE");
    if (_habitDatabase.get("HABIT_LIST") == null) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Habit Tracker"),
        centerTitle: true,
      ),
      body: Consumer<HabitDatabase>(
        builder: (BuildContext context, value, Widget? child) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Habit Selector
                const HabitSelector(),

                // Heatmap Calendar
                HeatMapCalendar(
                  colorsets: const {
                    0: Colors.transparent,
                    1: Colors.green,
                  },
                  initDate: selectedDate,
                  colorMode: ColorMode.color,
                  textColor: Colors.black,
                  showColorTip: false,
                  fontSize: 12,
                  weekTextColor: Colors.grey[200],
                  datasets: value.getHabitDataset(),
                  onClick: (p0) {
                    setState(() {
                      selectedDate = DateTime(
                        p0.year,
                        p0.month,
                        p0.day,
                      );
                    });
                  },
                ),

                // Completion Checker for chosen date
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width - (2 * 15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 20, 20, 20),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Selected Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${selectedDate.day} ${getMonthFromNum(selectedDate.month)} 2023",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Completion Toggle
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Completed",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.grey[400]),
                            ),
                            Switch(
                              value: (selectedDate.isAfter(DateTime.now()))
                                  ? false
                                  : value.getCompletionStatus(selectedDate),
                              onChanged: selectedDate.isAfter(DateTime.now())
                                  ? null
                                  : (x) {
                                      value.toggleHabit(selectedDate);
                                    },
                            ),
                          ],
                        )
                      ],
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
