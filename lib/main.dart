import 'package:daily_habit_tracker/db_ops/habit_database.dart';
import 'package:daily_habit_tracker/pages/home.dart';
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
    Color? primaryColor = Colors.green;
    Color? scaffoldBackgroundColor = Colors.grey[900];
    return ChangeNotifierProvider(
      create: (BuildContext context) => HabitDatabase(),
      child: MaterialApp(
        title: 'Daily Habit Tracker',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[900],
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: primaryColor,
            onPrimary: Colors.white,
            secondary: primaryColor.withAlpha(190),
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            background: primaryColor,
            onBackground: Colors.white,
            surface: primaryColor,
            onSurface: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[850],
            focusColor: Colors.grey[800],
            labelStyle: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.w300,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: primaryColor.withAlpha(170),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.red.withAlpha(170),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          dialogBackgroundColor: scaffoldBackgroundColor,
          dialogTheme: DialogTheme(
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 18,
              color: Colors.grey[200],
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
