import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/game_mask.dart';
import 'package:astro_guardian/game/planet/render.dart';
import 'package:astro_guardian/game/planet_satellite/planet_satellite.dart';
import 'package:astro_guardian/game/util/extension/point.dart';
import 'package:astro_guardian/game/util/images.dart';
import 'package:astro_guardian/game/util/lerp.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';

import 'satellites_orbit.dart';

class PlanetComponent extends BodyComponent<GameComponent> {
  final Planet planet;

  PlanetComponent({
    required this.planet,
  });

  final _satellites = <String, PlanetSatelliteComponent>{};
  PlanetRenderComponent? _planetRenderComponent;
  PlanetSatellitesOrbitComponent? _satellitesOrbitComponent;

  late ui.Image _checkImage;

  @override
  Future<void> onLoad() async {
    _checkImage = game.images.fromCache(GameImages.check.path);
    return super.onLoad();
  }

  @override
  void onRemove() {
    _satellites.forEach((key, value) => value.removeFromParent());
    _satellites.clear();
    super.onRemove();
  }

  @override
  Body createBody() {
    renderBody = false;

    final pos = planet.localPosition + (planet.chunkPosition.toDouble() * game.game.chunkSize);
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(pos.x.toDouble(), pos.y.toDouble()),
      type: BodyType.static,
    );

    final shape = CircleShape()..radius = planet.radius.toDouble();

    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.0,
      friction: 0.0,
      filter: Filter()
        ..maskBits = planetMask
        ..categoryBits = planetCategory,
    );
    final body = world.createBody(bodyDef);
    body.createFixture(fixtureDef);
    return body;
  }

  bool _isPlanetVisible = false;
  bool _isPlanetAndSatellitesVisible = false;

  double _percentageOpacity = 1.0;
  double _checkOpacity = 0.0;
  double _percentage = 0.0;

  @override
  void update(double dt) {
    super.update(dt);

    final isPlanetVisible = calculateIsPlanetVisible();
    if (_isPlanetVisible != isPlanetVisible) {
      _isPlanetVisible = isPlanetVisible;
      if (isPlanetVisible) {
        _onPlanetVisible();
      } else {
        _onPlanetInvisible();
      }
    }

    final isPlanetAndSatellitesVisible = calculatePlanetAndSatellitesVisible();
    if (_isPlanetAndSatellitesVisible != isPlanetAndSatellitesVisible) {
      _isPlanetAndSatellitesVisible = isPlanetAndSatellitesVisible;
      if (isPlanetAndSatellitesVisible) {
        _onPlanetAndSatellitesVisible();
      } else {
        _onPlanetAndSatellitesInvisible();
      }
    }

    if (isPlanetAndSatellitesVisible) {
      for (int i = 0; i < planet.satellites.length; i++) {
        final satellite = planet.satellites[i];
        _move(satellite, dt);
      }
    }

    _updateTutorial();

    _percentageOpacity = LerpUtils.d(
      dt,
      target: planet.isCompleted ? 0.0 : 1.0,
      value: _percentageOpacity,
      time: 0.1,
    );

    _checkOpacity = LerpUtils.d(
      dt,
      target: planet.isCompleted ? 1.0 : 0.0,
      value: _checkOpacity,
      time: 0.1,
    );

    _percentage = LerpUtils.d(
      dt,
      target: planet.percentage,
      value: _percentage,
      time: 0.1,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final isMainCamera = CameraComponent.currentCamera == game.camera;
    if (!isMainCamera) {
      canvas.drawCircle(
        const Offset(0, 0),
        planet.radius,
        Paint()..color = Colors.white,
      );

      canvas.drawImageRect(
        _checkImage,
        const Rect.fromLTWH(0, 0, 17, 17),
        Rect.fromLTWH(
          -planet.radius * 0.5,
          -planet.radius * 0.5,
          planet.radius,
          planet.radius,
        ),
        Paint(),
      );

      canvas.drawCircle(
        const Offset(0, 0),
        planet.radius,
        Paint()..color = Colors.white.withOpacity(1 - _checkOpacity),
      );

      final r = planet.radius * 0.8;

      canvas.drawArc(
        Rect.fromLTWH(
          -r,
          -r,
          r * 2,
          r * 2,
        ),
        0,
        math.pi * 2 * _percentage,
        true,
        Paint()..color = Colors.black.withOpacity(_percentageOpacity),
      );
    }
  }

  _onPlanetVisible() {
    _savePlanetInfo();

    _planetRenderComponent?.removeFromParent();
    _planetRenderComponent = null;

    final component = PlanetRenderComponent(planet: planet);
    component.anchor = Anchor.center;
    add(component);
    _planetRenderComponent = component;
  }

  _onPlanetInvisible() {
    _planetRenderComponent?.removeFromParent();
    _planetRenderComponent = null;
  }

  _onPlanetAndSatellitesVisible() {
    _satellites.forEach((key, value) => value.removeFromParent());
    _satellites.clear();

    _satellitesOrbitComponent?.removeFromParent();
    _satellitesOrbitComponent = null;

    final component = PlanetSatellitesOrbitComponent(planet);
    game.world.planetOrbitLayer.add(component);
    _satellitesOrbitComponent = component;
  }

  _onPlanetAndSatellitesInvisible() {
    _satellites.forEach((key, value) => value.removeFromParent());
    _satellites.clear();

    _satellitesOrbitComponent?.removeFromParent();
    _satellitesOrbitComponent = null;
  }

  _savePlanetInfo() {
    if (planet.saved) return;
    game.gameService.onPlanetVisible(
      game: game.game,
      planet: planet,
    );
  }

  _updateTutorial() {
    final isInitial = planet.isInitialPlanet;
    if (!isInitial) return;

    if (calculatePlanetTotallyVisible()) {
      game.showConversation?.call(ConversationType.tutorialPlanetFound);
    }

    final isEmpty = planet.satellites.isEmpty;
    if (isEmpty) {
      game.showConversation?.call(ConversationType.tutorialSatellitesCompleted);
    }
  }

  bool calculateIsPlanetVisible() {
    final projection = game.worldToScreen(planet.globalPosition.vector2);
    final projectionEndPoint = game.worldToScreen(
      planet.globalPosition.vector2 + Vector2(planet.radius, 0.0),
    );
    final radius = projectionEndPoint.distanceTo(projection);

    return game.size.toRect().overlaps(
          Rect.fromCircle(
            center: Offset(projection.x, projection.y),
            radius: radius,
          ),
        );
  }

  bool calculatePlanetAndSatellitesVisible() {
    final projection = game.worldToScreen(planet.globalPosition.vector2);
    final projectionEndPoint = game.worldToScreen(
      planet.globalPosition.vector2 + Vector2(planet.satelliteMaxOrbitDistance, 0.0),
    );
    final radius = projectionEndPoint.distanceTo(projection);

    return game.size.toRect().overlaps(
          Rect.fromCircle(
            center: Offset(projection.x, projection.y),
            radius: radius,
          ),
        );
  }

  bool calculatePlanetTotallyVisible() {
    final projection = game.worldToScreen(planet.globalPosition.vector2);
    final projectionEndPoint = game.worldToScreen(
      planet.globalPosition.vector2 + Vector2(planet.radius * 0.25, 0.0),
    );
    final radius = projectionEndPoint.distanceTo(projection);

    return game.size.toRect().overlaps(
          Rect.fromCircle(
            center: Offset(projection.x, projection.y),
            radius: radius,
          ),
        );
  }

  _move(PlanetSatellite satellite, double dt) {
    if (satellite.consuming) {
      // _moveToShip(satellite, dt);
    } else {
      _orbit(satellite, dt);
    }
  }

  void _moveToShip(PlanetSatellite satellite, double dt) {
    final satellitePosition = satellite.position.vector2;
    final shipPosition = game.world.shipComponent.position;
    final consumingSpeed = game.game.ship.raySpeed.value * dt;
    final direction = (shipPosition - satellitePosition).normalized();
    final newPosition = satellitePosition + direction * consumingSpeed;
    final distanceFromShip = newPosition.distanceTo(shipPosition) - 1.0;
    final newDistance = newPosition.distanceTo(planet.globalPosition.vector2);

    satellite.orbit.a = newDistance;
    satellite.orbit.b = newDistance;
    planet.recalculateSatelliteMaxOrbitDistance();

    satellite.planetAngle = satellite.orbit.calculateAngle(
      center: planet.globalPosition,
      position: PointDouble(newPosition.x, newPosition.y),
    );

    satellite.position.x = newPosition.x;
    satellite.position.y = newPosition.y;
    planet.satellitesVersion += 1;

    if (distanceFromShip < (satellite.radius * 1.5)) {
      _consumeSatellite(satellite);
    }
  }

  void _orbit(PlanetSatellite satellite, double dt) {
    final rps = satellite.revolutionsPerSecond;
    final newPlanetAngle = (satellite.planetAngle + (2 * math.pi * rps * dt)) % (math.pi * 2);
    final pos = satellite.orbit.evaluate(
      center: planet.globalPosition,
      angle: newPlanetAngle,
    );

    satellite.position.x = pos.x;
    satellite.position.y = pos.y;
    satellite.planetAngle = newPlanetAngle;

    final projection = game.worldToScreen(satellite.position.vector2);
    final visibleOnCamera = game.size.toRect().overlaps(
          Rect.fromLTWH(
            projection.x - satellite.radius,
            projection.t - satellite.radius,
            satellite.radius * 2,
            satellite.radius * 2,
          ),
        );

    var component = _satellites[satellite.uid];

    if (visibleOnCamera) {
      if (component == null) {
        final newComponent = PlanetSatelliteComponent(
          planetComponent: this,
          planet: planet,
          satellite: satellite,
        );

        game.world.planetSatelliteLayer.add(newComponent);
        _satellites[satellite.uid] = newComponent;
      }
    } else {
      if (component != null) {
        component.removeFromParent();
        _satellites.remove(satellite.uid);
      }
    }
  }

  _consumeSatellite(PlanetSatellite satellite) {
    final component = _satellites[satellite.uid];
    if (component != null) {
      _satellites.remove(satellite.uid);
      component.removeFromParent();
    }

    game.gameService.removeSatellite(
      game: game.game,
      planet: planet,
      satellite: satellite,
    );

    if (planet.isCompleted) {
      game.focusPlanet(planet);
    }
  }
}
