import 'package:todo_gabarito/modules/todos/infra/models/todo_model.dart';

import '../entities/todo.dart';

/// Contrato definido por quem usa (os casos de uso) e implementado na Infra.
abstract interface class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> updateTodo(Todo todo);
}
