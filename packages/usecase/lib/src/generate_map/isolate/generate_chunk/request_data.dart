import 'package:model/model.dart';

class GenerateChunkRequestData {
  final PointInt position;
  final int chunkSize;
  final int seed;
  final double planetProbability;
  final PlanetSummary planetSummary;
  final int planetSatelliteMaxCount;
  final double planetWithSatellitesProbability;
  final PointDouble initialPlanetGlobalPosition;
  final int initialPlanetSatelliteCount;
  final String initialPlanetUid;
  final double initialPlanetRadius;
  final double initialPlanetSatelliteMinDistance;
  final double initialPlanetSatelliteMaxDistance;

  GenerateChunkRequestData({
    required this.position,
    required this.chunkSize,
    required this.seed,
    required this.planetProbability,
    required this.planetSummary,
    required this.planetSatelliteMaxCount,
    required this.planetWithSatellitesProbability,
    required this.initialPlanetUid,
    required this.initialPlanetGlobalPosition,
    required this.initialPlanetSatelliteCount,
    required this.initialPlanetRadius,
    required this.initialPlanetSatelliteMinDistance,
    required this.initialPlanetSatelliteMaxDistance,
  });
}
