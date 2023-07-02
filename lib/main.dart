import 'package:daily_habit_tracker/db_ops/habit_database.dart';
import 'package:daily_habit_tracker/pages/home.dart';
import 'package:daily_habit_tracker/theme/dark_theme.dart';
import 'package:daily_habit_tracker/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("HABIT_DATABASE");

  var habitDatabase = Hive.box("HABIT_DATABASE");
  if (habitDatabase.get("HABIT_LIST") == null) {
    HabitDatabase().createDefaultData();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HabitDatabase(),
      child: MaterialApp(
        title: 'Daily Habit Tracker',
        theme: myLightTheme,
        darkTheme: myDarkTheme,
        home: const HomePage(),
      ),
    );
  }
}
