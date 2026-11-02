import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';

abstract interface class HabitDatasource {
  Future<List<Map<String, dynamic>>> getHabits();

  Future<Map<String, dynamic>> postHabit(Habit habit);
}
