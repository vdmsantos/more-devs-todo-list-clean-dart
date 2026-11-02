import 'package:todo_gabarito/modules/todos/domain/entities/todo.dart';

/// Contrato do datasource: fica na Infra porque é a Infra quem o usa.
/// A External só implementa.
abstract interface class TodoDatasource {
  Future<List<Map<String, dynamic>>> fetchTodos();

  Future<Map<String, dynamic>> updateTodo(Todo todo);
}
