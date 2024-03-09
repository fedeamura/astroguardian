import 'dart:isolate';

class ParsePlanetTerrainRequest {
  final SendPort sendPort;
  final dynamic data;

  ParsePlanetTerrainRequest({
    required this.sendPort,
    required this.data,
  });
}
