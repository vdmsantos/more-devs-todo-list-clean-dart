import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../infra/datasources/todo_datasource.dart';

/// Guarda o último estado conhecido das tarefas e os IDs pendentes de envio.
class TodoSharedPreferencesDatasource implements TodoCacheDatasource {
  static const _todosKey = 'todos_cache_v1';
  static const _pendingKey = 'todos_pending_v1';

  final SharedPreferences preferences;
  TodoSharedPreferencesDatasource(this.preferences);

  @override
  Future<List<Map<String, dynamic>>> fetchTodos() async {
    final json = preferences.getString(_todosKey);
    if (json == null) return [];
    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  @override
  Future<void> saveTodos(List<Map<String, dynamic>> todos) async {
    await preferences.setString(_todosKey, jsonEncode(todos));
  }

  @override
  Future<Set<int>> fetchPendingIds() async =>
      (preferences.getStringList(_pendingKey) ?? []).map(int.parse).toSet();

  @override
  Future<void> markPending(int id) async {
    final ids = await fetchPendingIds();
    ids.add(id);
    await preferences.setStringList(
        _pendingKey, ids.map((id) => id.toString()).toList());
  }

  @override
  Future<void> clearPending(int id) async {
    final ids = await fetchPendingIds();
    ids.remove(id);
    await preferences.setStringList(
        _pendingKey, ids.map((id) => id.toString()).toList());
  }
}
