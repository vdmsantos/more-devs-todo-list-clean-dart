import 'package:flutter/material.dart';
import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/domain/errors/habit_failure.dart';
import 'package:todo_gabarito/modules/habits/domain/usecases/check_in_habit_use_case.dart';
import 'package:todo_gabarito/modules/habits/domain/usecases/get_habit_use_case.dart';

class HabitsController extends ChangeNotifier {
  final GetHabitUsecase getHabitUsecase;
  final CheckInHabitUseCase checkInHabitUseCase;

  HabitsController(
      {required this.getHabitUsecase, required this.checkInHabitUseCase});

  List<Habit> listHabits = [];
  bool loading = false;
  String? error;

  Future<void> load() async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      listHabits = await getHabitUsecase.call();
    } on HabitFailure catch (f) {
      error = f.message;
    }

    loading = false;
    notifyListeners();
  }

  Future<Habit?> checkInHabit(Habit habit) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final checkIn = await checkInHabitUseCase.call(habit);
      return checkIn;
    } on HabitFailure catch (f) {
      error = f.message;
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
