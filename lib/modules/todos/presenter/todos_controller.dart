import 'package:flutter/foundation.dart';
import 'package:todo_gabarito/modules/todos/domain/usecases/update_todo_use_case.dart';

import '../domain/entities/todo.dart';
import '../domain/errors/todo_failure.dart';
import '../domain/usecases/get_todos_use_case.dart';

class TodosController extends ChangeNotifier {
  TodosController(
      {required this.getTodosUseCase, required this.updateTodoUseCase});

  final GetTodosUseCase getTodosUseCase;
  final UpdateTodoUseCase updateTodoUseCase;

  List<Todo> listTodos = [];
  bool loading = false;
  String? error;
  bool hideDone = false;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      listTodos = await getTodosUseCase(hideDone: hideDone);
    } on TodoFailure catch (f) {
      error = f.message;
    }
    loading = false;
    notifyListeners();
  }

  void toggleHideDone() {
    hideDone = !hideDone;
    load();
  }

  Future<Todo?> update(Todo todo) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final updatedTodo = await updateTodoUseCase(todo);

      final index = listTodos.indexWhere(
        (t) => t.id == updatedTodo.id,
      );

      if (index != -1) {
        listTodos[index] = updatedTodo;
      }

      return updatedTodo;
    } on TodoFailure catch (f) {
      error = f.message;
      return null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
