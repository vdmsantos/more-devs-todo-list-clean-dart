import 'package:connectivity_plus/connectivity_plus.dart';

import '../../infra/datasources/todo_datasource.dart';

class TodoConnectivityPlusDatasource implements TodoConnectivityDatasource {
  final Connectivity connectivity;

  TodoConnectivityPlusDatasource(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
