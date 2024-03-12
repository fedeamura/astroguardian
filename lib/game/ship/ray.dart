import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/planet_satellite/planet_satellite.dart';
import 'package:astro_guardian/game/ship/ray_render.dart';
import 'package:astro_guardian/game/util/extension/point.dart';
import 'package:astro_guardian/game/util/raycast/raycast.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ShipRayComponent extends PositionComponent with HasGameRef<GameComponent> {
  Vector2? from;
  var toPoints = <Vector2>[];

  var selectedPoints = <Vector2>[];
  var selectedSatellites = <String, PlanetSatelliteComponent>{};
  final _selected = <PlanetSatelliteComponent>[];
  final _selectedUid = <String>{};

  late final ShipRayRenderComponent _renderComponent;

  @override
  FutureOr<void> onLoad() async {
    _renderComponent = ShipRayRenderComponent();
    await add(_renderComponent);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _process(dt);
    super.update(dt);
  }

  bool get isConsuming {
    return game.keyConsumePressed && !game.game.ship.isBagFull;
  }

  _process(double dt) {
    if (!isConsuming) {
      game.keyConsumePressed = false;
      for (var element in _selected) {
        element.satellite.consuming = false;
      }

      this.from = null;
      this.toPoints = [];
      selectedPoints = [];
      selectedSatellites = {};
      _selected.clear();
      _selectedUid.clear();
      return;
    }

    final shipComponent = game.world.shipComponent;
    final from = shipComponent.localToParent(Vector2(0.0, -0.5));
    final length = game.game.ship.rayLength.value;

    final toPoints = <Vector2>[];
    const maxAngle = 2 * math.pi * 0.20;
    const rayCount = 100;
    const step = maxAngle / rayCount;

    final candidatesUid = <String>{};
    final candidates = <PlanetSatelliteComponent>[];

    final bag = game.game.ship.bag;
    final maxBag = game.game.ship.bagSize.value.floor();
    final availableBagSpace = maxBag - bag;

    var maxCount = game.game.ship.rayCount.value.floor();
    maxCount = maxCount.clamp(0, availableBagSpace);

    // Calculate all the candidates
    for (int i = 0; i < rayCount; i++) {
      final angle = shipComponent.body.angle - math.pi * 0.5 + i * step - (maxAngle * 0.5);
      final to = Vector2(
        from.x + length * math.cos(angle),
        from.y + length * math.sin(angle),
      );

      toPoints.add(to);

      final raycast = ShipRayCastCallback(const Uuid().v4());
      game.world.raycast(raycast, from, to);

      final satellites = raycast.satellites;
      if (satellites.isNotEmpty) {
        for (var satellite in satellites) {
          final uid = satellite.component.satellite.uid;
          if (!candidatesUid.contains(uid)) {
            candidatesUid.add(uid);
            candidates.add(satellite.component);
          }
        }
      }
    }

    // Remove selected satellites that are not in the candidate list
    final toRemove = <String>{};
    for (var uid in _selectedUid) {
      if (!candidatesUid.contains(uid)) {
        toRemove.add(uid);
      }
    }

    if (toRemove.isNotEmpty) {
      for (var uid in toRemove) {
        _selectedUid.remove(uid);
        selectedSatellites.remove(uid);
        _selected.removeWhere((e) {
          if (e.satellite.uid == uid) {
            e.satellite.consuming = false;
            return true;
          }

          return false;
        });
      }
    }

    // Add new satellites to the selected list
    final rest = maxCount - _selected.length;
    if (rest > 0 && candidates.isNotEmpty) {
      // Sort by distance from ship
      candidates.sort(
        (a, b) {
          final d1 = a.satellite.position.vector2.distanceTo(from);
          final d2 = b.satellite.position.vector2.distanceTo(from);
          return d1.compareTo(d2);
        },
      );

      // Add satellites from the candidate list to the selected list if not already added.
      for (var candidate in candidates) {
        if (_selectedUid.length >= maxCount) {
          break;
        }

        final uid = candidate.satellite.uid;
        if (!_selectedUid.contains(uid)) {
          candidate.satellite.consuming = true;
          _selected.add(candidate);
          _selectedUid.add(uid);
          selectedSatellites[uid] = candidate;
          candidate.planet.forceVisibleOrbit(uid);
        }
      }
    }

    this.from = from;
    this.toPoints = toPoints;
    selectedPoints = _selected.map((e) => e.satellite.position.vector2).toList();
  }
   
}
