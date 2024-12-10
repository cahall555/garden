import 'package:flutter/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionStatus with ChangeNotifier {
  static final ConnectionStatus _instance = ConnectionStatus._internal();
  factory ConnectionStatus() => _instance;

  ConnectionStatus._internal();

  final Connectivity _connectivity = Connectivity();
  bool _isOnline = false;

  bool get isOnline => _isOnline;

  Future<void> initialize() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;
    notifyListeners();

    _connectivity.onConnectivityChanged.listen((result) {
      _isOnline = result != ConnectivityResult.none;
      notifyListeners();
    });
  }
}

