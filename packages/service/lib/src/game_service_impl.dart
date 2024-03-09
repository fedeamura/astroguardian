import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:repository/repository.dart';
import 'package:synchronized/synchronized.dart';
import 'package:usecase/usecase.dart';
import 'package:util/util.dart';
import 'package:uuid/uuid.dart';

import 'game_service_interface.dart';

class GameServiceImpl extends GameService {
  final GameRepository _gameRepository;
  final ChunkRepository _chunkRepository;
  final PlanetSummaryRepository _planetSummaryRepository;
  final GenerateMapUseCase _generateMapUseCase;
  final PlanetInfoRepository _planetInfoRepository;

  GameServiceImpl({
    required GameRepository gameRepository,
    required GenerateMapUseCase generateMapUseCase,
    required ChunkRepository chunkRepository,
    required PlanetSummaryRepository planetSummaryRepository,
    required PlanetInfoRepository planetInfoRepository,
  })  : _gameRepository = gameRepository,
        _chunkRepository = chunkRepository,
        _planetSummaryRepository = planetSummaryRepository,
        _generateMapUseCase = generateMapUseCase,
        _planetInfoRepository = planetInfoRepository;

  final _rnd = RandomUtil();
  final _lock = Lock();

  @override
  Future<List<Game>> getAll() => _gameRepository.getAll();

  @override
  Future<Game> createGame() async {
    final abilities = <ShipAbility, StepParameter>{};
    abilities[ShipAbility.bagSize] = StepParameter(
      maxLevel: 9,
      level: 0,
      minValue: 10,
      maxValue: 500,
    );
    abilities[ShipAbility.rayLength] = StepParameter(
      maxLevel: 9,
      level: 0,
      minValue: 4.0,
      maxValue: 10.0,
    );
    abilities[ShipAbility.raySpeed] = StepParameter(
      maxLevel: 9,
      level: 0,
      minValue: 3.0,
      maxValue: 20.0,
    );
    abilities[ShipAbility.rayCount] = StepParameter(
      maxLevel: 9,
      level: 0,
      minValue: 3.0,
      maxValue: 30.0,
    );

    final chunkSize = GameConstants.chunkSize;
    final planetProbability = GameConstants.planetProbability;
    final tutorialDistance = GameConstants.tutorialDistance;
    final planetWithSatellitesProbability = GameConstants.planetWithSatellitesProbability;
    final planetSatelliteMaxCount = GameConstants.planetSatelliteMaxCount;

    final globalTutorialDistance = chunkSize * tutorialDistance;

    final initialPlanetUid = const Uuid().v4();
    final initialPlanetDistance = _rnd.nextDoubleInRange(globalTutorialDistance * 0.4, globalTutorialDistance * 0.5);
    final initialPlanetAngle = _rnd.nextAngle();
    final initialPlanetGlobalPositionX = initialPlanetDistance * math.cos(initialPlanetAngle);
    final initialPlanetGlobalPositionY = initialPlanetDistance * math.sin(initialPlanetAngle);
    final initialPlanetGlobalPosition = PointDouble(initialPlanetGlobalPositionX, initialPlanetGlobalPositionY);
    const initialPlanetSatelliteCount = 50;
    const initialPlanetRadius = 5.0;
    const initialPlanetSatelliteMinDistance = 8.0;
    const initialPlanetSatelliteMaxDistance = 16.0;

    final model = Game(
      uid: const Uuid().v4(),
      createdAt: DateTime.now(),
      lastAccessAt: DateTime.now(),
      seed: _rnd.nextIntInRange(0, 9999999),
      planetProbability: planetProbability,
      planetWithSatellitesProbability: planetWithSatellitesProbability,
      planetSatelliteMaxCount: planetSatelliteMaxCount,
      chunkSize: chunkSize,
      tutorialDistance: tutorialDistance,
      initialPlanetUid: initialPlanetUid,
      initialPlanetGlobalPosition: initialPlanetGlobalPosition,
      initialPlanetSatelliteCount: initialPlanetSatelliteCount,
      initialPlanetRadius: initialPlanetRadius,
      initialPlanetSatelliteMinDistance: initialPlanetSatelliteMinDistance,
      initialPlanetSatelliteMaxDistance: initialPlanetSatelliteMaxDistance,
      experience: 0,
      totalExperience: 20,
      abilityPoints: 0,
      tutorial: true,
      mapMarker: initialPlanetGlobalPosition,
      mapMarkerColor: Colors.amber.value,
      mapMarkerVisible: true,
      mapMarkerTag: "map_$initialPlanetUid",
      conversations: {},
      ship: Ship(
        position: PointDouble(GameConstants.chunkSize * 0.5, GameConstants.chunkSize * 0.5),
        rotation: 0.0,
        rotationForce: 5.0,
        moveForce: 30.0,
        stopTime: 1.0,
        density: 0.01,
        bag: 0,
        bagDistance: 3,
        abilities: abilities,
        pendingAbilityPoints: 0,
      ),
    );

    await _gameRepository.save(model);
    return model;
  }

  // @override
  // Stream<List<Game>> streamAll() => _gameRepository.streamAll();

  // @override
  // Stream<Game?> streamByUid(String uid) => _gameRepository.streamByUid(uid);

  @override
  Future<void> delete(String uid) => _lock.synchronized(
        () async {
          await _chunkRepository.deleteAll(uid);
          await _gameRepository.delete(uid);
          await _planetSummaryRepository.delete(uid);
          await _planetInfoRepository.deleteAll(uid);
        },
      );

  @override
  Future<void> deleteAll() => _lock.synchronized(
        () async {
          final items = await _gameRepository.getAll();
          for (var element in items) {
            await _chunkRepository.deleteAll(element.uid);
            await _planetInfoRepository.deleteAll(element.uid);
            await _planetSummaryRepository.delete(element.uid);
          }

          await _gameRepository.deleteAll();
        },
      );

  @override
  Future<Game?> getByUid(String uid) => _gameRepository.getByUid(uid);

  @override
  Future<void> openGame(Game game) => _lock.synchronized(
        () async {
          game.lastAccessAt = DateTime.now();
          await _gameRepository.save(game);
          await _gameRepository.saveCurrentGame(game.uid);
        },
      );

  @override
  Future<void> save(Game game) async {
    await _lock.synchronized(() async {
      await _gameRepository.save(game);

      final chunks = game.chunks.entries.where((e) => e.value.dirty).toList();
      for (var element in chunks) {
        log("saving dirty chunk ${element.position}");
        await _chunkRepository.save(game.uid, element.value);

        final planet = element.value.planet;
        if (planet != null) {
          await _planetInfoRepository.updatePercentage(
            gameUid: game.uid,
            planetUid: planet.uid,
            percentage: planet.percentage,
          );
        }

        element.value.dirty = false;
      }

      if (chunks.isNotEmpty) {
        // log("${chunks.length} chunks saved");
      }
    });
  }

  @override
  Future<void> saveChunk(Game game, Chunk chunk) async {
    chunk.dirty = false;
    await _lock.synchronized(() async {
      await _chunkRepository.save(game.uid, chunk);

      final planet = chunk.planet;
      if (planet != null) {
        await _planetInfoRepository.updatePercentage(
          gameUid: game.uid,
          planetUid: planet.uid,
          percentage: planet.percentage,
        );
      }
    });
  }

  @override
  void removeSatellite({
    required Game game,
    required Planet planet,
    required PlanetSatellite satellite,
  }) {
    game.ship.bag += 1;
    planet.satellites.removeWhere((e) => e.uid == satellite.uid);
    planet.recalculateVisibleOrbits();

    final chunk = game.chunks.get(planet.chunkPosition);
    if (chunk != null) {
      chunk.dirty = true;
    }
  }

  @override
  void moveShip(Game game, PointDouble position) {
    _lock.synchronized(
      () => _generateMapUseCase.call(
        game: game,
        shipPosition: position.toInt(),
        renderDistance: GameConstants.renderDistance,
      ),
    );
  }

  @override
  bool increaseExperience(Game game, int value) {
    var levelUp = false;

    game.experience += value;
    if (game.experience >= game.totalExperience) {
      final rest = game.experience - game.totalExperience;
      game.experience = 0;
      game.abilityPoints += 1;
      game.totalExperience *= 2;

      final abilities = getShipAbilitiesCandidates(game);
      if (abilities.isNotEmpty) {
        game.ship.pendingAbilityPoints += 1;
        levelUp = true;
      }

      save(game);

      if (rest > 0) {
        if (increaseExperience(game, rest)) {
          levelUp = true;
        }
      }
    }

    return levelUp;
  }

  @override
  List<ShipAbility> getShipAbilitiesCandidates(Game game) {
    return game.ship.abilities.entries.where((e) => e.value.level < e.value.maxLevel).map((e) => e.key).toList();
  }

  @override
  bool increaseShipAbility(Game game, ShipAbility shipAbility) {
    if (game.ship.pendingAbilityPoints == 0) return false;
    final data = game.ship.abilities[shipAbility];
    if (data == null) return false;
    if (data.level >= data.maxLevel) return false;
    data.level += 1;
    game.ship.pendingAbilityPoints -= 1;
    return true;
  }

  @override
  void onPlanetVisible({
    required Game game,
    required Planet planet,
  }) {
    if (planet.saved) return;

    planet.saved = true;
    final chunk = game.chunks.get(planet.chunkPosition);
    if (chunk != null) {
      chunk.dirty = true;
    }
    save(game);

    _planetInfoRepository.insert(
      gameUid: game.uid,
      planet: planet.toInfo(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
      terrain: planet.terrain,
    );
  }

  // Current game
  @override
  Future<void> clearCurrentGame() => _gameRepository.saveCurrentGame("");

  @override
  Stream<String> get currentGameUidStream => _gameRepository.currentGameUidStream;

  @override
  String get currentGameUid => _gameRepository.currentGameUid;
}
