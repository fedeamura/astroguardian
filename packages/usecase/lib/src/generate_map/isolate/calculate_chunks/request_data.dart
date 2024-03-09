import 'package:model/model.dart';

class GenerateTerrainRequestData {
  final PointInt position;
  final Array<bool> currentChunksMap;
  final int extra;
  final int chunkSize;

  GenerateTerrainRequestData({
    required this.position,
    required this.currentChunksMap,
    required this.extra,
    required this.chunkSize,
  });
}
