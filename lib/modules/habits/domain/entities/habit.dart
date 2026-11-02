class Habit {
  final int id;
  final String name;
  final List<String> checkins;

  Habit({required this.id, required this.name, required this.checkins});

  Habit copyWith({String? name, List<String>? checkins}) => Habit(
      id: id, name: name ?? this.name, checkins: checkins ?? this.checkins);
}
