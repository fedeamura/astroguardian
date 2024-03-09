import 'dart:isolate';

import 'package:model/model.dart';

class EncodePlanetInfoRequest {
  final SendPort sendPort;
  final PlanetInfo model;

  EncodePlanetInfoRequest({
    required this.sendPort,
    required this.model,
  });
}
