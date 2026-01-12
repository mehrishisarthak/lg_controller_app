import 'package:flutter_riverpod/legacy.dart';

class ConnectionState {
  final bool isConnected;
  final String ip;

  const ConnectionState({
    this.isConnected = false, 
    this.ip = '',
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
  }) {
    return ConnectionState(
      isConnected: isConnected ?? this.isConnected,
      ip: ip ?? this.ip,
    );
  }
}

class ConnectionNotifier extends StateNotifier<ConnectionState> {
  ConnectionNotifier() : super(const ConnectionState()); 

  void setConnected(bool isConnected, String ip) {
    state = state.copyWith(isConnected: isConnected, ip: ip);
  }

  void disconnect() {
    state = state.copyWith(isConnected: false, ip: '');
  }
}

final connectionProvider = StateNotifierProvider<ConnectionNotifier, ConnectionState>((ref) {
  return ConnectionNotifier();
});