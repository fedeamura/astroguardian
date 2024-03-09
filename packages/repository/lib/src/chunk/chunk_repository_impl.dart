import 'package:adapter/adapter.dart';
import 'package:model/model.dart';
import 'package:repository/src/chunk/isolate/isolate.dart';

import 'chunk_repository_interface.dart';

class ChunkRepositoryImpl extends ChunkRepository {
  final DataService _dataService;

  ChunkRepositoryImpl({
    required DataService dataService,
  }) : _dataService = dataService;

  late ParseChunkIsolate _parseIsolate;

  Future<void> init() async {
    _parseIsolate = ParseChunkIsolate();
    await _parseIsolate.init();
  }

  @override
  Future<void> deleteAll(String gameUid) => _dataService.deleteAll("chunk_$gameUid");

  @override
  Future<void> save(String gameUid, Chunk chunk) => _dataService.save(
        collection: "chunk_$gameUid",
        uid: "${chunk.position.x}_${chunk.position.y}",
        provider: () => _parseIsolate.encode(chunk),
      );

  @override
  Future<Chunk?> read(String gameUid, PointInt position) => _dataService.getByUid(
        collection: "chunk_$gameUid",
        uid: "${position.x}_${position.y}",
        parser: _parseIsolate.parse,
      );
}
