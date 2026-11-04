import 'package:dio/dio.dart';

import '../../domain/entities/session.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/session_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this.datasource);
  final AuthDatasource datasource;

  @override
  Future<Session> login(String email, String password) async {
    try {
      return SessionModel.fromMap(await datasource.login(email, password));
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const InvalidCredentialsFailure();
      }
      throw const LoginFailure();
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw const LoginFailure();
    }
  }

  @override
  Future<String?> getToken() {
    try {
      return datasource.getToken();
    } catch (e) {
      throw Exception("Erro ao obter o token ${e.toString()}");
    }
  }

  @override
  Future<void> setToken(String token) {
    try {
      return datasource.setToken(token);
    } catch (e) {
      throw Exception("Erro ao salvar o token ${e.toString()}");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await datasource.logout();
    } catch (e) {
      throw Exception("Erro ao deslogar ${e.toString()}");
    }
  }
}
