import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/domain/repositories/habit_repository.dart';

class CheckHabitUseCase {
  final HabitRepository repository;
  CheckHabitUseCase(this.repository);

  Future<Habit> call(Habit habit) async {
    return await repository.checkHabit(habit);
  }
}
