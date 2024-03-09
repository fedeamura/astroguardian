import 'package:model/model.dart';

class CalculateChunksResponse {
  final Array<bool> currentChunksMap;
  final List<PointInt> currentChunksList;

  final Array<bool> chunksToGenerateMap;
  final List<PointInt> chunksToGenerateList;

  final Array<bool> chunksToDeleteMap;
  final List<PointInt> chunksToDeleteList;

  CalculateChunksResponse({
    required this.currentChunksMap,
    required this.currentChunksList,
    required this.chunksToGenerateMap,
    required this.chunksToGenerateList,
    required this.chunksToDeleteMap,
    required this.chunksToDeleteList,
  });
}
