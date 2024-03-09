import 'dart:isolate';

class ParsePlanetInfoRequest {
  final SendPort sendPort;
  final dynamic data;

  ParsePlanetInfoRequest({
    required this.sendPort,
    required this.data,
  });
}
