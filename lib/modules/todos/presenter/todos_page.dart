import 'package:flutter/material.dart';

import 'todos_controller.dart';
import 'todo_update_page.dart';

/// A página só lê o estado do controller e repassa eventos.
class TodosPage extends StatefulWidget {
  const TodosPage({super.key, required this.controller});

  final TodosController controller;

  @override
  State<TodosPage> createState() => _TodosPageState();
}

enum _TodoFilter { all, pending, done }

class _TodosPageState extends State<TodosPage> {
  _TodoFilter filter = _TodoFilter.all;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF315CFF),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF6F7FB),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF6F7FB),
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: const Color(0xFFF8F8FA),
            actions: [
              const SizedBox.shrink(),
            ],
          ),
          body: SafeArea(child: _buildBody(context)),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final controller = widget.controller;
    if (controller.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final error = controller.error;
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 48),
            const SizedBox(height: 16),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: controller.load,
              child: const Text('Tentar de novo'),
            ),
          ],
        ),
      );
    }

    final completed = controller.listTodos.where((todo) => todo.done).length;
    final pending = controller.listTodos.length - completed;
    final visibleTodos = switch (filter) {
      _TodoFilter.all => controller.listTodos,
      _TodoFilter.pending =>
        controller.listTodos.where((todo) => !todo.done).toList(),
      _TodoFilter.done =>
        controller.listTodos.where((todo) => todo.done).toList(),
    };
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
                    'Minhas tarefas',
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
              tooltip: 'Atualizar tarefas',
              onPressed: controller.loading ? null : controller.load,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        const SizedBox(height: 26),
        _SummaryHeader(
            total: controller.listTodos.length, completed: completed),
        const SizedBox(height: 22),
        _FilterTabs(
          filter: filter,
          total: controller.listTodos.length,
          pending: pending,
          completed: completed,
          onChanged: (value) => setState(() => filter = value),
        ),
        const SizedBox(height: 24),
        Text(
          'HOJE',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 10),
        if (visibleTodos.isEmpty)
          const _EmptyState()
        else
          ...visibleTodos.map(
            (todo) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TodoCard(
                title: todo.title,
                done: todo.done,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => TodoUpdatePage(todo: todo),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.total, required this.completed});

  final int total;
  final int completed;

  @override
  Widget build(BuildContext context) {
    final remaining = total - completed;
    final progress = total == 0 ? 0.0 : completed / total;
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progresso',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      text: '$completed',
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
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EEFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  child: Text(
                    '$remaining pendentes',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
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
            '${(progress * 100).round()}% concluído · continue assim',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.filter,
    required this.total,
    required this.pending,
    required this.completed,
    required this.onChanged,
  });

  final _TodoFilter filter;
  final int total;
  final int pending;
  final int completed;
  final ValueChanged<_TodoFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9ED),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _tab(context, _TodoFilter.all, 'Todas', total),
          _tab(context, _TodoFilter.pending, 'Pendentes', pending),
          _tab(context, _TodoFilter.done, 'Concluídas', completed),
        ],
      ),
    );
  }

  Widget _tab(
      BuildContext context, _TodoFilter value, String label, int count) {
    final selected = filter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: selected
                ? const [BoxShadow(color: Color(0x12000000), blurRadius: 3)]
                : null,
          ),
          child: Text(
            '$label  $count',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? const Color(0xFF24242A) : Colors.grey.shade700,
              fontSize: 13,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
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

class _TodoCard extends StatelessWidget {
  const _TodoCard({
    required this.title,
    required this.done,
    required this.onTap,
  });

  final String title;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Icon(
                done
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked,
                color: done ? colorScheme.primary : colorScheme.outline,
                size: 27,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: done ? colorScheme.outline : colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: colorScheme.outline,
              ),
            ],
          ),
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
            Icons.checklist_rounded,
            size: 52,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhuma tarefa por aqui',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text('Tudo certo por enquanto.'),
        ],
      ),
    );
  }
}
