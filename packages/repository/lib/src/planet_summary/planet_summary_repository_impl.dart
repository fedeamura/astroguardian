import 'package:adapter/adapter.dart';
import 'package:model/model.dart';

import 'isolate/isolate.dart';
import 'planet_summary_repository_interface.dart';

class PlanetSummaryRepositoryImpl extends PlanetSummaryRepository {
  final DataService _dataService;

  PlanetSummaryRepositoryImpl({
    required DataService dataService,
  }) : _dataService = dataService;

  late ParsePlanetSummaryIsolate _parseIsolate;

  Future<void> init() async {
    _parseIsolate = ParsePlanetSummaryIsolate();
    await _parseIsolate.init();
  }

  @override
  Future<void> delete(String gameUid) => _dataService.deleteAll("planet_summary_$gameUid");

  @override
  Future<PlanetSummary?> get(String gameUid) => _dataService.getByUid(
        collection: "planet_summary_$gameUid",
        uid: gameUid,
        parser: _parseIsolate.parse,
      );

  @override
  Future<void> save(String gameUid, PlanetSummary planetSummary) => _dataService.save(
        collection: "planet_summary_$gameUid",
        uid: gameUid,
        provider: () => _parseIsolate.encode(planetSummary),
      );
}
