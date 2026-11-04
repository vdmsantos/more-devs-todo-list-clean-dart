import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_gabarito/main.dart';
import 'package:todo_gabarito/modules/habits/presenter/habits_controller.dart';
import 'package:todo_gabarito/modules/habits/presenter/habits_page.dart';
import 'package:todo_gabarito/modules/todos/presenter/todos_controller.dart';
import 'package:todo_gabarito/modules/todos/presenter/todos_page.dart';

import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.controller});
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final colors = Theme.of(context).colorScheme;
        return Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(Icons.checklist_rounded,
                                color: colors.onPrimary, size: 30),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('Entrar',
                            style: TextStyle(
                              fontSize: 29,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.8,
                            )),
                        const SizedBox(height: 4),
                        Text('Acesse suas tarefas e hábitos.',
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 15)),
                        const SizedBox(height: 28),
                        TextField(
                          onChanged: controller.setEmail,
                          enabled: !controller.loading,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          autofillHints: const [AutofillHints.email],
                          decoration: _decoration(
                              'E-mail', Icons.mail_outline_rounded,
                              errorText: controller.emailError),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          onChanged: controller.setPassword,
                          onSubmitted: (_) => controller.login(),
                          enabled: !controller.loading,
                          obscureText: controller.obscurePassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          decoration: _decoration(
                            'Senha',
                            Icons.lock_outline_rounded,
                            suffix: IconButton(
                              tooltip: controller.obscurePassword
                                  ? 'Mostrar senha'
                                  : 'Esconder senha',
                              onPressed: controller.togglePasswordVisibility,
                              icon: Icon(controller.obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        CheckboxListTile(
                          value: controller.rememberMe,
                          onChanged: controller.loading
                              ? null
                              : (_) => controller.toggleRememberMe(),
                          title: const Text('Lembrar de mim'),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                        if (controller.error != null) ...[
                          const SizedBox(height: 10),
                          _ErrorBanner(message: controller.error!),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 52,
                          child: Consumer<HabitsController>(
                              builder: (context, habitsController, child) {
                            return Consumer<TodosController>(
                                builder: (context, todosController, child) {
                              return FilledButton(
                                onPressed: () async {
                                  try {
                                    await controller.login();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeShell(pages: [
                                          TodosPage(
                                              controller: todosController),
                                          HabitsPage(
                                              habitsController:
                                                  habitsController),
                                        ]),
                                      ),
                                    );
                                  } catch (e) {}
                                },
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                                child: controller.loading
                                    ? const SizedBox.square(
                                        dimension: 22,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2.5))
                                    : const Text('Entrar'),
                              );
                            });
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _decoration(String label, IconData icon,
      {String? errorText, Widget? suffix}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE6E6EA)),
    );
    return InputDecoration(
      labelText: label,
      errorText: errorText,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: border,
      enabledBorder: border,
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Icon(Icons.error_outline_rounded, color: colors.error),
        const SizedBox(width: 10),
        Expanded(
            child: Text(message,
                style: TextStyle(
                  color: colors.onErrorContainer,
                  fontWeight: FontWeight.w600,
                ))),
      ]),
    );
  }
}
