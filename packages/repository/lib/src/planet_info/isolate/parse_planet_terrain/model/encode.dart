import 'dart:isolate';

import 'package:model/model.dart';

class EncodePlanetTerrainRequest {
  final SendPort sendPort;
  final PlanetTerrain model;

  EncodePlanetTerrainRequest({
    required this.sendPort,
    required this.model,
  });
}
