import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/domain/errors/habit_failure.dart';
import 'package:todo_gabarito/modules/habits/domain/repositories/habit_repository.dart';
import 'package:todo_gabarito/modules/habits/infra/datasources/habitsDatasource.dart';
import 'package:todo_gabarito/modules/habits/infra/models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitsDatasource datasource;
  HabitRepositoryImpl(this.datasource);

  @override
  Future<List<Habit>> fetchHabits() async {
    try {
      final maps = await datasource.fetchHabits();
      return maps.map(HabitModel.fromMap).toList();
    } catch (_) {
      throw const HabitFailure('Não foi possível carregar as habitos');
    }
  }

  @override
  Future<Habit> checkHabit(Habit habit) async {
    try {
      final map = await datasource.checkHabit(habit);
      return HabitModel.fromMap(map);
    } catch (_) {
      throw const HabitFailure('Não foi possível comcluir o habito');
    }
  }
}
