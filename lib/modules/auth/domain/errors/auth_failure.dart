sealed class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('E-mail ou senha incorretos');
}

class LoginFailure extends AuthFailure {
  const LoginFailure() : super('Não foi possível entrar. Tente de novo.');
}
