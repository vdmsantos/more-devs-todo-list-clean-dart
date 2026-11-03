import 'package:flutter/foundation.dart';
import 'package:todo_gabarito/modules/todos/domain/usecases/update_todo_usecase.dart';

import '../domain/entities/todo.dart';
import '../domain/errors/todo_failure.dart';
import '../domain/usecases/get_todos.dart';

class TodosController extends ChangeNotifier {
  TodosController({required this.getTodos, required this.updateTodoUsecase});

  final GetTodosUseCase getTodos;
  final UpdateTodoUsecase updateTodoUsecase; //criar novo use case
  //criar novo use case

  List<Todo> todos = [];
  bool loading = false;
  String? error;
  bool hideDone = false;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      todos = await getTodos(hideDone: hideDone);
    } on TodoFailure catch (f) {
      error = f.message;
    }
    loading = false;
    notifyListeners();
  }

  //updateTodo

  void toggleHideDone() {
    hideDone = !hideDone;
    load();
  }

  Future<bool> updateTodo(
    Todo todo, {
    required String title,
    required bool done,
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final updatedTodo = todo.copyWith(title: title.trim(), done: done);
      await updateTodoUsecase(updatedTodo);
      await load();
      return true;
    } on TodoFailure catch (f) {
      error = f.message;
      loading = false;
      notifyListeners();
      return false;
    }
  }
}
