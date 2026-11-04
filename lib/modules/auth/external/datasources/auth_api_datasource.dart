import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../infra/datasources/auth_datasource.dart';

class AuthApiDatasource implements AuthDatasource {
  AuthApiDatasource(this.dio);
  final Dio dio;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return response.data!;
  }

  @override
  Future<String?> getToken() async {
    try {
      return storage.read(key: 'token');
    } catch (e) {
      throw Exception('Erro ao obter o token: $e');
    }
  }

  @override
  Future<void> setToken(String token) async {
    try {
      await storage.write(key: 'token', value: token);
    } catch (e) {
      throw Exception('Erro ao salvar o token: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await storage.delete(key: 'token');
    } catch (e) {
      throw Exception("Erro ao deletar token ${e.toString()}");
    }
  }
}
