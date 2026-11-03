import 'package:flutter/material.dart';
import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/domain/errors/habit_failure.dart';
import 'package:todo_gabarito/modules/habits/domain/usecases/check_in_habit.dart';
import 'package:todo_gabarito/modules/habits/domain/usecases/get_habits.dart';

class HabitsController extends ChangeNotifier {
  HabitsController(
      {required this.checkHabitUseCase, required this.getHabitsUseCase});

  final GetHabitsUseCase getHabitsUseCase;
  final CheckHabitUseCase checkHabitUseCase;

  //nome do metodo de get habit load()

  List<Habit> habits = [];

  bool loading = false;
  String? error;
  bool hideDone = false;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      habits = await getHabitsUseCase();
    } on HabitFailure catch (f) {
      error = f.message;
    }
    loading = false;
    notifyListeners();
  }

  Future<bool> updateHabits(Habit habit) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final updateHabit = habit.copyWith(done: !habit.done);
      return true;
    } on HabitFailure catch (f) {
      error = f.message;
      notifyListeners();
      return false;
    }
  }
}
