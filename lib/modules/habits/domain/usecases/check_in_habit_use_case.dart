import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/domain/repositories/habit_repository.dart';

class CheckInHabitUseCase {
  final HabitRepository habitRepository;

  CheckInHabitUseCase(this.habitRepository);

  Future<Habit> call(Habit habit) async {
    return await habitRepository.checkinHabit(habit);
  }
}
