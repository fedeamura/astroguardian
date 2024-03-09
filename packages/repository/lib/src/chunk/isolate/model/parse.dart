import 'dart:isolate';

class ParseChunkRequest {
  final SendPort sendPort;
  final dynamic data;

  ParseChunkRequest({
    required this.sendPort,
    required this.data,
  });
}
