import 'package:model/model.dart';

abstract class PlanetSummaryRepository {
  Future<void> delete(String gameUid);

  Future<PlanetSummary?> get(String gameUid);

  Future<void> save(String gameUid, PlanetSummary planetSummary);
}
