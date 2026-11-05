import '../../domain/entities/todo.dart';
import '../../domain/errors/todo_failure.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_datasource.dart';
import '../models/todo_model.dart';

//chamar o datasource e desserealizar a resposta
class TodoRepositoryImpl implements TodoRepository {
  final TodoDatasource datasource;
  final TodoCacheDatasource cache;
  final TodoConnectivityDatasource connectivity;
  TodoRepositoryImpl(this.datasource, this.cache, this.connectivity);

  @override
  Future<List<Todo>> getTodos() async {
    if (!await connectivity.isConnected) return _loadCacheOrFail();
    try {
      final maps = await datasource.fetchTodos();
      final cached = await cache.fetchTodos();
      final pending = await cache.fetchPendingIds();
      for (final id in pending) {
        final cachedIndex = cached.indexWhere((item) => item['id'] == id);
        if (cachedIndex == -1) continue;
        final localTodo = cached[cachedIndex];
        try {
          await datasource.updateTodo(TodoModel.fromMap(localTodo));
          await cache.clearPending(id);
        } catch (_) {}
        final remoteIndex = maps.indexWhere((item) => item['id'] == id);
        if (remoteIndex >= 0) maps[remoteIndex] = localTodo;
      }
      await cache.saveTodos(maps);
      return maps.map(TodoModel.fromMap).toList();
    } catch (_) {
      final fallback = await cache.fetchTodos();
      if (fallback.isNotEmpty) return fallback.map(TodoModel.fromMap).toList();
      throw const TodoFailure('Não foi possível carregar as tarefas');
    }
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    final cached = await cache.fetchTodos();
    final index = cached.indexWhere((item) => item['id'] == todo.id);
    final localMap = <String, dynamic>{
      'id': todo.id,
      'title': todo.title,
      'completed': todo.done,
    };
    if (index < 0) {
      cached.add(localMap);
    } else {
      cached[index] = localMap;
    }
    await cache.saveTodos(cached);
    await cache.markPending(todo.id);
    if (!await connectivity.isConnected) return TodoModel.fromMap(localMap);
    try {
      final map = await datasource.updateTodo(todo);
      await cache.clearPending(todo.id);
      return TodoModel.fromMap(map);
    } catch (e) {
      return TodoModel.fromMap(localMap);
      throw const TodoFailure('Não foi possivel atualizar a tarefa');
    }
  }

  Future<List<Todo>> _loadCacheOrFail() async {
    final cached = await cache.fetchTodos();
    if (cached.isNotEmpty) return cached.map(TodoModel.fromMap).toList();
    throw const TodoFailure('Não foi possível carregar as tarefas');
  }
}
