class Habit {
  final int id;
  final String name;
  final List<dynamic> checkins;

  const Habit({required this.id, required this.name, required this.checkins});

  Habit copoyWith({String? name, List<String>? checkins}) => Habit(
      id: id, name: name ?? this.name, checkins: checkins ?? this.checkins);

  int getCheckinStreak() {
    if (checkins!.isEmpty) return 0;

    final dates = checkins!.map((date) => DateTime.parse(date)).toList()
      ..sort();

    int streak = 1;
    int maxStreak = 1;

    for (int i = 1; i < dates.length; i++) {
      final difference = dates[i].difference(dates[i - 1]).inDays;

      if (difference == 1) {
        streak++;
        if (streak > maxStreak) {
          maxStreak = streak;
        }
      } else if (difference > 1) {
        streak = 1;
      }
    }

    return maxStreak;
  }

  bool hasCheckedInToday() {
    final today = DateTime.now();

    bool done = checkins?.any((checkin) {
          final date = DateTime.parse(checkin);

          return date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
        }) ??
        false;
    return done;
  }
}
