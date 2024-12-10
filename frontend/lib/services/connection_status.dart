import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionStatusSingleton {
  static final ConnectionStatusSingleton _singleton =
      ConnectionStatusSingleton._internal();

  ConnectionStatusSingleton._internal();

  factory ConnectionStatusSingleton() {
    return _singleton;
  }
  final Connectivity _connectivity = Connectivity();

  final StreamController<bool> connectionChangeController =
      StreamController<bool>.broadcast();

  final StreamController<int> notificationCountController =
      StreamController<int>.broadcast();

  bool hasConnection = false;
  Stream<bool> get connectionChange => connectionChangeController.stream;

  Stream<int> get notificationCount => notificationCountController.stream;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  void initialize() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _connectionChange,
    );
  }

  void dispose() {
    _connectivitySubscription.cancel();
    connectionChangeController.close();
    notificationCountController.close();
  }

  void _connectionChange(List<ConnectivityResult> results) async {
    print("_connectivity connection changed: $results");

    hasConnection = results.any((result) => result != ConnectivityResult.none);
    print('Connection status in _connectionChange: $hasConnection');
    connectionChangeController.add(hasConnection);
  }

  Future<bool> checkConnection() async {
    print('Checking connection');
    bool previousConnection = hasConnection;
    try {
      final result = await _connectivity.checkConnectivity();
      print('Connection result in checkConnection: ${result.runtimeType}');
      if (result.contains(ConnectivityResult.none)) {
        hasConnection = false;
      } else if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } catch (e) {
      print('Error checking connection: $e setting hasConnection to false');
      hasConnection = false;
    }
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    return hasConnection;
  }
}

final connectionStatus = ConnectionStatusSingleton();
