import 'dart:isolate';

import 'request_data.dart';

class GenerateChunkRequest {
  final SendPort sendPort;
  final GenerateChunkRequestData data;

  GenerateChunkRequest({
    required this.sendPort,
    required this.data,
  });
}
