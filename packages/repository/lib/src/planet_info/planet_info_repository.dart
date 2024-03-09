import 'package:adapter/adapter.dart';
import 'package:model/model.dart';
import 'package:synchronized/synchronized.dart';

import 'isolate/parse_planet_info/isolate.dart';
import 'isolate/parse_planet_terrain/isolate.dart';
import 'planet_info_repository_interface.dart';

class PlanetInfoRepositoryImpl extends PlanetInfoRepository {
  final DataService _dataService;

  PlanetInfoRepositoryImpl({
    required DataService dataService,
  }) : _dataService = dataService;

  late ParsePlanetInfoIsolate _parseInfoIsolate;
  late ParsePlanetTerrainIsolate _parseTerrainIsolate;

  String _collectionName(String gameUid) => "planet_info_$gameUid";

  String _collectionTerrainName(String gameUid) => "planet_info_terrain_$gameUid";

  Future<void> init() async {
    _parseInfoIsolate = ParsePlanetInfoIsolate();
    await _parseInfoIsolate.init();

    _parseTerrainIsolate = ParsePlanetTerrainIsolate();
    await _parseTerrainIsolate.init();
  }

  @override
  Future<void> deleteAll(String gameUid) {
    return _dataService.deleteAll(_collectionName(gameUid));
  }

  @override
  Future<List<PlanetInfo>> getAll(String gameUid) async {
    final items = await _dataService.getAll(
      _collectionName(gameUid),
      parser: _parseInfoIsolate.parse,
    );
    return items;
  }

  @override
  Future<void> insert({
    required String gameUid,
    required PlanetInfo planet,
    required PlanetTerrain terrain,
  }) async {
    await _dataService.save(
      collection: _collectionName(gameUid),
      uid: planet.uid,
      provider: () => _parseInfoIsolate.encode(planet),
    );

    await _dataService.save(
      collection: _collectionTerrainName(gameUid),
      uid: planet.uid,
      provider: () => _parseTerrainIsolate.encode(terrain),
    );
  }

  final _lock = Lock();

  @override
  Future<void> updatePercentage({
    required String gameUid,
    required String planetUid,
    required double percentage,
  }) async {
    await _lock.synchronized(() async {
      final entity = await _dataService.getByUid(
        collection: _collectionName(gameUid),
        uid: planetUid,
        parser: _parseInfoIsolate.parse,
      );
      if (entity != null && entity.percentage != percentage) {
        await _dataService.save(
          collection: _collectionName(gameUid),
          uid: planetUid,
          provider: () => _parseInfoIsolate.encode(
            PlanetInfo(
              uid: entity.uid,
              position: entity.position,
              radius: entity.radius,
              percentage: percentage,
              spinSpeed: entity.spinSpeed,
              createdAt: entity.createdAt,
              updatedAt: DateTime.now().millisecondsSinceEpoch,
            ),
          ),
        );
      }
    });
  }

  @override
  Future<int> getCount(String gameUid) {
    return _dataService.getLength(_collectionName(gameUid));
  }

  @override
  Future<PlanetTerrain?> getTerrain({
    required String gameUid,
    required String planetUid,
  }) {
    return _dataService.getByUid(
      collection: _collectionTerrainName(gameUid),
      uid: planetUid,
      parser: _parseTerrainIsolate.parse,
    );
  }
}
