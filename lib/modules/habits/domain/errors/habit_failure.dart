class HabitFailure implements Exception {
  final String message;
  const HabitFailure(this.message);

  @override
  String toString() => 'TodoFailure: $message';
}
