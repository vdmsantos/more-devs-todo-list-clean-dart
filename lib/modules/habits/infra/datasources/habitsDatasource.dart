import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';

abstract interface class HabitsDatasource {
  Future<List<Map<String, dynamic>>> fetchHabits();
  Future<Map<String, dynamic>> checkHabit(Habit habit);
}
