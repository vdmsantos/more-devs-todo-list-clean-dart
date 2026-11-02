import 'package:todo_gabarito/modules/todos/domain/entities/todo.dart';
import 'package:todo_gabarito/modules/todos/domain/repositories/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository repository;

  UpdateTodoUseCase(this.repository);

  Future<Todo> call(Todo todo) async {
    return await repository.updateTodo(todo);
  }
}
