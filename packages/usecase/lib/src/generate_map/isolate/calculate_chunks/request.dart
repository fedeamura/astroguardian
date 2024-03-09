import 'dart:isolate';

import 'package:usecase/src/generate_map/isolate/calculate_chunks/request_data.dart';

class GenerateTerrainRequest {
  final SendPort sendPort;
  final GenerateTerrainRequestData data;

  GenerateTerrainRequest({
    required this.sendPort,
    required this.data,
  });
}
