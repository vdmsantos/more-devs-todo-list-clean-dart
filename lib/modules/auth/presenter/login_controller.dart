import 'package:flutter/foundation.dart';
import 'package:todo_gabarito/modules/auth/domain/usecases/get_token_use_case.dart';
import 'package:todo_gabarito/modules/auth/domain/usecases/logout_use_case.dart';
import 'package:todo_gabarito/modules/auth/domain/usecases/set_token_use_case.dart';

import '../domain/entities/session.dart';
import '../domain/errors/auth_failure.dart';
import '../domain/usecases/login_use_case.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class LoginController extends ChangeNotifier {
  LoginController(this.loginUseCase, this.getTokenUseCase, this.setTokenUseCase,
      this.logoutUseCase);
  final LoginUseCase loginUseCase;
  final GetTokenUseCase getTokenUseCase;
  final SetTokenUseCase setTokenUseCase;
  final LogoutUseCase logoutUseCase;

  String _email = '';
  String _password = '';
  bool loading = false;
  bool obscurePassword = true;
  bool rememberMe = false;
  String? emailError;
  String? error;
  Session? session;
  String? userToken;

  bool get loggedIn => session != null;
  bool get canSubmit =>
      !loading && _email.trim().isNotEmpty && _password.isNotEmpty;

  void setEmail(String value) {
    _email = value;
    emailError = null;
    error = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    error = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleRememberMe() {
    rememberMe = !rememberMe;
    notifyListeners();
  }

  Future<void> getUserToken() async {
    userToken = await getTokenUseCase();
  }

  Future<void> login() async {
    if (!canSubmit) return;
    final email = _email.trim();
    if (!_emailPattern.hasMatch(email)) {
      emailError = 'Digite um e-mail válido';
      notifyListeners();
      return;
    }

    loading = true;
    error = null;
    notifyListeners();
    try {
      session = await loginUseCase(email, _password);
      if (rememberMe == true) {
        try {
          await setTokenUseCase(session!.token);
          print('Token salvo com sucesso: ${session!.token}');
        } catch (e) {
          error = 'Erro ao obter o token: $e';
          notifyListeners();
          return;
        }
      }
    } on AuthFailure catch (failure) {
      error = failure.message;
    } catch (_) {
      error = 'Não foi possível entrar. Tente de novo.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
  }
}
