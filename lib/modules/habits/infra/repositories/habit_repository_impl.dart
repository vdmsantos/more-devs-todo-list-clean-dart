import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/domain/errors/habit_failure.dart';
import 'package:todo_gabarito/modules/habits/domain/repositories/habit_repository.dart';
import 'package:todo_gabarito/modules/habits/infra/datasources/habit_datasource.dart';
import 'package:todo_gabarito/modules/habits/infra/models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitDatasource datasource;

  HabitRepositoryImpl(this.datasource);

  @override
  Future<List<Habit>> getHabits() async {
    try {
      final maps = await datasource.getHabits();
      return maps.map(HabitModel.fromMap).toList();
    } catch (_) {
      throw const HabitFailure('Não foi possível carregar os hábitos');
    }
  }

  @override
  Future<Habit> checkinHabit(Habit habit) async {
    try {
      final maps = await datasource.postHabit(habit);
      return HabitModel.fromMap(maps);
    } catch (_) {
      throw const HabitFailure('Não efetuar o check-in');
    }
  }
}
