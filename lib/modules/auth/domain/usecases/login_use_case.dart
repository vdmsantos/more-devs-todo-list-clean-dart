import '../entities/session.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this.repository);
  final AuthRepository repository;

  Future<Session> call(String email, String password) =>
      repository.login(email, password);
}
