import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:astro_guardian/game/game.dart';
import 'package:astro_guardian/game/game_mask.dart';
import 'package:astro_guardian/game/planet/planet.dart';
import 'package:astro_guardian/game/util/extension/point.dart';
import 'package:astro_guardian/game/util/lerp.dart';
import 'package:astro_guardian/game/util/painter/image.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:util/util.dart';

class PlanetSatelliteComponent extends BodyComponent<GameComponent> {
  final PlanetComponent planetComponent;
  final Planet planet;
  final PlanetSatellite satellite;

  PlanetSatelliteComponent({
    required this.planetComponent,
    required this.satellite,
    required this.planet,
  });

  late SpriteComponent _spriteComponent;

  @override
  Future<void> onLoad() async {
    final resolution = satellite.terrain.resolution;
    _spriteComponent = SpriteComponent(
      anchor: Anchor.center,
      size: Vector2.all(satellite.radius * 2),
      position: -Vector2.all(0.075),
      sprite: Sprite(
        _createImage(),
        srcSize: Vector2.all(resolution.toDouble()),
      ),
    );
    _spriteComponent.opacity = 0.2;
    await add(_spriteComponent);

    return super.onLoad();
  }

  @override
  Body createBody() {
    renderBody = false;

    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(satellite.position.x, satellite.position.y),
      type: BodyType.dynamic,
    );

    final body = world.createBody(bodyDef);
    body.createFixture(
      FixtureDef(
        CircleShape()..radius = satellite.radius,
        filter: Filter()
          ..maskBits = satelliteMask
          ..categoryBits = satelliteCategory,
      ),
    );

    return body;
  }

  double _scale = 1.0;
  double _opacity = 1.0;

  @override
  void update(double dt) {
    body.setTransform(satellite.position.vector2, 0.0);

    final angleToCenter = math.atan2(
      planet.globalPosition.y - satellite.position.y,
      planet.globalPosition.x - satellite.position.x,
    );

    body.setTransform(satellite.position.vector2, angleToCenter);

    double distanceToShipPercentage = 1.0;
    if (satellite.consuming) {
      final shipPosition = game.world.shipComponent.position;
      final distanceToShip = shipPosition.distanceTo(satellite.position.vector2);
      final maxDistance = game.game.ship.rayLength.value;
      distanceToShipPercentage = (distanceToShip / maxDistance).clamp(0.0, 1.0);
    }

    _scale = LerpUtils.d(
      dt,
      target: satellite.consuming
          ? 1.5 *
              MathRangeUtil.multiRange(
                distanceToShipPercentage,
                [0.0, 0.25, 0.75, 1.0],
                [0.0, 0.0, 0.5, 1.0],
              )
          : 1.0,
      value: _scale,
      time: 0.1,
    );

    _opacity = LerpUtils.d(
      dt,
      target: satellite.consuming
          ? MathRangeUtil.multiRange(
              distanceToShipPercentage,
              [0.00, 0.3, 1.00],
              [0.00, 0.0, 1.00],
            )
          : 1.0,
      value: _opacity,
      time: 0.1,
    );
    _spriteComponent.scale = Vector2.all(_scale);

    super.update(dt);
  }

  ui.Image _createImage() => ImagePainterUtil.drawPixels(
        w: satellite.terrain.resolution,
        h: satellite.terrain.resolution,
        paint: Paint()..color = Color(satellite.terrain.color),
        points: [
          for (var element in satellite.terrain.terrain.entries.where((e) => e.value == true))
            CanvasPixelModel(
              x: element.position.x,
              y: element.position.y,
            ),
          for (var element in satellite.terrain.border.entries.where((e) => e.value == true))
            CanvasPixelModel(
              x: element.position.x,
              y: element.position.y,
              paint: Paint()..color = Colors.white.withOpacity(0.4),
            ),
        ],
      );

  double _spriteOpacity = 0.0;

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);
    final isMainCamera = CameraComponent.currentCamera == game.camera;

    double o;
    if (!isMainCamera) {
      o = 0.0;
    } else {
      o = _opacity.clamp(0.0, 1.0);
    }

    if (o != _spriteOpacity) {
      _spriteOpacity = o;
      _spriteComponent.opacity = o;
    }
  }
}
