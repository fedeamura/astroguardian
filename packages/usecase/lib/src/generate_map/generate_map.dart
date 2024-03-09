import 'package:model/model.dart';
import 'package:repository/repository.dart';
import 'package:synchronized/synchronized.dart';
import 'package:usecase/src/generate_map/isolate/generate_chunk/isolate.dart';

import 'isolate/calculate_chunks/isolate.dart';
import 'isolate/calculate_chunks/request_data.dart';
import 'isolate/generate_chunk/request_data.dart';

class GenerateMapUseCase {
  final ChunkRepository _chunkRepository;
  final PlanetSummaryRepository _planetSummaryRepository;

  GenerateMapUseCase({
    required ChunkRepository chunkRepository,
    required PlanetSummaryRepository planetSummaryRepository,
  })  : _chunkRepository = chunkRepository,
        _planetSummaryRepository = planetSummaryRepository;

  final _lock = Lock();
  late CalculateChunksIsolate _calculateChunksIsolate;
  late GenerateChunkIsolate _generateChunkIsolate;

  Future<void> init() async {
    _calculateChunksIsolate = CalculateChunksIsolate();
    await _calculateChunksIsolate.init();

    _generateChunkIsolate = GenerateChunkIsolate();
    await _generateChunkIsolate.init();
  }

  Future<List<Chunk>> call({
    required Game game,
    required PointInt shipPosition,
    required int renderDistance,
  }) {
    return _lock.synchronized(
      () => _process(
        game: game,
        shipPosition: shipPosition,
        renderDistance: renderDistance,
      ),
    );
  }

  Future<List<Chunk>> _process({
    required Game game,
    required PointInt shipPosition,
    required int renderDistance,
  }) async {
    final calculateChunkResult = await _calculateChunksIsolate.call(
      GenerateTerrainRequestData(
        position: shipPosition,
        currentChunksMap: game.currentChunksArray,
        extra: renderDistance,
        chunkSize: game.chunkSize,
      ),
    );

    /// Generate new chunks
    final createdChunks = <Chunk>[];

    if (calculateChunkResult.chunksToGenerateList.isNotEmpty) {
      // Handle existing chunks
      final chunksPendingToCreate = <PointInt>[];
      for (var chunkPosition in calculateChunkResult.chunksToGenerateList) {
        final existing = await _chunkRepository.read(game.uid, chunkPosition);
        if (existing != null) {
          createdChunks.add(existing);
          game.chunks.put(chunkPosition, existing);
        } else {
          chunksPendingToCreate.add(chunkPosition);
        }
      }

      // Generate chunks
      if (chunksPendingToCreate.isNotEmpty) {
        var planetSummary = (await _planetSummaryRepository.get(game.uid)) ?? PlanetSummary(planets: [], updatedAt: DateTime.now().millisecondsSinceEpoch);
        bool planetSummaryChanged = false;

        for (var chunkPosition in chunksPendingToCreate) {
          final chunk = await _generateChunkIsolate.call(
            GenerateChunkRequestData(
              position: chunkPosition,
              chunkSize: game.chunkSize,
              seed: game.seed,
              initialPlanetUid: game.initialPlanetUid,
              initialPlanetGlobalPosition: game.initialPlanetGlobalPosition,
              initialPlanetSatelliteCount: game.initialPlanetSatelliteCount,
              initialPlanetRadius: game.initialPlanetRadius,
              initialPlanetSatelliteMinDistance: game.initialPlanetSatelliteMinDistance,
              initialPlanetSatelliteMaxDistance: game.initialPlanetSatelliteMaxDistance,
              planetProbability: game.planetProbability,
              planetSatelliteMaxCount: game.planetSatelliteMaxCount,
              planetWithSatellitesProbability: game.planetWithSatellitesProbability,
              planetSummary: planetSummary,
            ),
          );

          await _chunkRepository.save(game.uid, chunk);

          final planet = chunk.planet;
          if (planet != null) {
            planetSummaryChanged = true;
            planetSummary = PlanetSummary(
              planets: [
                ...planetSummary.planets,
                PlanetSummaryItem(
                  uid: planet.uid,
                  position: planet.globalPosition,
                  radius: planet.radius,
                  satelliteMaxOrbitDistance: planet.satelliteMaxOrbitDistance,
                ),
              ],
              updatedAt: DateTime.now().millisecondsSinceEpoch,
            );
          }

          createdChunks.add(chunk);
          game.chunks.put(chunkPosition, chunk);
        }

        if (planetSummaryChanged) {
          await _planetSummaryRepository.save(
            game.uid,
            planetSummary,
          );
        }
      }
    }

    // Delete chunks
    if (calculateChunkResult.chunksToDeleteList.isNotEmpty) {
      for (var chunk in calculateChunkResult.chunksToDeleteList) {
        game.chunks.remove(chunk);
      }
    }

    game.currentChunksArray.replace(calculateChunkResult.currentChunksMap);
    game.currentChunksList.clear();
    game.currentChunksList.addAll(calculateChunkResult.currentChunksList);
    return createdChunks;
  }
}
