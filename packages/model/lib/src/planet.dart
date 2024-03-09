import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:model/model.dart';
import 'package:util/util.dart';

part 'planet.g.dart';

@JsonSerializable(explicitToJson: true)
class Planet {
  final String uid;
  final int chunkSize;
  final PointDouble globalPosition;
  final double radius;
  final double spinSpeed;
  final int satellitesCount;
  final bool isInitialPlanet;
  double satelliteMaxOrbitDistance;
  final List<PlanetSatellite> satellites;
  bool saved;

  final PlanetTerrain terrain;

  @JsonKey(includeToJson: false, includeFromJson: false)
  int _satellitesVersion;

  Planet({
    required this.uid,
    required this.chunkSize,
    required this.globalPosition,
    required this.radius,
    required this.terrain,
    required this.spinSpeed,
    required this.satellitesCount,
    required this.satellites,
    required this.satelliteMaxOrbitDistance,
    required this.isInitialPlanet,
    required this.saved,
    int satellitesVersion = 0,
  }) : _satellitesVersion = satellitesVersion;

  factory Planet.fromJson(Map<String, dynamic> json) => _$PlanetFromJson(json);

  Map<String, dynamic> toJson() => _$PlanetToJson(this);

  double get percentage {
    if (satellitesCount == 0) return 1.0;
    return 1 - (satellites.length / satellitesCount).clamp(0.0, 1.0);
  }

  bool get isCompleted {
    return percentage == 1.0;
  }

  int get satellitesVersion => _satellitesVersion;

  set satellitesVersion(int version) {
    _satellitesVersion = version % 9999999;
  }

  void recalculateSatelliteMaxOrbitDistance() {
    double max = 0;
    for (var element in satellites) {
      final value = element.orbit.maxSize;
      if (value > max) {
        max = value;
      }
    }

    satelliteMaxOrbitDistance = max;
  }

  void forceVisibleOrbit(String uid) {
    final satellite = satellites.firstWhereOrNull((e) => e.uid == uid);
    if (satellite == null) {
      return;
    }

    if (satellite.orbitVisible) {
      return;
    }

    satellite.orbitVisible = true;

    final notVisible = satellites.firstWhereOrNull((e) => !e.orbitVisible);
    if (notVisible != null) {
      notVisible.orbitVisible = false;
    }
  }

  void recalculateVisibleOrbits() {
    final withOrbit = satellites.where((e) => e.orbitVisible).toList();

    if (withOrbit.length > GameConstants.drawMaxOrbits) {
      final rest = withOrbit.length - GameConstants.drawMaxOrbits;
      withOrbit.shuffle();
      withOrbit.take(rest).forEach((element) {
        element.orbitVisible = false;
      });
      return;
    }

    final max = math.min(GameConstants.drawMaxOrbits, satellites.length);
    final rest = max - withOrbit.length;
    if (rest > 0) {
      final notVisible = satellites.where((e) => !e.orbitVisible).toList()..shuffle();
      notVisible.take(rest).forEach((element) {
        element.orbitVisible = true;
      });
    }
  }

  PointDouble get localPosition => globalPosition.toLocal(chunkSize);

  PointInt get chunkPosition => globalPosition.toChunk(chunkSize);

  PlanetInfo toInfo({
    required int createdAt,
    required int? updatedAt,
  }) =>
      PlanetInfo(
        uid: uid,
        position: globalPosition,
        radius: radius,
        percentage: percentage,
        spinSpeed: spinSpeed,
        createdAt: createdAt,
        updatedAt: updatedAt ?? createdAt,
      );
}
