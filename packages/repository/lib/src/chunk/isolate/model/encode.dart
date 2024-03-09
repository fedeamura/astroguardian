import 'dart:isolate';

import 'package:model/model.dart';

class EncodeChunkRequest {
  final SendPort sendPort;
  final Chunk model;

  EncodeChunkRequest({
    required this.sendPort,
    required this.model,
  });
}
