import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';

abstract interface class HabitRepository {
  Future<List<Habit>> getHabits();
  Future<Habit> checkinHabit(Habit habit);
}
