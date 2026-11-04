import '../entities/session.dart';
import '../repositories/auth_repository.dart';

class SetTokenUseCase {
  const SetTokenUseCase(this.repository);
  final AuthRepository repository;

  Future<void> call(String token) => repository.setToken(token);
}
