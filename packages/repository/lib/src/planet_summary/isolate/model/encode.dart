import 'dart:isolate';

import 'package:model/model.dart';

class EncodePlanetSummaryRequest {
  final SendPort sendPort;
  final PlanetSummary model;

  EncodePlanetSummaryRequest({
    required this.sendPort,
    required this.model,
  });
}
