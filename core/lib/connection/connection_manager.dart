import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'connection_status.dart';

abstract class ConnectionManager {
  Stream<ConnectionStatus> get observe;
  void dispose();
}

class ConnectivityManagerImpl implements ConnectionManager {
  ConnectivityManagerImpl({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity() {
    _init();
  }

  final Connectivity _connectivity;
  final StreamController<ConnectionStatus> _statusController =
  StreamController<ConnectionStatus>.broadcast();

  @override
  Stream<ConnectionStatus> get observe => _statusController.stream;

  Future<void> _init() async {
    final initialResult = await _connectivity.checkConnectivity();
    _statusController.add(ConnectionStatus.fromConnectivityResult(initialResult.first));

    _connectivity.onConnectivityChanged.listen((result) {
      _statusController.add(ConnectionStatus.fromConnectivityResult(result.first));
    });
  }

  @override
  void dispose() {
    _statusController.close();
  }
}
