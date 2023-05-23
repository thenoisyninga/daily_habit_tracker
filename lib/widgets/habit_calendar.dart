import 'package:daily_habit_tracker/db_ops/habit_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:provider/provider.dart';

class HabitCalendar extends StatefulWidget {
  const HabitCalendar({super.key});

  @override
  State<HabitCalendar> createState() => _HabitCalendarState();
}

class _HabitCalendarState extends State<HabitCalendar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HabitDatabase>(
      builder: (BuildContext context, value, Widget? child) {
        return HeatMapCalendar(
          colorsets: const {
            0: Colors.transparent,
            1: Colors.green,
          },
          size: 39,
          initDate: value.getSelectedDate(),
          defaultColor: Theme.of(context).colorScheme.surface,
          colorMode: ColorMode.color,
          textColor: Theme.of(context).colorScheme.onSurface,
          showColorTip: false,
          fontSize: 12,
          datasets: value.getHabitDataset(),
          onClick: (p0) {
            setState(() {
              value.setSelectedDate(DateTime(
                p0.year,
                p0.month,
                p0.day,
              ));
            });
          },
        );
      },
    );
  }
}
