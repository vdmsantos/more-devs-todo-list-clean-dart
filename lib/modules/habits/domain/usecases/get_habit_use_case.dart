import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/domain/repositories/habit_repository.dart';

class GetHabitUsecase {
  final HabitRepository habitRepository;

  GetHabitUsecase(this.habitRepository);

  Future<List<Habit>> call({bool hideDone = false}) async {
    final habits = await habitRepository.getHabits();
    return habits;
  }
}
