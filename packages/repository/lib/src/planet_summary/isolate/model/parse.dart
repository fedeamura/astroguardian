import 'dart:isolate';

class ParsePlanetSummaryRequest {
  final SendPort sendPort;
  final dynamic data;

  ParsePlanetSummaryRequest({
    required this.sendPort,
    required this.data,
  });
}
