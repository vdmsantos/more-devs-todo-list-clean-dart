abstract interface class AuthDatasource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<String?> getToken();
  Future<void> setToken(String token);
  Future<void> logout();
}
