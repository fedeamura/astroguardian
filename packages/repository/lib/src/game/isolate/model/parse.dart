import 'dart:isolate';

class ParseGameRequest {
  final SendPort sendPort;
  final dynamic data;

  ParseGameRequest({required this.sendPort, required this.data});
}
