import 'package:dio/dio.dart';
import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/infra/datasources/habitsDatasource.dart';

class HabitApiDatasoucers implements HabitsDatasource {
  final Dio dio;
  HabitApiDatasoucers(this.dio);

  @override
  Future<List<Map<String, dynamic>>> fetchHabits() async {
    final res = await dio.get<List<dynamic>>('/habits');
    return res.data!.cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> checkHabit(Habit habit) async {
    final response = await dio.post('/habits${habit.id}checkins');
    return response.data as Map<String, dynamic>;
  }
}
