import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/domain/repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository repository;
  GetHabitsUseCase(this.repository);

  Future<List<Habit>> call() async {
    final habits = await repository.fetchHabits();
    return habits;
  }
}
