import '../entities/session.dart';
import '../repositories/auth_repository.dart';

class GetTokenUseCase {
  const GetTokenUseCase(this.repository);
  final AuthRepository repository;

  Future<String?> call() => repository.getToken();
}
