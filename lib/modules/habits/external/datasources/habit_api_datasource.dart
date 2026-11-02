import 'package:dio/dio.dart';
import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/infra/datasources/habit_datasource.dart';

class HabitApiDatasource implements HabitDatasource {
  final Dio dio;

  HabitApiDatasource(this.dio);

  @override
  Future<List<Map<String, dynamic>>> getHabits() async {
    final res = await dio.get<List<dynamic>>('/habits');
    return res.data!.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> postHabit(Habit habit) async {
    final res = await dio.post<dynamic>('/habits/${habit.id}',
        data: Habit(id: habit.id, name: habit.name, checkins: habit.checkins));
    return res.data as Map<String, dynamic>;
  }
}
