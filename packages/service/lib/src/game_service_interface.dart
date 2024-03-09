import 'package:model/model.dart';

abstract class GameService {
  Future<Game> createGame();

  Future<List<Game>> getAll();

  Future<void> delete(String uid);

  Future<void> deleteAll();

  Future<Game?> getByUid(String uid);

  Future<void> openGame(Game game);

  Future<void> save(Game game);

  Future<void> saveChunk(Game game, Chunk chunk);

  void removeSatellite({
    required Game game,
    required Planet planet,
    required PlanetSatellite satellite,
  });

  void moveShip(Game game, PointDouble position);

  bool increaseExperience(Game game, int value);

  List<ShipAbility> getShipAbilitiesCandidates(Game game);

  bool increaseShipAbility(Game game, ShipAbility shipAbility);

  void onPlanetVisible({
    required Game game,
    required Planet planet,
  });

  // Current game
  Future<void> clearCurrentGame();

  Stream<String> get currentGameUidStream;

  String get currentGameUid;
}
