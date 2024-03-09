import 'dart:isolate';

import 'package:model/model.dart';

class EncodeGameRequest {
  final SendPort sendPort;
  final Game model;

  EncodeGameRequest({
    required this.sendPort,
    required this.model,
  });
}
