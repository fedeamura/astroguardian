import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:model/model.dart';

import 'model/encode.dart';
import 'model/parse.dart';

class ParsePlanetTerrainIsolate {
  SendPort? _sendPort;
  Isolate? _isolate;

  Future<void> init() async {
    if (!kIsWeb) {
      dispose();

      final portUpdate = ReceivePort();
      _isolate = await Isolate.spawn(_initIsolate, portUpdate.sendPort);
      _sendPort = await portUpdate.first;
    }
  }

  void dispose() {
    if (!kIsWeb) {
      _isolate?.kill();
      _isolate = null;
      _sendPort = null;
    }
  }

  Future<PlanetTerrain?> parse(dynamic data) async {
    if (kIsWeb) {
      return _parse(data);
    } else {
      final receivePort = ReceivePort();

      _sendPort?.send(
        ParsePlanetTerrainRequest(
          sendPort: receivePort.sendPort,
          data: data,
        ),
      );

      return await receivePort.first;
    }
  }

  Future<Map<String, dynamic>> encode(PlanetTerrain model) async {
    if (kIsWeb) {
      return _encode(model);
    } else {
      final receivePort = ReceivePort();

      _sendPort?.send(
        EncodePlanetTerrainRequest(
          sendPort: receivePort.sendPort,
          model: model,
        ),
      );

      return await receivePort.first;
    }
  }
}

_initIsolate(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((message) {
    if (message is ParsePlanetTerrainRequest) {
      final result = _parse(message.data);
      message.sendPort.send(result);
    } else if (message is EncodePlanetTerrainRequest) {
      final result = _encode(message.model);
      message.sendPort.send(result);
    }
  });
}

PlanetTerrain? _parse(dynamic data) {
  if (data == null) return null;
  if (data is! Map) return null;

  final originalMap = jsonDecode(jsonEncode(data)) as Map;
  final map = <String, dynamic>{};
  for (var element in originalMap.entries) {
    map[element.key.toString()] = element.value;
  }

  try {
    return PlanetTerrain.fromJson(map);
  } catch (error, stackTrace) {
    log("Error parsing planet info", error: error, stackTrace: stackTrace);
    return null;
  }
}

Map<String, dynamic> _encode(PlanetTerrain model) => model.toJson();
