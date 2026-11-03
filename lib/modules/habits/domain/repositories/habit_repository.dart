import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/domain/usecases/check_in_habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> fetchHabits();
  Future<Habit> checkHabit(Habit habits);
}
