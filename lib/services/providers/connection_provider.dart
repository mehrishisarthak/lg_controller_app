import 'package:flutter_riverpod/legacy.dart';

class ConnectionState {
  final bool isConnected;
  final String ip;
  final String username;
  final String password;
  final int port;
  final int screens;

  const ConnectionState({
    this.isConnected = false, 
    this.ip = '',
    this.username = '',
    this.password = '',
    this.port = 22,
    this.screens = 5,
  });

  String displayIp() {
    return isConnected ? ip : 'Not Connected';
  }

  bool isConnectedStatus() {
    return isConnected;
  }


  ConnectionState copyWith({
    bool? isConnected,
    String? ip,
    String? username,
    String? password,
    int? port,
    int? screens,
  }) {
    return ConnectionState(
      isConnected: isConnected ?? this.isConnected,
      ip: ip ?? this.ip,
      username: username ?? this.username,
      password: password ?? this.password,
      port: port ?? this.port,
      screens: screens ?? this.screens,
    );
  }
}

class ConnectionNotifier extends StateNotifier<ConnectionState> {
  ConnectionNotifier() : super(const ConnectionState()); 

  void setConnected(bool isConnected, String ip, String username, String password, int port, int screens) {
    state = state.copyWith(
      isConnected: isConnected,
      ip: ip,
      username: username,
      password: password,
      port: port,
      screens: screens
    );
  }

  void disconnect() {
    state = state.copyWith(isConnected: false, ip: '', username: '', password: '', port: 22, screens: 5);
  }
}

final connectionProvider = StateNotifierProvider<ConnectionNotifier, ConnectionState>((ref) {
  return ConnectionNotifier();
});