import 'package:daily_habit_tracker/db_ops/habit_database.dart';
import 'package:daily_habit_tracker/dialogues/range_selector.dart';
import 'package:daily_habit_tracker/helper/date_parse.dart';
import 'package:daily_habit_tracker/widgets/habit_calendar.dart';
import 'package:daily_habit_tracker/widgets/habit_selector.dart';
import 'package:flutter/material.dart';
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
              ? Image.asset(
                  "assets/images/title/TitleBlack.png",
                  color: Colors.grey[900],
                )
              : Image.asset(
                  "assets/images/title/TitleWhite.png",
                  color: Colors.grey[200],
                ),
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

                // Consistency Overview
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 7,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.white,
                                    color: Colors.green,
                                    value: value.getCompletionPercentage(),
                                  ),
                                ),
                              ),
                              Text("Previous ${value.progressPercDispMode}"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 7,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.white,
                                    color: Colors.green,
                                    value: value.getCompletionsInCurrentWeek() /
                                        value.targetCompletionsPerWeek,
                                  ),
                                ),
                              ),
                              const Text("This Week"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    child: Row(
                      children: [
                        // The part covering the progress indicator on the left
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => const RangeSelector());
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),

                        // The part covering the progress indicator on the right
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ]),

                // Completion Checker for chosen date
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width - (2 * 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
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
                            "${selectedDate.day} ${getMonthFromNum(selectedDate.month)}, 2023",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
