import 'package:astro_guardian/game/planet/planet.dart';
import 'package:astro_guardian/game/planet_satellite/planet_satellite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class ShipRayCastCallback extends RayCastCallback {
  final String uid;
  final _satelliteUid = <String>{};
  final _satellites = <double, PlanetSatelliteCollideResult>{};

  double _planetFraction = -1;

  ShipRayCastCallback(this.uid);

  @override
  double reportFixture(
    Fixture fixture,
    Vector2 point,
    Vector2 normal,
    double fraction,
  ) {
    final component = fixture.body.userData;
    if (component is PlanetComponent) {
      _planetFraction = fraction;
    }

    if (component is PlanetSatelliteComponent) {
      final uid = component.satellite.uid;

      if (!_satelliteUid.contains(uid)) {
        _satelliteUid.add(uid);

        _satellites[fraction] = PlanetSatelliteCollideResult(
          component: component,
          point: point.clone(),
        );
      }
    }

    return -1;
  }

  List<PlanetSatelliteCollideResult> get satellites {
    if (_planetFraction == -1) return _satellites.entries.map((e) => e.value).toList();
    return _satellites.entries.where((e) => e.key < _planetFraction).map((e) => e.value).toList();
  }
}

abstract class RaycastCollideResult {
  final Vector2 point;

  RaycastCollideResult({required this.point});
}

class PlanetSatelliteCollideResult extends RaycastCollideResult {
  final PlanetSatelliteComponent component;

  PlanetSatelliteCollideResult({
    required this.component,
    required super.point,
  });
}
