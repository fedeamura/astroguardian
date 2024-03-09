import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:model/model.dart';

import 'request.dart';
import 'request_data.dart';
import 'response.dart';

class CalculateChunksIsolate {
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

  Future<CalculateChunksResponse> call(GenerateTerrainRequestData request) async {
    if (kIsWeb) {
      return _process(request);
    } else {
      final receivePort = ReceivePort();

      _sendPort?.send(
        GenerateTerrainRequest(
          sendPort: receivePort.sendPort,
          data: request,
        ),
      );

      return await receivePort.first;
    }
  }
}

void _initIsolate(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  log("CalculateChunks isolate created");

  receivePort.listen((message) {
    final request = message as GenerateTerrainRequest;
    final result = _process(request.data);
    request.sendPort.send(result);
  });
}

CalculateChunksResponse _process(GenerateTerrainRequestData request) {
  var currentChunkX = (request.position.x / request.chunkSize).floor();
  var currentChunkY = (request.position.y / request.chunkSize).floor();

  final currentChunksList = <PointInt>[];
  final currentChunksMap = Array<bool>();

  final chunksToGenerateList = <PointInt>[];
  final chunksToGenerateMap = Array<bool>();
  final chunksToDeleteList = <PointInt>[];
  final chunksToDeleteMap = Array<bool>();

  final initialChunk = PointInt(currentChunkX, currentChunkY);

  final d = request.extra;

  for (int j = -d; j <= d; j++) {
    for (int i = -d; i <= d; i++) {
      final chunk = PointInt(currentChunkX + i, currentChunkY + j);
      currentChunksList.add(chunk);
      currentChunksMap.put(chunk, true);

      if (request.currentChunksMap.get(chunk) != true) {
        chunksToGenerateList.add(chunk);
        chunksToGenerateMap.put(chunk, true);
      }
    }
  }

  chunksToGenerateList.sort((a, b) {
    final d1 = initialChunk.distanceTo(a);
    final d2 = initialChunk.distanceTo(b);
    return d1.compareTo(d2);
  });

  final requestCurrentChunksList = request.currentChunksMap.entries.map((e) => e.position).toList();
  for (var chunk in requestCurrentChunksList) {
    if (currentChunksMap.get(chunk) != true) {
      chunksToDeleteList.add(chunk);
      chunksToDeleteMap.put(chunk, true);
    }
  }

  return CalculateChunksResponse(
    currentChunksList: currentChunksList,
    currentChunksMap: currentChunksMap,
    chunksToGenerateList: chunksToGenerateList,
    chunksToGenerateMap: chunksToGenerateMap,
    chunksToDeleteMap: chunksToDeleteMap,
    chunksToDeleteList: chunksToDeleteList,
  );
}
