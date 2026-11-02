import 'package:flutter_test/flutter_test.dart';
<<<<<<< HEAD
import 'package:todo_gabarito/modules/todos/domain/usecases/get_todos_use_case.dart';
=======
import 'package:todo_gabarito/modules/todos/domain/usecases/get_todos.dart';
import 'package:todo_gabarito/modules/todos/domain/usecases/update_todos_use_case.dart';
>>>>>>> e990c7fd752345effa1d7af859ab0c806c46e7cc
import 'package:todo_gabarito/modules/todos/presenter/todos_controller.dart';

import '../../../helpers/fake_todo_repository.dart';

TodosController _controller(FakeTodoRepository repository) => TodosController(
<<<<<<< HEAD
      getTodosUseCase: GetTodosUseCase(repository),
=======
      getTodos: GetTodosUseCase(repository),
      updateUseCase: UpdateTodoUseCase(repository),
>>>>>>> e990c7fd752345effa1d7af859ab0c806c46e7cc
    );

void main() {
  test('load preenche a lista e desliga o carregamento', () async {
    final controller = _controller(FakeTodoRepository());

    await controller.load();

    expect(controller.listTodos, hasLength(2));
    expect(controller.loading, isFalse);
    expect(controller.error, isNull);
  });

  test('falha do domínio vira mensagem de erro', () async {
    final repository = FakeTodoRepository()..fail = true;
    final controller = _controller(repository);

    await controller.load();

    expect(controller.error, 'Falha simulada');
    expect(controller.listTodos, isEmpty);
  });
}
