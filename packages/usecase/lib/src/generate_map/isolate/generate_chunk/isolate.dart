import 'dart:isolate';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:model/model.dart';
import 'package:usecase/usecase.dart';
import 'package:util/util.dart';
import 'package:uuid/uuid.dart';

import 'request.dart';
import 'request_data.dart';

final _rnd = RandomUtil();
final _generatePlanetTerrainUseCase = GeneratePlanetTerrainUseCase();
final _generatePlanetSatelliteTerrainUseCase = GeneratePlanetSatelliteTerrainUseCase();

class GenerateChunkIsolate {
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

  Future<Chunk> call(GenerateChunkRequestData request) async {
    if (kIsWeb) {
      return _process(request);
    } else {
      final receivePort = ReceivePort();

      _sendPort?.send(
        GenerateChunkRequest(
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

  receivePort.listen((message) {
    final request = message as GenerateChunkRequest;
    final result = _process(request.data);
    request.sendPort.send(result);
  });
}

Chunk _process(GenerateChunkRequestData request) {
  final position = request.position;

  Planet? planet;
  final shouldCreate = _shouldCreatePlanet(
    chunkPosition: request.position,
    chunkSize: request.chunkSize,
    planetProbability: request.planetProbability,
    initialPlanetGlobalPosition: request.initialPlanetGlobalPosition,
  );

  if (shouldCreate) {
    planet = _createPlanet(
      chunkPosition: request.position,
      chunkSize: request.chunkSize,
      seed: request.seed,
      planetSatelliteMaxCount: request.planetSatelliteMaxCount,
      planetWithSatellitesProbability: request.planetWithSatellitesProbability,
      initialPlanetUid: request.initialPlanetUid,
      initialPlanetGlobalPosition: request.initialPlanetGlobalPosition,
      initialPlanetSatelliteCount: request.initialPlanetSatelliteCount,
      initialPlanetRadius: request.initialPlanetRadius,
      initialPlanetSatelliteMinDistance: request.initialPlanetSatelliteMinDistance,
      initialPlanetSatelliteMaxDistance: request.initialPlanetSatelliteMaxDistance,
    );

    if (_planetCollideWithAnother(planet, request.planetSummary)) {
      planet = null;
    }
  }

  return Chunk(
    position: position,
    planet: planet,
  );
}

bool _shouldCreatePlanet({
  required PointInt chunkPosition,
  required int chunkSize,
  required double planetProbability,
  required PointDouble initialPlanetGlobalPosition,
}) {
  final initialPlanetChunkPosition = initialPlanetGlobalPosition.toChunk(chunkSize);
  if (initialPlanetChunkPosition == chunkPosition) return true;

  final distance = chunkPosition.distanceTo(PointInt(0, 0));
  if (distance < GameConstants.tutorialDistance) {
    return false;
  }

  final create = _rnd.nextDouble() > planetProbability;
  if (!create) return false;

  return true;
}

bool _planetCollideWithAnother(Planet planet, PlanetSummary planetSummary) {
  final pos = planet.globalPosition;
  final orbit = planet.satelliteMaxOrbitDistance;

  for (var planet in planetSummary.planets) {
    final planetPos = planet.position;
    final planetOrbit = planet.satelliteMaxOrbitDistance;

    final distanceBetweenCenters = pos.distanceTo(planetPos);
    if (distanceBetweenCenters <= planetOrbit + orbit) {
      return true;
    }
  }

  return false;
}

Planet _createPlanet({
  required PointInt chunkPosition,
  required int chunkSize,
  required int seed,
  required double planetWithSatellitesProbability,
  required int planetSatelliteMaxCount,
  required PointDouble initialPlanetGlobalPosition,
  required int initialPlanetSatelliteCount,
  required String initialPlanetUid,
  required double initialPlanetRadius,
  required double initialPlanetSatelliteMinDistance,
  required double initialPlanetSatelliteMaxDistance,
}) {
  String planetUid;
  final initialPlanetChunkPosition = initialPlanetGlobalPosition.toChunk(chunkSize);

  final double planetRadius;
  final PointDouble planetGlobalPosition;
  final double satelliteMaxDistance;
  final int satellitesCount;
  final double satelliteMinDistance;

  final bool isInitialPlanet;
  if (initialPlanetChunkPosition == chunkPosition) {
    isInitialPlanet = true;
    planetUid = initialPlanetUid;

    // Planet radius
    planetRadius = initialPlanetRadius;

    // Position
    planetGlobalPosition = initialPlanetGlobalPosition;

    // Satellite distance
    satelliteMinDistance = initialPlanetSatelliteMinDistance;
    satelliteMaxDistance = initialPlanetSatelliteMaxDistance;

    // Satellite count
    satellitesCount = initialPlanetSatelliteCount;
  } else {
    isInitialPlanet = false;
    planetUid = const Uuid().v4();

    // Planet radius
    final planetMinRadius = (chunkSize * 0.03).clamp(1.0, 10.0);
    final planetMaxRadius = (chunkSize * 0.5).clamp(1.0, chunkSize.toDouble());
    planetRadius = _rnd.nextDoubleInRange(
      planetMinRadius,
      planetMaxRadius,
    );

    // Satellite distance
    satelliteMinDistance = planetRadius + ((chunkSize * 1.0) - planetRadius) * 0.1;

    // Position
    final x = _rnd.nextDoubleInRange(
      planetRadius,
      chunkSize - planetRadius,
    );
    final y = _rnd.nextDoubleInRange(
      planetRadius,
      chunkSize - planetRadius,
    );
    final planetLocalPosition = PointDouble(x, y);
    planetGlobalPosition = planetLocalPosition.toGlobal(
      chunkPosition,
      chunkSize,
    );

    // Satellite max distance
    final satelliteMaxDistanceValue = planetRadius + ((chunkSize * 1.0) - planetRadius) * 1.0;
    satelliteMaxDistance = _rnd.nextDoubleInRange(
      satelliteMinDistance,
      satelliteMaxDistanceValue,
    );

    // Satellite count
    if (_rnd.nextDouble() <= planetWithSatellitesProbability) {
      satellitesCount = _rnd.nextIntInRange(10, planetSatelliteMaxCount);
    } else {
      satellitesCount = 0;
    }
  }

  final satellites = <PlanetSatellite>[];

  for (int i = 0; i < satellitesCount; i++) {
    final satelliteRadius = _rnd.nextDoubleInRange(0.2, 0.4);

    final orbitData = OrbitData(
      a: _rnd.nextDoubleInRange(satelliteMinDistance, satelliteMaxDistance),
      b: _rnd.nextDoubleInRange(satelliteMinDistance, satelliteMaxDistance),
      inclination: _rnd.nextDouble() * math.pi * 2,
    );

    final satelliteInitAngle = math.pi * 2 * _rnd.nextDouble();

    final satelliteInitPosition = orbitData.evaluate(
      center: planetGlobalPosition,
      angle: satelliteInitAngle,
    );

    final satellite = PlanetSatellite(
      uid: const Uuid().v4(),
      radius: satelliteRadius,
      planetAngle: satelliteInitAngle,
      position: satelliteInitPosition,
      orbit: orbitData,
      revolutionsPerSecond: _rnd.nextDoubleInRange(0.001, 0.025),
      consuming: false,
      orbitVisible: i < GameConstants.drawMaxOrbits,
      terrain: _generatePlanetSatelliteTerrainUseCase(),
    );

    satellites.add(satellite);
  }

  return Planet(
    uid: planetUid,
    chunkSize: chunkSize,
    globalPosition: planetGlobalPosition,
    radius: planetRadius,
    spinSpeed: _rnd.nextDouble(),
    terrain: _generatePlanetTerrainUseCase(),
    satellites: satellites,
    satellitesCount: satellites.length,
    satelliteMaxOrbitDistance: satelliteMaxDistance,
    isInitialPlanet: isInitialPlanet,
    saved: false,
  );
}
