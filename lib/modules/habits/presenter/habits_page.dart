import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_gabarito/modules/habits/domain/entities/habit.dart';
import 'package:todo_gabarito/modules/habits/presenter/habits_controller.dart';

/// Tela de hábitos. Por enquanto usa dados fixos ([_mockHabits]).
///
/// TODO(aluno): criar o `HabitsController` e:
///   1. receber o controller pelo construtor, como em `TodosPage`;
///   2. envolver o Scaffold em um `ListenableBuilder`;
///   3. trocar [_mockHabits] pelos hábitos do controller;
///   4. tratar `loading` e `error` (veja `TodosPage`);
///   5. chamar o caso de uso de check-in em [_checkIn].
class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key, required this.habitsController});

  final HabitsController habitsController;

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

/// Só para a tela funcionar sem as outras camadas. Apague quando tiver a
/// entidade `Habit` — streak e "feito hoje" são regras do domínio.

class _HabitsPageState extends State<HabitsPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF315CFF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      child: Scaffold(
        body: SafeArea(child: _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<HabitsController>(builder: (context, controller, child) {
      if (controller.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      final habits = widget.habitsController.listHabits;
      final doneToday =
          habits.where((habit) => habit.hasCheckedInToday()).length;
      final bestStreak = habits.fold<int>(
        0,
        (best, habit) =>
            habit.getCheckinStreak() > best ? habit.getCheckinStreak() : best,
      );

      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _todayLabel(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Meus hábitos',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Atualizar hábitos',
                // TODO(aluno): chamar controller.load.
                onPressed: () {
                  controller.load();
                },
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 26),
          _SummaryCard(
            total: habits.length,
            doneToday: doneToday,
            bestStreak: bestStreak,
          ),
          const SizedBox(height: 24),
          Text(
            'HÁBITOS',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          if (habits.isEmpty)
            const _EmptyState()
          else
            ...habits.map(
              (habit) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _HabitCard(
                  name: habit.name,
                  streak: habit.getCheckinStreak(),
                  doneToday: habit.hasCheckedInToday(),
                  onCheckIn: () => controller.checkInHabitUseCase(habit),
                ),
              ),
            ),
        ],
      );
    });
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.total,
    required this.doneToday,
    required this.bestStreak,
  });

  final int total;
  final int doneToday;
  final int bestStreak;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : doneToday / total;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 19, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feitos hoje',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: '$doneToday',
                        style: const TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.w900,
                        ),
                        children: [
                          TextSpan(
                            text: ' / $total',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1E6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  child: Text(
                    '🔥 melhor: $bestStreak ${bestStreak == 1 ? 'dia' : 'dias'}',
                    style: const TextStyle(
                      color: Color(0xFFD9480F),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress,
              backgroundColor: const Color(0xFFE9E9ED),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            doneToday == total && total > 0
                ? 'Tudo feito hoje · mandou bem!'
                : 'Faltam ${total - doneToday} para fechar o dia',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({
    required this.name,
    required this.streak,
    required this.doneToday,
    required this.onCheckIn,
  });

  final String name;
  final int streak;
  final bool doneToday;
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final onFire = streak > 0;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color:
                    onFire ? const Color(0xFFFFF1E6) : const Color(0xFFF0F0F3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                color: onFire ? const Color(0xFFF76707) : colorScheme.outline,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    onFire
                        ? '$streak ${streak == 1 ? 'dia seguido' : 'dias seguidos'}'
                        : 'Comece hoje',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (doneToday)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, color: colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Feito',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              )
            else
              FilledButton.tonal(
                onPressed: onCheckIn,
                child: const Text('Feito hoje'),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 52,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhum hábito por aqui',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

String _todayLabel() {
  const weekdays = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo',
  ];
  const months = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];
  final now = DateTime.now();
  return '${weekdays[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]}';
}
