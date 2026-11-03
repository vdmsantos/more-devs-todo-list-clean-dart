import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';

class HabitModel extends Habit {
  const HabitModel({
    required super.id,
    required super.checkins,
    required super.name,
  });

  factory HabitModel.fromMap(Map<String, dynamic> map) => HabitModel(
        id: map['id'] as int,
        checkins: map['checkins'] as List<String>,
        name: map['name'] as String,
      );
}
