import 'package:model/model.dart';

abstract class PlanetInfoRepository {
  Future<void> insert({
    required String gameUid,
    required PlanetInfo planet,
    required PlanetTerrain terrain,
  });

  Future<void> updatePercentage({
    required String gameUid,
    required String planetUid,
    required double percentage,
  });

  Future<void> deleteAll(String gameUid);

  Future<int> getCount(String gameUid);

  Future<List<PlanetInfo>> getAll(String gameUid);

  Future<PlanetTerrain?> getTerrain({
    required String gameUid,
    required String planetUid,
  });
}
