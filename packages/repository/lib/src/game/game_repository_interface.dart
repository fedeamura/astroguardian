import 'package:model/model.dart';

abstract class GameRepository {
  Future<void> save(Game game);

  Future<void> saveCurrentGame(String uid);

  String get currentGameUid;

  Stream<String> get currentGameUidStream;

  Future<Game?> getByUid(String uid);

  Future<void> delete(String uid);

  Future<void> deleteAll();

  // Stream<List<Game>> streamAll();

  Future<List<Game>> getAll();

  // Stream<Game?> streamByUid(String uid);
}
