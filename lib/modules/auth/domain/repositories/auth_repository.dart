import '../entities/session.dart';

abstract interface class AuthRepository {
  Future<Session> login(String email, String password);
  Future<String?> getToken();
  Future<void> setToken(String token);
  Future<void> logout();
}
