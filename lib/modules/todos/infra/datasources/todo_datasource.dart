import 'package:todo_gabarito/modules/todos/domain/entities/todo.dart';

/// Contrato do datasource: fica na Infra porque é a Infra quem o usa.
/// A External só implementa.
abstract interface class TodoDatasource {
  Future<List<Map<String, dynamic>>> fetchTodos();

  Future<Map<String, dynamic>> updateTodo(Todo todo);
}

/// Cache persistente e fila de alterações que ainda não chegaram à API.
abstract interface class TodoCacheDatasource {
  Future<List<Map<String, dynamic>>> fetchTodos();
  Future<void> saveTodos(List<Map<String, dynamic>> todos);
  Future<Set<int>> fetchPendingIds();
  Future<void> markPending(int id);
  Future<void> clearPending(int id);
}

abstract interface class TodoConnectivityDatasource {
  Future<bool> get isConnected;
}
