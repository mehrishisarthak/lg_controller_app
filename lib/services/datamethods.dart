import 'package:dartssh2/dartssh2.dart';
class Datamethods {

  static SSHClient? _client;

  void sendLogo() {
    print("Sending LG Logo to Left Screen...");
  }

  void cleanLogos() {
    print("Cleaning Logos...");
  }

  void sendPyramid() {
    print("Sending 3D Pyramid KML...");
  }

  void cleanKMLs() {
    print("Cleaning KMLs...");
  }

  void flyHome() {
    print("Flying to Home City...");
  }

  Future<String> connect({
    required String ip,
    required int port,
    required String username,
    required String password,
  }) async {
    try {
      final socket = await SSHSocket.connect(
        ip,
        port,
        timeout: const Duration(seconds: 5),
      );

      _client = SSHClient(
        socket,
        username: username,
        onPasswordRequest: () => password,
      );

      await _client!.execute('echo "Connection Verified"');

      return "Success";
    } catch (e) {
      return "Connection Failed: $e";
    }
  }

}