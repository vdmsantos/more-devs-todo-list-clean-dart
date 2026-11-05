import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_gabarito/modules/auth/domain/usecases/get_token_use_case.dart';
import 'package:todo_gabarito/modules/auth/domain/usecases/login_use_case.dart';
import 'package:todo_gabarito/modules/auth/domain/usecases/logout_use_case.dart';
import 'package:todo_gabarito/modules/auth/domain/usecases/set_token_use_case.dart';
import 'package:todo_gabarito/modules/auth/external/datasources/auth_api_datasource.dart';
import 'package:todo_gabarito/modules/auth/infra/datasources/auth_datasource.dart';
import 'package:todo_gabarito/modules/auth/infra/repositories/auth_repository_impl.dart';
import 'package:todo_gabarito/modules/auth/presenter/login_controller.dart';
import 'package:todo_gabarito/modules/auth/presenter/login_page.dart';
import 'package:todo_gabarito/modules/habits/domain/usecases/check_in_habit_use_case.dart';
import 'package:todo_gabarito/modules/habits/domain/usecases/get_habit_use_case.dart';
import 'package:todo_gabarito/modules/habits/external/datasources/habit_api_datasource.dart';
import 'package:todo_gabarito/modules/habits/infra/datasources/habit_datasource.dart';
import 'package:todo_gabarito/modules/habits/infra/repositories/habit_repository_impl.dart';
import 'package:todo_gabarito/modules/habits/presenter/habits_controller.dart';
import 'package:todo_gabarito/modules/habits/presenter/habits_page.dart';
import 'package:todo_gabarito/modules/todos/domain/usecases/update_todo_use_case.dart';

import 'modules/todos/domain/usecases/get_todos_use_case.dart';
import 'modules/todos/external/datasources/todo_api_datasource.dart';
import 'modules/todos/external/datasources/todo_connectivity_plus_datasource.dart';
import 'modules/todos/external/datasources/todo_shared_preferences_datasource.dart';
import 'modules/todos/infra/datasources/todo_datasource.dart';
import 'modules/todos/infra/repositories/todo_repository_impl.dart';
import 'modules/todos/presenter/todos_controller.dart';
import 'modules/todos/presenter/todos_page.dart';

/// Único lugar que sabe quais implementações usar.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Dio dio = Dio(
      BaseOptions(baseUrl: 'https://todo-api-production-62d2.up.railway.app'));
  final TodoDatasource todoDatasource = TodoApiDatasource(dio);
  final preferences = await SharedPreferences.getInstance();
  final todoCache = TodoSharedPreferencesDatasource(preferences);
  final todoConnectivity = TodoConnectivityPlusDatasource(Connectivity());
  final todoRepository = TodoRepositoryImpl(
    todoDatasource,
    todoCache,
    todoConnectivity,
  );
  final todoController = TodosController(
    getTodosUseCase: GetTodosUseCase(todoRepository),
    updateTodoUseCase: UpdateTodoUseCase(todoRepository),
  )..load();

  final HabitDatasource habitDatasource = HabitApiDatasource(dio);
  final habitRepository = HabitRepositoryImpl(habitDatasource);
  final AuthDatasource authDatasource = AuthApiDatasource(dio);
  final authRepository = AuthRepositoryImpl(authDatasource);
  final loginController = LoginController(
      LoginUseCase(authRepository),
      GetTokenUseCase(authRepository),
      SetTokenUseCase(authRepository),
      LogoutUseCase(authRepository));

  await loginController.getUserToken();
  final habitController = HabitsController(
      getHabitUsecase: GetHabitUsecase(habitRepository),
      checkInHabitUseCase: CheckInHabitUseCase(habitRepository))
    ..load();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => todoController,
      ),
      ChangeNotifierProvider(
        create: (context) => habitController,
      ),
      ChangeNotifierProvider(
        create: (context) => loginController,
      )
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315CFF)),
      ),
      home: ListenableBuilder(
        listenable: loginController,
        builder: (context, _) => loginController.userToken != null
            ? HomeShell(pages: [
                TodosPage(controller: todoController),
                HabitsPage(habitsController: habitController),
              ])
            : LoginPage(controller: loginController),
      ),
    ),
  ));
}

/// Navegação entre os módulos. Fica aqui para um módulo não importar o outro.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.pages});

  final List<Widget> pages;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: widget.pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.checklist_rounded),
            label: 'Tarefas',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_fire_department_rounded),
            label: 'Hábitos',
          ),
        ],
      ),
    );
  }
}
