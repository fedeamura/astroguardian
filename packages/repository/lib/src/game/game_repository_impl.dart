import 'package:adapter/adapter.dart';
import 'package:model/model.dart';
import 'package:synchronized/synchronized.dart';

import 'game_repository_interface.dart';
import 'isolate/isolate.dart';

class GameRepositoryImpl extends GameRepository {
  final DataService _dataService;
  final SettingsService _settingsService;

  GameRepositoryImpl({
    required DataService dataService,
    required SettingsService settingsService,
  })  : _dataService = dataService,
        _settingsService = settingsService;

  final String _collection = "game";
  final String _currentMapKey = "current_game";
  late ParseGameIsolate _parseIsolate;

  final _lock = Lock();

  Future<void> init() async {
    _parseIsolate = ParseGameIsolate();
    await _parseIsolate.init();
  }

  @override
  Future<void> save(Game game) {
    // To ensure to only send the necessary data to the isolate
    final copy = game.generateCopy();

    return _dataService.save(
      collection: _collection,
      uid: copy.uid,
      provider: () => _parseIsolate.encode(copy),
    );
  }

  @override
  Future<void> saveCurrentGame(String uid) => _settingsService.saveString(
        _currentMapKey,
        uid,
      );

  @override
  String get currentGameUid => _settingsService.getString(
        _currentMapKey,
        defaultValue: "",
      );

  @override
  Stream<String> get currentGameUidStream => _settingsService.streamString(
        _currentMapKey,
        defaultValue: "",
      );

  @override
  Future<Game?> getByUid(String uid) => _dataService.getByUid(
        collection: _collection,
        uid: uid,
        parser: _parseIsolate.parse,
      );

  @override
  Future<void> delete(String uid) async {
    await _lock.synchronized(() async {
      await _dataService.delete(
        collection: _collection,
        uid: uid,
      );

      if (currentGameUid == uid) {
        await saveCurrentGame("");
      }
    });
  }

  @override
  Future<void> deleteAll() async {
    await _lock.synchronized(() async {
      await _dataService.deleteAll(_collection);
      await saveCurrentGame("");
    });
  }

  @override
  Future<List<Game>> getAll() => _dataService.getAll(
        _collection,
        parser: _parseIsolate.parse,
      );
}
