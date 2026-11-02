import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_gabarito/modules/todos/presenter/todos_controller.dart';

import '../domain/entities/todo.dart';

class TodoUpdatePage extends StatefulWidget {
  const TodoUpdatePage({super.key, required this.todo});

  final Todo todo;

  @override
  State<TodoUpdatePage> createState() => _TodoUpdatePageState();
}

class _TodoUpdatePageState extends State<TodoUpdatePage> {
  late final TextEditingController titleController;
  late bool done;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    done = widget.todo.done;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 20, 0),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    tooltip: 'Voltar',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  const Expanded(
                    child: Text(
                      'Editar tarefa',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                children: [
                  Text(
                    'TAREFA #${widget.todo.id}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EditCard(
                    child: TextField(
                      controller: titleController,
                      maxLines: 3,
                      minLines: 2,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Título',
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _EditCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tarefa concluída',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                done ? 'Concluída' : 'Ainda pendente',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: done,
                          onChanged: (value) => setState(() => done = value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Consumer<TodosController>(builder: (context, controller, child) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: Column(
                  children: [
                    SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: controller.loading
                              ? null
                              : () => controller.update(
                                    widget.todo.copyWith(done: done),
                                  ),
                          child: controller.loading
                              ? const CircularProgressIndicator()
                              : const Text('Salvar alterações'),
                        )),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _EditCard extends StatelessWidget {
  const _EditCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E6EA)),
      ),
      child: child,
    );
  }
}
