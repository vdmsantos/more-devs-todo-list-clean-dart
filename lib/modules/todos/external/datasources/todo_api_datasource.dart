import 'package:dio/dio.dart';
import 'package:todo_gabarito/modules/todos/domain/entities/todo.dart';
import 'package:todo_gabarito/modules/todos/infra/models/todo_model.dart';

import '../../infra/datasources/todo_datasource.dart';

/// Única classe do app que conhece o Dio.
class TodoApiDatasource implements TodoDatasource {
  final Dio dio;
  TodoApiDatasource(this.dio);

  @override
  Future<List<Map<String, dynamic>>> fetchTodos() async {
    final res = await dio.get<List<dynamic>>('/todos');
    return res.data!.cast<Map<String, dynamic>>();
  }

//COMENTARIO PRO FORK DO GUSTAVO
//COMENTARIO PRO FORK DO GUSTAVO
  @override
  Future<Map<String, dynamic>> updateTodo(Todo todo) async {
    // TODO: implement updateTodo

    final res = await dio
        .patch<dynamic>('/todos/${todo.id}', data: {"completed": todo.done});
    return res.data! as Map<String, dynamic>;
  }
}
