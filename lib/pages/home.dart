import 'package:daily_habit_tracker/db_ops/habit_database.dart';
import 'package:daily_habit_tracker/helper/date_parse.dart';
import 'package:daily_habit_tracker/widgets/habit_calendar.dart';
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
  @override
  void initState() {
    var habitDatabase = Hive.box("HABIT_DATABASE");
    if (habitDatabase.get("HABIT_LIST") == null) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SizedBox(
          height: 40,
          child: Theme.of(context).colorScheme.brightness == Brightness.light
              ? Image.asset("assets/images/title/TitleBlack.png", color: Colors.grey[900],)
              : Image.asset("assets/images/title/TitleWhite.png", color: Colors.grey[200],),
        ),
        centerTitle: true,
      ),
      body: Consumer<HabitDatabase>(
        builder: (BuildContext context, value, Widget? child) {
          DateTime selectedDate = value.getSelectedDate();
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Habit Selector
                const HabitSelector(),

                // Habit Calendar
                const HabitCalendar(),

                // Completion Checker for chosen date
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width - (2 * 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
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
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
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
                                fontSize: 17,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondary
                                    .withAlpha(180),
                              ),
                            ),
                            Switch(
                              activeColor: Colors.green,
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
