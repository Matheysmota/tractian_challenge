import 'package:connectivity_plus/connectivity_plus.dart';

sealed class ConnectionStatus {
  const ConnectionStatus();

  static const ConnectionStatus connected = _ConnectionStatusConnected();
  static const ConnectionStatus disconnected = _ConnectionStatusDisconnected();

  static ConnectionStatus fromConnectivityResult(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      return const _ConnectionStatusDisconnected();
    }
    return const _ConnectionStatusConnected();
  }
}

class _ConnectionStatusConnected extends ConnectionStatus {
  const _ConnectionStatusConnected();
}

class _ConnectionStatusDisconnected extends ConnectionStatus {
  const _ConnectionStatusDisconnected();
}
