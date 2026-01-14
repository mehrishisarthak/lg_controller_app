import 'package:dartssh2/dartssh2.dart';
import 'package:lg_controller_app/constants.dart';

class Datamethods {
  static SSHClient? _client;

  Future<bool> _execute(String command) async {
    if (_client == null) return false;

    try {
      await _client!.execute(command);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> query(String content) async {
    return await _execute('echo "$content" > /tmp/query.txt');
  }

  int calculateLeftMostScreen(int screens) {
    return screens == 1 ? 1 : (screens / 2).floor() + 2;
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

  bool disconnect() {
    if (_client != null) {
      _client!.close();
      _client = null;
      return true;
    }
    return false; // Was already disconnected
  }

  Future<bool> sendLogo(int screen) async {
    try {
      String kml = '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>LG Logo</name>
    <ScreenOverlay>
      <name>Logo</name>
      <Icon>
        <href>https://raw.githubusercontent.com/LiquidGalaxyLAB/liquid-galaxy-lab-logo/main/liquid-galaxy-lab-logo.png</href>
      </Icon>
      <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.02" y="0.95" xunits="fraction" yunits="fraction"/>
      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
      <size x="300" y="300" xunits="pixels" yunits="pixels"/>
    </ScreenOverlay>
  </Document>
</kml>
''';
      var targetScreen = calculateLeftMostScreen(screen);
      var command = "echo '$kml' > /var/www/html/kml/slave_$targetScreen.kml";
      
      return await _execute(command);
    } catch (e) {
      return false;
    }
  }

  Future<bool> cleanLogos(int screen) async {
    var targetScreen = calculateLeftMostScreen(screen);
    return await _execute("echo '' > /var/www/html/kml/slave_$targetScreen.kml");
  }

  Future<bool> sendPyramid(List<List<double>> baseCoords, double height) async {
  try {
    double sumLon = 0;
    double sumLat = 0;
    for (var point in baseCoords) {
      sumLon += point[0];
      sumLat += point[1];
    }
    //finding mean of all base coordinates to get apex point to which i will provide height which we are taking from user
    double apexLon = sumLon / baseCoords.length;
    double apexLat = sumLat / baseCoords.length;

    StringBuffer kml = StringBuffer();
    kml.write('''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Dynamic Pyramid</name>
    <Style id="wallStyle"><PolyStyle><color>7f00ff00</color><fill>1</fill></PolyStyle></Style>
''');

    for (int i = 0; i < baseCoords.length; i++) {
      var p1 = baseCoords[i];
      var p2 = baseCoords[(i + 1) % baseCoords.length];

      kml.write('''
    <Placemark>
      <name>Wall ${i + 1}</name>
      <styleUrl>#wallStyle</styleUrl>
      <Polygon>
        <altitudeMode>relativeToGround</altitudeMode>
        <outerBoundaryIs><LinearRing><coordinates>
          ${p1[0]},${p1[1]},0
          ${p2[0]},${p2[1]},0
          $apexLon,$apexLat,$height
          ${p1[0]},${p1[1]},0
        </coordinates></LinearRing></outerBoundaryIs>
      </Polygon>
    </Placemark>
''');
    }
    kml.write('''
  </Document>
</kml>
''');
   flyToNITA(coordinates);
    return await _execute("echo '${kml.toString()}' > /var/www/html/kml/slave_1.kml");
  } catch (e) {
    return false;
  }
}

  Future<bool> cleanKMLs() async {
    return await _execute("echo '' > /var/www/html/kml/slave_1.kml");
  }

  Future<bool> flyToNITA(String kmlViewTag) async {
    return await query('flytoview=$kmlViewTag');
  }

}