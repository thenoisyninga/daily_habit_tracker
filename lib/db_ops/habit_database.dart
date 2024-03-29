import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HabitDatabase extends ChangeNotifier {
  final _habitDatabase = Hive.box("HABIT_DATABASE");

  String? selectedHabit;
  List<String> habitList = [];
  Map<String, List<DateTime>> dateRecords = {};
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  String progressPercDispMode = "2 Months";

  Map<String, int> progressPercDispModes = {
    "2 Weeks": 2,
    "4 Weeks": 4,
    "2 Months": 60 ~/ 7,
    "6 Months": (365 / 2) ~/ 7,
    "1 Year": 365 ~/ 7,
  };

  int targetCompletionsPerWeek = 5;

  void _loadData() {
    selectedHabit = _habitDatabase.get("SELECTED_HABIT");
    habitList = _habitDatabase.get("HABIT_LIST") ?? [];
    progressPercDispMode =
        _habitDatabase.get("PROGRSS_PERC_DISPLAY_MODE") ?? "2 Months";

    for (int i = 0; i < habitList.length; i++) {
      // for each recorded habit, get the dates list
      String habitName = habitList[i];
      List<String> habitDatesInString =
          _habitDatabase.get("${habitName}_DATES_LIST");

      // parse and add the date list to a map
      dateRecords[habitName] = habitDatesInString.map((String stringDate) {
        return DateTime.parse(stringDate);
      }).toList();
    }
  }

  void _saveData() {
    _habitDatabase.put("SELECTED_HABIT", selectedHabit);
    _habitDatabase.put("HABIT_LIST", habitList);
    _habitDatabase.put("PROGRSS_PERC_DISPLAY_MODE", progressPercDispMode);

    List<String> habitDatesinString = [];

    for (int i = 0; i < habitList.length; i++) {
      // for each recorded habit, create a dates list as string
      String habitName = habitList[i];
      habitDatesinString = dateRecords[habitName]!.map((DateTime date) {
        return date.toString().substring(0, 10);
      }).toList();

      // store it in hive
      _habitDatabase.put("${habitName}_DATES_LIST", habitDatesinString);
    }
  }

  void createDefaultData() {
    habitList = ["Workout"];
    progressPercDispMode = "2 Months";
    selectedHabit = habitList[0];
    DateTime now = DateTime.now();
    dateRecords = {
      habitList[0]: [DateTime(now.year, now.month, now.day)]
    };
    _saveData();
  }

  Map<DateTime, int> getHabitDataset() {
    _loadData();
    Map<DateTime, int> dataset = {};
    List<DateTime> habitDatesList = dateRecords[selectedHabit]!;

    for (int i = 0; i < habitDatesList.length; i++) {
      DateTime habitDate = habitDatesList[i];

      dataset[habitDate] = 1;
    }
    return dataset;
  }

  void toggleHabit(DateTime date) {
    if (dateRecords[selectedHabit]!.contains(date)) {
      dateRecords[selectedHabit]!.remove(date);
    } else {
      dateRecords[selectedHabit]!.add(date);
    }
    _saveData();
    notifyListeners();
  }

  bool getCompletionStatus(DateTime date) {
    _loadData();
    return dateRecords[selectedHabit]!.contains(date);
  }

  void addHabit(String habitName) {
    _loadData();
    habitList.add(habitName);
    dateRecords[habitName] = [];
    selectedHabit = habitName;
    _saveData();
    notifyListeners();
  }

  void removeHabit(String habitName) {
    _loadData();
    habitList.remove(habitName);
    if (selectedHabit == habitName) {
      selectedHabit = habitList[0];
    }
    notifyListeners();
  }

  void changeSelectedHabit(String habitName) {
    _loadData();
    if (habitList.contains(habitName)) {
      selectedHabit = habitName;
      _saveData();
      notifyListeners();
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  DateTime getSelectedDate() {
    return _selectedDate;
  }

  double getCompletionPercentage() {
    _loadData();

    int weeks = progressPercDispModes[progressPercDispMode] ?? 60 ~/ 7;

    // get last monday's date
    DateTime weekLowerBound = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    while (weekLowerBound.weekday != DateTime.monday) {
      weekLowerBound = weekLowerBound.subtract(const Duration(days: 1));
    }

    DateTime weekUpperBound = weekLowerBound.subtract(const Duration(days: 7));

    // getting completion rate for each week and summing them
    double completionRateSum = 0;

    for (int i = 0; i < weeks; i++) {
      // calculate completion rate for each week
      double daysCompletedInWeek = 0;
      for (int j = 0; j < dateRecords[selectedHabit]!.length; j++) {
        DateTime currentDate = dateRecords[selectedHabit]![j];
        if ((currentDate.isBefore(weekLowerBound) &&
                currentDate.isAfter(weekUpperBound)) ||
            currentDate.isAtSameMomentAs(weekUpperBound)) {
          daysCompletedInWeek++;
        }
      }

      double completionRateCurrentWeek =
          daysCompletedInWeek / targetCompletionsPerWeek;

      completionRateSum += completionRateCurrentWeek;

      weekLowerBound = weekLowerBound.subtract(const Duration(days: 7));
      weekUpperBound = weekUpperBound.subtract(const Duration(days: 7));
    }

    return completionRateSum / weeks;
  }

  int getCompletionsInCurrentWeek() {
    _loadData();

    // get last monday's date
    DateTime weekStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    while (weekStart.weekday != DateTime.monday) {
      weekStart = weekStart.subtract(const Duration(days: 1));
    }

    int daysCompletedInThisWeek = 0;

    for (int j = 0; j < dateRecords[selectedHabit]!.length; j++) {
      DateTime currentDate = dateRecords[selectedHabit]![j];
      if (currentDate.isAfter(weekStart) ||
          currentDate.isAtSameMomentAs(weekStart)) {
        daysCompletedInThisWeek++;
      }
    }

    return daysCompletedInThisWeek;
  }

  void setProgressPercDispMode(String newMode) {
    progressPercDispMode = newMode;
    _saveData();
    notifyListeners();
  }

  List<String> getProgressPercModesList() {
    return progressPercDispModes.keys.toList();
  }
}
