import 'package:model/model.dart';

abstract class ChunkRepository {
  Future<void> deleteAll(String gameUid);

  Future<void> save(String gameUid, Chunk chunk);

  Future<Chunk?> read(String gameUid, PointInt position);
}
